#!/usr/bin/env swift

/*
# Mouse Tracker Setup Guide

This script monitors mouse clicks and distance traveled system-wide on macOS.
The metrics are persisted to /tmp/mouse_*.txt and saved every 10 seconds.

## Initial Setup (for new MacBook)

1. Compile the Swift script to a binary:
   ```bash
   cd ~/dotfiles/bin
   swiftc -o mouse_tracker mouse_tracker.swift
   mkdir -p ~/bin
   mv mouse_tracker ~/bin/
   ```

2. Create LaunchAgent plist at ~/Library/LaunchAgents/com.user.mouse-tracker.plist:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>Label</key>
       <string>com.user.mouse-tracker</string>
       <key>ProgramArguments</key>
       <array>
           <string>/Users/victor.peng/bin/mouse_tracker</string>
       </array>
       <key>RunAtLoad</key>
       <true/>
       <key>KeepAlive</key>
       <true/>
       <key>StandardOutPath</key>
       <string>/tmp/mouse_tracker.log</string>
       <key>StandardErrorPath</key>
       <string>/tmp/mouse_tracker.err</string>
   </dict>
   </plist>
   ```

3. Grant Accessibility permissions:
   - Open System Settings → Privacy & Security → Accessibility
   - Click the "+" button
   - Navigate to ~/bin/mouse_tracker
   - Enable the checkbox for the binary

4. Load the LaunchAgent to start the daemon:
   ```bash
   launchctl load ~/Library/LaunchAgents/com.user.mouse-tracker.plist
   ```

5. Verify it's running:
   ```bash
   launchctl list | grep mouse-tracker
   cat /tmp/mouse_clicks.txt
   cat /tmp/mouse_distance.txt
   ```

## Integration with mac_stats.sh

To send mouse metrics to DataDog, add this to mac_stats.sh:

```bash
# Mouse clicks counter
if [ -f /tmp/mouse_clicks.txt ]; then
    mouse_clicks=$(cat /tmp/mouse_clicks.txt)
    if [ -n "$mouse_clicks" ]; then
        metric="macos.mouse.clicks_total:$mouse_clicks"
        printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
    fi
fi

# Mouse distance traveled (pixels)
if [ -f /tmp/mouse_distance.txt ]; then
    mouse_distance=$(cat /tmp/mouse_distance.txt)
    if [ -n "$mouse_distance" ]; then
        metric="macos.mouse.distance_pixels:$mouse_distance"
        printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
    fi
fi
```

## Troubleshooting

- If the LaunchAgent shows exit code 1, check /tmp/mouse_tracker.err
- The most common issue is missing Accessibility permissions
- To reload after changes: `launchctl unload` then `launchctl load` the plist
- Check if running: `ps aux | grep mouse_tracker`
*/

import Cocoa
import Foundation

// Counter files to persist metrics
let clicksFile = "/tmp/mouse_clicks.txt"
let leftClicksFile = "/tmp/mouse_left_clicks.txt"
let rightClicksFile = "/tmp/mouse_right_clicks.txt"
let otherClicksFile = "/tmp/mouse_other_clicks.txt"
let distanceFile = "/tmp/mouse_distance.txt"

// Read current counts
func readCount(from file: String) -> Int {
    if let data = try? String(contentsOfFile: file, encoding: .utf8),
       let count = Int(data.trimmingCharacters(in: .whitespacesAndNewlines)) {
        return count
    }
    return 0
}

func readDistance(from file: String) -> Double {
    if let data = try? String(contentsOfFile: file, encoding: .utf8),
       let distance = Double(data.trimmingCharacters(in: .whitespacesAndNewlines)) {
        return distance
    }
    return 0.0
}

// Write counts to files
func writeCount(_ count: Int, to file: String) {
    try? String(count).write(toFile: file, atomically: true, encoding: .utf8)
}

func writeDistance(_ distance: Double, to file: String) {
    try? String(Int(distance)).write(toFile: file, atomically: true, encoding: .utf8)
}

var clickCount = readCount(from: clicksFile)
var leftClickCount = readCount(from: leftClicksFile)
var rightClickCount = readCount(from: rightClicksFile)
var otherClickCount = readCount(from: otherClicksFile)
var mouseDistance = readDistance(from: distanceFile)
var lastMousePosition: CGPoint? = nil

// Create event tap to monitor mouse events
let eventMask = (1 << CGEventType.leftMouseDown.rawValue) |
                (1 << CGEventType.rightMouseDown.rawValue) |
                (1 << CGEventType.otherMouseDown.rawValue) |
                (1 << CGEventType.mouseMoved.rawValue)

guard let eventTap = CGEvent.tapCreate(
    tap: .cgSessionEventTap,
    place: .headInsertEventTap,
    options: .defaultTap,
    eventsOfInterest: CGEventMask(eventMask),
    callback: { (proxy, type, event, refcon) in
        let userInfo = refcon?.assumingMemoryBound(to: UserInfo.self).pointee

        switch type {
        case .leftMouseDown, .rightMouseDown, .otherMouseDown:
            // Increment click counter
            userInfo?.clickCount.pointee += 1

        case .mouseMoved:
            // Track mouse distance
            let currentLocation = event.location
            if let lastPos = userInfo?.lastPosition.pointee {
                let dx = currentLocation.x - lastPos.x
                let dy = currentLocation.y - lastPos.y
                let distance = sqrt(dx * dx + dy * dy)
                userInfo?.distance.pointee += distance
            }
            userInfo?.lastPosition.pointee = currentLocation

        default:
            break
        }

        return Unmanaged.passUnretained(event)
    },
    userInfo: nil
) else {
    print("Failed to create event tap. Please grant Accessibility permissions.")
    exit(1)
}

// User info structure to pass to callback
struct UserInfo {
    var clickCount: UnsafeMutablePointer<Int>
    var leftClickCount: UnsafeMutablePointer<Int>
    var rightClickCount: UnsafeMutablePointer<Int>
    var otherClickCount: UnsafeMutablePointer<Int>
    var distance: UnsafeMutablePointer<Double>
    var lastPosition: UnsafeMutablePointer<CGPoint>
}

// Allocate memory for tracking
var clickCountPtr = UnsafeMutablePointer<Int>.allocate(capacity: 1)
clickCountPtr.initialize(to: clickCount)

var leftClickCountPtr = UnsafeMutablePointer<Int>.allocate(capacity: 1)
leftClickCountPtr.initialize(to: leftClickCount)

var rightClickCountPtr = UnsafeMutablePointer<Int>.allocate(capacity: 1)
rightClickCountPtr.initialize(to: rightClickCount)

var otherClickCountPtr = UnsafeMutablePointer<Int>.allocate(capacity: 1)
otherClickCountPtr.initialize(to: otherClickCount)

var distancePtr = UnsafeMutablePointer<Double>.allocate(capacity: 1)
distancePtr.initialize(to: mouseDistance)

var lastPosPtr = UnsafeMutablePointer<CGPoint>.allocate(capacity: 1)
if let currentPos = NSEvent.mouseLocation as CGPoint? {
    lastPosPtr.initialize(to: currentPos)
} else {
    lastPosPtr.initialize(to: CGPoint.zero)
}

var userInfo = UserInfo(
    clickCount: clickCountPtr,
    leftClickCount: leftClickCountPtr,
    rightClickCount: rightClickCountPtr,
    otherClickCount: otherClickCountPtr,
    distance: distancePtr,
    lastPosition: lastPosPtr
)

// Recreate event tap with user info
let eventTapWithInfo = CGEvent.tapCreate(
    tap: .cgSessionEventTap,
    place: .headInsertEventTap,
    options: .defaultTap,
    eventsOfInterest: CGEventMask(eventMask),
    callback: { (proxy, type, event, refcon) in
        guard let refcon = refcon else { return Unmanaged.passUnretained(event) }
        let userInfo = refcon.assumingMemoryBound(to: UserInfo.self).pointee

        switch type {
        case .leftMouseDown:
            userInfo.clickCount.pointee += 1
            userInfo.leftClickCount.pointee += 1

        case .rightMouseDown:
            userInfo.clickCount.pointee += 1
            userInfo.rightClickCount.pointee += 1

        case .otherMouseDown:
            userInfo.clickCount.pointee += 1
            userInfo.otherClickCount.pointee += 1

        case .mouseMoved:
            let currentLocation = event.location
            let lastPos = userInfo.lastPosition.pointee
            let dx = currentLocation.x - lastPos.x
            let dy = currentLocation.y - lastPos.y
            let distance = sqrt(dx * dx + dy * dy)
            userInfo.distance.pointee += distance
            userInfo.lastPosition.pointee = currentLocation

        default:
            break
        }

        return Unmanaged.passUnretained(event)
    },
    userInfo: &userInfo
)!

// Create run loop source and add to current run loop
let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTapWithInfo, 0)
CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
CGEvent.tapEnable(tap: eventTapWithInfo, enable: true)

// Save counts every 10 seconds
Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
    writeCount(clickCountPtr.pointee, to: clicksFile)
    writeCount(leftClickCountPtr.pointee, to: leftClicksFile)
    writeCount(rightClickCountPtr.pointee, to: rightClicksFile)
    writeCount(otherClickCountPtr.pointee, to: otherClicksFile)
    writeDistance(distancePtr.pointee, to: distanceFile)
}

// Handle termination gracefully
signal(SIGINT) { _ in
    writeCount(clickCountPtr.pointee, to: clicksFile)
    writeCount(leftClickCountPtr.pointee, to: leftClicksFile)
    writeCount(rightClickCountPtr.pointee, to: rightClicksFile)
    writeCount(otherClickCountPtr.pointee, to: otherClicksFile)
    writeDistance(distancePtr.pointee, to: distanceFile)
    clickCountPtr.deallocate()
    leftClickCountPtr.deallocate()
    rightClickCountPtr.deallocate()
    otherClickCountPtr.deallocate()
    distancePtr.deallocate()
    lastPosPtr.deallocate()
    exit(0)
}
signal(SIGTERM) { _ in
    writeCount(clickCountPtr.pointee, to: clicksFile)
    writeCount(leftClickCountPtr.pointee, to: leftClicksFile)
    writeCount(rightClickCountPtr.pointee, to: rightClicksFile)
    writeCount(otherClickCountPtr.pointee, to: otherClicksFile)
    writeDistance(distancePtr.pointee, to: distanceFile)
    clickCountPtr.deallocate()
    leftClickCountPtr.deallocate()
    rightClickCountPtr.deallocate()
    otherClickCountPtr.deallocate()
    distancePtr.deallocate()
    lastPosPtr.deallocate()
    exit(0)
}

print("Mouse tracker started. Metrics will be saved to \(clicksFile) and \(distanceFile)")
CFRunLoopRun()
