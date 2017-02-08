#!/bin/zsh
# Victor Ziliang Peng's shell resource

alias b='last-ssh'
alias c='clear'
alias h='cd ~'
alias hs='history'
alias p='python'
alias s='python -m SimpleHTTPServer 8008'
alias x='exit'

alias fp='df -H | grep "/dev/"'
alias size='du -hcs'
alias search='find . -type f|xargs grep'

#alias vm='ssh zpeng@u'

BMK_PATH=/tmp
bmk() {
    echo `pwd` > $BMK_PATH/$1.bmk
}
bmklist() {
    ls $BMK_PATH/*.bmk
}
goto() {
    cd `cat $BMK_PATH/$1.bmk`
}


# Editing/Reloading resource file
alias reload='source ~/.zshrc'


# Git
alias gdc='git diff --cached'


# Gradle
alias grun='gradle clean;gradle build -PuseLocalThrift="/usr/local/bin/thrift";gradle run -PuseLocalThrift="/usr/local/bin/thrift"'
