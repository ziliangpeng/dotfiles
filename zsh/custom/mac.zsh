export PATH="$PATH:$HOME/dotfiles/bin/macos"

# Bluetooth/WiFi On/Off
alias boff='blueutil off'
alias bon='blueutil on'
alias wifion='networksetup -setairportpower en0 on'
alias wifioff='networksetup -setairportpower en0 off'
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

loop() {
  while true; do
    "$@"
    echo '==='
    sleep 5
  done
}

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Ghostty shell integration
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi
