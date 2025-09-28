#!/bin/zsh
# Git configuration, aliases, and functions

# =============================================================================
# Git Configuration (Prezto styles)
# =============================================================================
# TODO: This is legacy Prezto configuration - should be cleaned up since we use Oh My Zsh
zstyle -s ':prezto:module:git:log:brief' format '_git_log_brief_format' \
  || _git_log_brief_format='%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'

# =============================================================================
# Git Aliases & Functions
# =============================================================================
# Defensive definitions (plugins load before custom scripts, but good for safety)
alias gco='git checkout'
alias gc='git commit --verbose'

alias ga='git add'
alias gaa='git add --all'
alias gd='git diff'
alias gdc='gd --cached'
alias gst='git status --short'
alias glg='git log --topo-order --all --graph --pretty=format:"${_git_log_brief_format}"'
alias gdm='git branch --merged | grep -v "\*" | grep -v master | grep -v dev | xargs -n 1 git branch -d'
alias gdbase="git diff `git merge-base HEAD develop`"
alias sync-master='git pull --rebase origin master'
alias sync-develop='git pull --rebase origin develop'
alias gmas='gco master'
alias gdev='gco develop'
alias gagc='ga .;gc -m'
alias gsc='git sparse-checkout'

func gnew() {
  gco -b v--$1
}