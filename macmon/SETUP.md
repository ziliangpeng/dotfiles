# macOS Monitoring Setup

This document describes how to set up macOS system monitoring on a Mac. The monitoring collects system metrics (CPU, memory, disk, battery, network, keystrokes, mouse activity, weather, air quality, etc.) and sends them to Datadog via StatsD (UDP on 127.0.0.1:8125).

## Prerequisites

The following must be installed before setup:

- Datadog Agent (running and listening on 127.0.0.1:8125 for DogStatsD)
- Xcode Command Line Tools (`xcode-select --install`) — needed to compile Swift
- `smartmontools` (`brew install smartmontools`) — needed by mac_stats.sh for SSD metrics
- `bc` (comes with macOS) — needed by geoinfo.sh

Verify Datadog Agent is running:

```bash
launchctl list | grep datadoghq
lsof -i :8125
```

## Source Files

All source files live in the dotfiles repository under `bin/`:

| File | Purpose |
|---|---|
| `bin/mac_stats.sh` | System metrics collector (runs every 120s) |
| `bin/geoinfo.sh` | Weather/location/air quality collector (runs every 300s) |
| `bin/keystroke_counter.swift` | Keystroke counting daemon (continuous) |
| `bin/mouse_tracker.swift` | Mouse click/distance tracking daemon (continuous) |

## Step 1: Compile Swift Daemons

Compile the two Swift source files into binaries and place them in `~/bin/`:

```bash
mkdir -p ~/bin
cd ~/dotfiles/bin
swiftc -O -o ~/bin/keystroke_counter keystroke_counter.swift
swiftc -O -o ~/bin/mouse_tracker mouse_tracker.swift
```

Verify both compiled successfully:

```bash
file ~/bin/keystroke_counter
file ~/bin/mouse_tracker
```

Both should show `Mach-O 64-bit executable arm64`.

## Step 2: Make Shell Scripts Executable

```bash
chmod +x ~/dotfiles/bin/mac_stats.sh
chmod +x ~/dotfiles/bin/geoinfo.sh
```

## Step 3: Get WAQI Token

A WAQI API token is required for air quality metrics in geoinfo.sh. If you don't have one, get a free token at https://aqicn.org/data-platform/token/.

## Step 4: Create LaunchAgent Plist Files

Create the following 4 plist files in `~/Library/LaunchAgents/`. Replace `__HOME__` with your actual home directory path (e.g. `/Users/username`) and `__WAQI_TOKEN__` with the token from Step 3.

### 4a. com.user.mac_stats.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.mac_stats</string>
    <key>ProgramArguments</key>
    <array>
        <string>__HOME__/dotfiles/bin/mac_stats.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>120</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/mac_stats.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/mac_stats.error.log</string>
</dict>
</plist>
```

### 4b. com.user.geoinfo.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.geoinfo</string>
    <key>ProgramArguments</key>
    <array>
        <string>__HOME__/dotfiles/bin/geoinfo.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>300</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>EnvironmentVariables</key>
    <dict>
        <key>WAQI_TOKEN</key>
        <string>__WAQI_TOKEN__</string>
    </dict>
    <key>StandardOutPath</key>
    <string>/tmp/geoinfo.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/geoinfo.err</string>
</dict>
</plist>
```

### 4c. com.user.keystroke-counter.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.keystroke-counter</string>
    <key>ProgramArguments</key>
    <array>
        <string>__HOME__/bin/keystroke_counter</string>
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

### 4d. com.user.mouse-tracker.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.mouse-tracker</string>
    <key>ProgramArguments</key>
    <array>
        <string>__HOME__/bin/mouse_tracker</string>
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

## Step 5: Grant Accessibility Permissions

The keystroke counter and mouse tracker require macOS Accessibility permissions. This must be done manually through System Settings.

1. Open **System Settings > Privacy & Security > Accessibility**
2. Click the **"+"** button
3. Navigate to `~/bin/keystroke_counter` and add it
4. Navigate to `~/bin/mouse_tracker` and add it
5. Ensure both checkboxes are **enabled**

## Step 6: Load LaunchAgents

```bash
launchctl load ~/Library/LaunchAgents/com.user.mac_stats.plist
launchctl load ~/Library/LaunchAgents/com.user.geoinfo.plist
launchctl load ~/Library/LaunchAgents/com.user.keystroke-counter.plist
launchctl load ~/Library/LaunchAgents/com.user.mouse-tracker.plist
```

## Step 7: Verify Everything Is Running

Check all 4 agents are loaded:

```bash
launchctl list | grep com.user
```

Expected output (first column is PID — `-` for interval-based scripts, a number for continuous daemons; second column should be `0` for all):

```
-       0       com.user.geoinfo
-       0       com.user.mac_stats
12345   0       com.user.keystroke-counter
12345   0       com.user.mouse-tracker
```

If keystroke-counter or mouse-tracker show exit code 1, Accessibility permissions are likely missing (go back to Step 5).

Verify metrics are reaching Datadog:

```bash
bash ~/dotfiles/bin/mac_stats.sh
sleep 5
datadog-agent dogstatsd-stats 2>/dev/null | grep "macos\." | head -5
```

You should see `macos.*` metrics with recent timestamps.

## Updating Scripts

When scripts are updated in the dotfiles repo (via `git pull`):

- **mac_stats.sh / geoinfo.sh**: Changes are picked up automatically on the next scheduled run (within 120s or 300s). No restart needed.
- **keystroke_counter.swift / mouse_tracker.swift**: Must be recompiled and daemons restarted:

```bash
cd ~/dotfiles/bin
swiftc -O -o ~/bin/keystroke_counter keystroke_counter.swift
swiftc -O -o ~/bin/mouse_tracker mouse_tracker.swift

launchctl unload ~/Library/LaunchAgents/com.user.keystroke-counter.plist
launchctl unload ~/Library/LaunchAgents/com.user.mouse-tracker.plist
launchctl load ~/Library/LaunchAgents/com.user.keystroke-counter.plist
launchctl load ~/Library/LaunchAgents/com.user.mouse-tracker.plist
```

## Troubleshooting

- **Metrics not arriving at Datadog**: Ensure StatsD sends to `127.0.0.1` (not `localhost`). macOS may resolve `localhost` to IPv6 `::1` while Datadog listens on IPv4 only.
- **Keystroke/mouse daemon exits immediately**: Check `/tmp/keystroke_counter.err` or `/tmp/mouse_tracker.err`. Most likely cause is missing Accessibility permissions.
- **geoinfo.sh fails**: Check that `WAQI_TOKEN` is set in the plist. Check `/tmp/geoinfo.err`.
- **mac_stats.sh partial failures**: Some metrics (e.g. SSD via smartctl) require `smartmontools` to be installed. Check `/tmp/mac_stats.error.log`.
- **Reload a plist after editing it**: `launchctl unload <plist>` then `launchctl load <plist>`.
