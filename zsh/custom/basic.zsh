#!/bin/zsh
# Basic shell aliases and utilities

# =============================================================================
# PATH Configuration
# =============================================================================
export PATH="$PATH:$HOME/dotfiles/bin"

# =============================================================================
# Basic Shell Aliases

# Override Oh My Zsh grep with only relevant exclusions
# Use a function instead of alias for cleaner expansion
unalias grep 2>/dev/null || true
grep() { command grep --color=auto --exclude-dir=.git --exclude-dir=.venv --exclude-dir=venv "$@"; }
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

# =============================================================================
# Claude Code Telemetry (OpenTelemetry -> DataDog)
# =============================================================================
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317



