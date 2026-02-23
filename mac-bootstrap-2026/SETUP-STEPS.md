# Mac Bootstrap 2026 — Setup Steps (Living Doc)

This document captures what we configured so far on this Mac, in chronological and actionable form.

## 0) Goals

- Treat this MacBook Air as an **AI productivity machine**.
- Keep setup reproducible for future fresh macOS installs.
- Start with manual steps, then automate incrementally.

## 1) GitHub CLI (`gh`) setup

### What was done

1. Verified `gh` is installed.
2. Authenticated account via browser.
3. Verified auth status.
4. Configured git credential integration for `gh`.

### Commands

```bash
gh --version
gh auth login -h github.com -p https -w
gh auth status
gh auth setup-git
```

## 2) Dotfiles repo cloned to home directory

### What was done

- Cloned: `ziliangpeng/dotfiles`
- Local path: `~/dotfiles`

### Command

```bash
gh repo clone ziliangpeng/dotfiles ~/dotfiles
```

## 3) Dock standardized (apps + order)

### Target Dock app order (left to right)

1. Finder
2. Google Chrome
3. iTerm
4. Comet
5. Cursor

### What was done

- Rewrote Dock app section to exactly the list above.
- Restarted Dock to apply.
- Saved reference file in repo:
  - `mac-bootstrap-2026/dock-app-order.txt`

### Implementation used

- Direct `defaults write com.apple.dock persistent-apps ...` entries
- `killall Dock`

> Note: for future automation, consider adding `dockutil` for simpler/cleaner Dock scripting.

## 4) Keep-awake workflow (no-sleep)

### Decision

- Use macOS built-in `caffeinate` (no extra install required).

### Script created

- Path: `~/bin/screenawake`
- Interface: `on | off | status`
- Backed by PID file at: `~/.cache/screenawake-caffeinate.pid`

### Usage

```bash
screenawake on
screenawake off
screenawake status
```

### Behavior

- `on`: starts `caffeinate -dimsu` in background.
- `off`: stops only the managed `caffeinate` process.
- `status`: reports current state.

## 5) App cleanup discussion

### Reviewed `/Applications` list

- Full user-app list was enumerated for cleanup consideration.

### Candidate removals discussed

- Alfred 5.app
- ChatGPT.app
- Copilot.app
- IINA.app
- Insta360 Studio 2023.app

### Outcome

- Did **not** proceed with deletion due to permissions in this control session.
- Kept apps as-is for now.

## 6) Next steps to automate

### A. Create bootstrap script set in this folder

Proposed scripts:

1. `01-gh-setup.sh`
2. `02-clone-dotfiles.sh`
3. `03-dock-setup.sh`
4. `04-keep-awake-setup.sh`
5. `05-productivity-defaults.sh`

### B. Add one entrypoint

- `bootstrap.sh` to run selected modules.

### C. Add idempotency + safety

- Check-before-write for each config.
- Backup existing Dock/preferences before overwrite.
- Dry-run mode where possible.

## 7) Notes / conventions

- Prefer reversible operations.
- For `/Applications` deletes, move to Trash rather than permanent remove.
- Keep this doc as a changelog + playbook.

---

## Change Log

- Initial version created on 2026-02-22.

## 8) Manico latency tuning (Option-key trigger delay)

### Bootstrap target

- Set Manico trigger delay to **0 seconds** (`time-delay-before-activation = 0`).
- Apply with **quit → set → relaunch** so the value takes effect consistently.

### Config key

Manico stores trigger delay in preferences key:

- Domain: `im.manico.Manico`
- Key: `time-delay-before-activation`
- Unit: seconds (float)

### Check current value

```bash
defaults read im.manico.Manico "time-delay-before-activation" 2>/dev/null || echo "KEY_NOT_SET"
```

### Set delay value (examples)

```bash
# Instant
defaults write im.manico.Manico "time-delay-before-activation" -float 0

# Very fast
defaults write im.manico.Manico "time-delay-before-activation" -float 0.05

# Balanced
defaults write im.manico.Manico "time-delay-before-activation" -float 0.15
```

### Apply reliably (quit → set → relaunch)

```bash
osascript -e 'tell application "Manico" to quit' || true
sleep 1
defaults write im.manico.Manico "time-delay-before-activation" -float 0
open -a Manico
```

### Verify after relaunch

```bash
defaults read im.manico.Manico "time-delay-before-activation"
```

### Recommended values

- `0` = instant
- `0.05` = very fast (often a sweet spot)
- `0.1-0.2` = fewer accidental popups


## 9) Ensure Manico starts at login

### Bootstrap target

- Manico **must auto-start at login** on a fresh Mac bootstrap.

### Add Manico to macOS Login Items (scriptable)

```bash
osascript <<'APPLESCRIPT'
tell application "System Events"
  if not (exists login item "Manico") then
    make login item at end with properties {name:"Manico", path:"/Applications/Manico.app", hidden:false}
  end if
end tell
APPLESCRIPT
```

### Verify

```bash
osascript <<'APPLESCRIPT'
tell application "System Events"
  get the properties of every login item whose name is "Manico"
end tell
APPLESCRIPT
```


## 10) Manico app order (current canonical order)

Current Manico action order from local database (`ZACTION` sorted by `ZSORTWEIGHT`):

- Index 0: Finder
- Index 1: Google Chrome
- Index 2: iTerm
- Index 3: Comet
- Index 4: Cursor

Reference file:

- `mac-bootstrap-2026/manico-app-order.txt`


## 11) Rectangle window manager setup (replace Spectacle workflow)

### Goal

Use Rectangle as the primary window manager and disable macOS tiling conflicts.

### Install Rectangle

```bash
brew install --cask rectangle
open -a Rectangle
```

### Start Rectangle at login

```bash
osascript <<'APPLESCRIPT'
tell application "System Events"
  if not (exists login item "Rectangle") then
    make login item at end with properties {name:"Rectangle", path:"/Applications/Rectangle.app", hidden:false}
  end if
end tell
APPLESCRIPT
```

### Shortcut profile (custom)

- `Ctrl + F` → Maximize
- `Option + Command + Left` → Left half
- `Option + Command + Right` → Right half
- `Ctrl + Option + Command + Left` → Previous display
- `Ctrl + Option + Command + Right` → Next display

### Apply shortcuts via Terminal (idempotent)

```bash
# Left / Right half
defaults write com.knollsoft.Rectangle leftHalf -dict-add keyCode -float 123 modifierFlags -float 1572864
defaults write com.knollsoft.Rectangle rightHalf -dict-add keyCode -float 124 modifierFlags -float 1572864

# Move window between displays
defaults write com.knollsoft.Rectangle previousDisplay -dict-add keyCode -float 123 modifierFlags -float 1835008
defaults write com.knollsoft.Rectangle nextDisplay -dict-add keyCode -float 124 modifierFlags -float 1835008

# Maximize
defaults write com.knollsoft.Rectangle maximize -dict-add keyCode -float 3 modifierFlags -float 262144

# Reload app
osascript -e 'tell application "Rectangle" to quit' || true
sleep 1
open -a Rectangle
```

### Verify mappings

```bash
defaults read com.knollsoft.Rectangle leftHalf
defaults read com.knollsoft.Rectangle rightHalf
defaults read com.knollsoft.Rectangle previousDisplay
defaults read com.knollsoft.Rectangle nextDisplay
defaults read com.knollsoft.Rectangle maximize
```

### Notes

- If `Ctrl + F` conflicts inside specific apps, remap maximize to `Ctrl + Option + F`.
- Keep one canonical window manager active to avoid keybinding conflicts.


## 12) Trackpad productivity defaults (tap-to-click + tap-drag)

### Goal

- Enable **tap to click**
- Enable **double-tap and drag** (dragging), without three-finger drag

### Apply via CLI

```bash
# Tap to click (internal + bluetooth trackpad + global)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Double-tap dragging behavior
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool true
defaults write com.apple.AppleMultitouchTrackpad DragLock -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool false

# Reload preferences
killall cfprefsd || true
killall SystemUIServer || true
```

### Verify

```bash
defaults read com.apple.AppleMultitouchTrackpad | egrep "Clicking|Dragging|DragLock|TrackpadThreeFingerDrag"
defaults read com.apple.driver.AppleBluetoothMultitouch.trackpad | egrep "Clicking|Dragging|DragLock|TrackpadThreeFingerDrag"
defaults read NSGlobalDomain com.apple.mouse.tapBehavior
```

Expected:
- `Clicking = 1`
- `Dragging = 1`
- `DragLock = 0`
- `TrackpadThreeFingerDrag = 0`
- `com.apple.mouse.tapBehavior = 1`


## 13) Keyboard remap: Caps Lock -> Control (built-in keyboard)

### Goal

- Remap `Caps Lock` to `Control` for macOS productivity workflows.

### Apply (persistent + immediate)

```bash
# Persist remap for current host
/usr/bin/defaults -currentHost write -g com.apple.keyboard.modifiermapping -array \
  '<dict><key>HIDKeyboardModifierMappingSrc</key><integer>30064771129</integer><key>HIDKeyboardModifierMappingDst</key><integer>30064771300</integer></dict>'

# Apply live without logout
/usr/bin/hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":30064771129,"HIDKeyboardModifierMappingDst":30064771300}]}'
```

### Verify

```bash
/usr/bin/hidutil property --get "UserKeyMapping"
```

Expected mapping:
- `Src 30064771129` (Caps Lock) -> `Dst 30064771300` (Left Control)


## 14) Hide menu bar icons for Rectangle and Manico

### Goal

- Keep Rectangle and Manico running, but hide their menu bar/status icons.

### Apply

```bash
# Rectangle
defaults write com.knollsoft.Rectangle menuBarIconHidden -bool true

# Manico (both key variants for compatibility)
defaults write im.manico.Manico "show-status-icon" -bool false
defaults write im.manico.Manico ShowStatusIcon -bool false

# Relaunch apps
osascript -e 'tell application "Rectangle" to quit' || true
osascript -e 'tell application "Manico" to quit' || true
sleep 1
open -a Rectangle
open -a Manico
```

### Verify

```bash
defaults read com.knollsoft.Rectangle menuBarIconHidden
defaults read im.manico.Manico "show-status-icon"
defaults read im.manico.Manico ShowStatusIcon
```

Expected:
- Rectangle `menuBarIconHidden = 1`
- Manico `show-status-icon = 0`
- Manico `ShowStatusIcon = 0`

