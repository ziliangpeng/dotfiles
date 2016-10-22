#!/bin/zsh
# Victor Ziliang Peng's shell resource
#

PENG_HOME=~/.oh-my-zsh/custom/plugins/zpeng

alias b='last-ssh'
alias c='clear'
alias e='vim $PENG_HOME/zpeng.plugin.zsh'
alias h='cd ~'
alias p='python'
alias s='python -m SimpleHTTPServer 8008'
#alias t='tmux'
alias x='exit'
alias hs='history'

alias fp='df -H | grep "/dev/"'
alias size='du -hcs'
alias search='find . -type f|xargs grep'

alias vm='ssh zpeng@u'

bmk() {
    echo `pwd` > $PENG_HOME/$1.bmk
}
bmklist() {
    ls $PENG_HOME/*.bmk
}
goto() {
    cd `cat $PENG_HOME/$1.bmk`
}


# Editing/Reloading resource file
alias reload='source ~/.zshrc'

if [[ "$(uname)" == "Darwin" ]]; then
    # Docker
    export DOCKER_CERT_PATH=/Users/zpeng/.boot2docker/certs/boot2docker-vm
    export DOCKER_TLS_VERIFY=1
    export DOCKER_HOST=tcp://192.168.59.103:2376

    # System env
    export JAVA_HOME=$(/usr/libexec/java_home)

    # Bluetooth/WiFi On/Off
    alias boff='blueutil off'
    alias bon='blueutil on'
    alias wifion='networksetup -setairportpower en0 on'
    alias wifioff='networksetup -setairportpower en0 off'
    alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
fi

export PATH=/usr/local/go/bin:$PATH
