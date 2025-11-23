#!/usr/bin/env swift

/*
# Keystroke Counter Setup Guide

This script monitors and counts all keystrokes system-wide on macOS.
The count is persisted to /tmp/keystroke_count.txt and saved every 10 seconds.

## Initial Setup (for new MacBook)

1. Compile the Swift script to a binary:
   ```bash
   cd ~/dotfiles/bin
   swiftc -o keystroke_counter keystroke_counter.swift
   mkdir -p ~/bin
   mv keystroke_counter ~/bin/
   ```

2. Create LaunchAgent plist at ~/Library/LaunchAgents/com.user.keystroke-counter.plist:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>Label</key>
       <string>com.user.keystroke-counter</string>
       <key>ProgramArguments</key>
       <array>
           <string>/Users/victor.peng/bin/keystroke_counter</string>
       </array>
       <key>RunAtLoad</key>
       <true/>
       <key>KeepAlive</key>
       <true/>
       <key>StandardOutPath</key>
       <string>/tmp/keystroke_counter.log</string>
       <key>StandardErrorPath</key>
       <string>/tmp/keystroke_counter.err</string>
   </dict>
   </plist>
   ```

3. Grant Accessibility permissions:
   - Open System Settings → Privacy & Security → Accessibility
   - Click the "+" button
   - Navigate to ~/bin/keystroke_counter
   - Enable the checkbox for the binary

4. Load the LaunchAgent to start the daemon:
   ```bash
   launchctl load ~/Library/LaunchAgents/com.user.keystroke-counter.plist
   ```

5. Verify it's running:
   ```bash
   launchctl list | grep keystroke-counter
   cat /tmp/keystroke_count.txt
   ```

## Integration with mac_stats.sh

To send keystroke metrics to DataDog, add this to mac_stats.sh:

```bash
# Keystroke counter
if [ -f /tmp/keystroke_count.txt ]; then
    keystroke_count=$(cat /tmp/keystroke_count.txt)
    if [ -n "$keystroke_count" ]; then
        metric="macos.keystrokes.total:$keystroke_count"
        printf "%s|g|#host:%s\n" "$metric" "$HOST" | nc -u -w1 localhost 8125
    fi
fi
```

## Troubleshooting

- If the LaunchAgent shows exit code 1, check /tmp/keystroke_counter.err
- The most common issue is missing Accessibility permissions
- To reload after changes: `launchctl unload` then `launchctl load` the plist
- Check if running: `ps aux | grep keystroke_counter`
*/

import Cocoa
import Foundation

// Counter file to persist keystroke count
let counterFile = "/tmp/keystroke_count.txt"

// Read current count
func readCount() -> Int {
    if let data = try? String(contentsOfFile: counterFile, encoding: .utf8),
       let count = Int(data.trimmingCharacters(in: .whitespacesAndNewlines)) {
        return count
    }
    return 0
}

// Write count to file
func writeCount(_ count: Int) {
    try? String(count).write(toFile: counterFile, atomically: true, encoding: .utf8)
}

var keystrokeCount = readCount()

// Create event tap to monitor keystrokes
let eventMask = (1 << CGEventType.keyDown.rawValue)
guard let eventTap = CGEvent.tapCreate(
    tap: .cgSessionEventTap,
    place: .headInsertEventTap,
    options: .defaultTap,
    eventsOfInterest: CGEventMask(eventMask),
    callback: { (proxy, type, event, refcon) in
        // Increment counter on each keystroke
        let countPtr = refcon?.assumingMemoryBound(to: Int.self)
        countPtr?.pointee += 1
        return Unmanaged.passUnretained(event)
    },
    userInfo: &keystrokeCount
) else {
    print("Failed to create event tap. Please grant Accessibility permissions.")
    exit(1)
}

// Create run loop source and add to current run loop
let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
CGEvent.tapEnable(tap: eventTap, enable: true)

// Save count every 10 seconds
Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
    writeCount(keystrokeCount)
}

// Handle termination gracefully
signal(SIGINT) { _ in
    writeCount(keystrokeCount)
    exit(0)
}
signal(SIGTERM) { _ in
    writeCount(keystrokeCount)
    exit(0)
}

print("Keystroke counter started. Count will be saved to \(counterFile)")
CFRunLoopRun()
