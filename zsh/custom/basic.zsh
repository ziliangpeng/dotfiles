#!/bin/zsh
# Basic shell aliases and utilities

# =============================================================================
# Basic Shell Aliases
# =============================================================================
alias c='clear'
alias h='cd ~'
alias hs='history'
alias x='exit'
alias reload='source ~/.zshrc'

# =============================================================================
# File & Directory Operations
# =============================================================================
# Conditional ls alias for cross-platform compatibility
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias l='ls -laG'        # macOS
else
  alias l='ls -la --color=auto'  # Linux
fi
alias fp='df -H | grep "/dev/"'
alias size='du -hcs'
alias search='find . -type f|xargs grep'

# =============================================================================
# Development Tools
# =============================================================================
alias p='python'
alias p3='python3'
alias s='python3 -m http.server 8008'

# =============================================================================
# Bookmark Functions
# =============================================================================
BMK_PATH=/tmp
bmk() {
    echo $(pwd) > $BMK_PATH/$1.bmk
}
bmklist() {
    ls $BMK_PATH/*.bmk
}
goto() {
    cd $(cat $BMK_PATH/$1.bmk)
}


# =============================================================================
# Search & Grep Utilities
# =============================================================================
alias greps='grep -rn . -e'
alias grepw='grep -rnw . -e'



