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
