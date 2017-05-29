#!/bin/zsh
# Victor Ziliang Peng's shell resource

alias b='last-ssh'
alias c='clear'
alias h='cd ~'
alias hs='history'
alias l='ls -la'
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
alias ga='git add'
alias gd='git diff'
alias gdc='gd --cached'
alias gst='gws'



# Gradle
alias grun='gradle clean;gradle build -PuseLocalThrift="/usr/local/bin/thrift";gradle run -PuseLocalThrift="/usr/local/bin/thrift"'
alias ggc='gradle clean'
alias ggb='gradle build'
alias ggt='gradle teset'
alias gdep='gradlew dependencies --configuration compile'
alias gdepdw10='gradlew dependencies --configuration compileWithDW10'

# Handy tools
alias greps='grep -rn . -e'
alias grepw='grep -rnw . -e'

# compile thrift
alias thriftc="./bootstrap.sh && ./configure LDFLAGS='-L/usr/local/opt/openssl/lib' CPPFLAGS='-I/usr/local/opt/openssl/include' --prefix=/usr/local PHP_PREFIX='/usr/local/Cellar/php55/5.5.38_11/lib/php' && make && sudo make install"
