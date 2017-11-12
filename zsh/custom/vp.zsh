#!/bin/zsh
# Victor Ziliang Peng's shell resource

alias b='last-ssh'
alias c='clear'
alias h='cd ~'
alias hs='history'
alias l='ls -laG'
alias p='python'
alias p3='python3'
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
zstyle -s ':prezto:module:git:log:medium' format '_git_log_medium_format' \
  || _git_log_medium_format='%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'
zstyle -s ':prezto:module:git:log:oneline' format '_git_log_oneline_format' \
  || _git_log_oneline_format='%C(green)%h%C(reset) %s%C(red)%d%C(reset)%n'
zstyle -s ':prezto:module:git:log:brief' format '_git_log_brief_format' \
  || _git_log_brief_format='%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'
alias ga='git add'
alias gaa='git add --all'
alias gd='git diff'
alias gdm='git branch --merged | grep -v "\*" | grep -v master | grep -v dev | xargs -n 1 git branch -d'
alias gdc='gd --cached'
alias gst='git status --short'
alias glg='git log --topo-order --all --graph --pretty=format:"${_git_log_brief_format}"'
alias sync-master='git pull --rebase origin master'
alias gmas='gco master'
alias gagc='ga .;gc -m'
alias vb='vim build.gradle'


# Gradle
alias ggc='gradlew clean'
alias ggb='gradlew build'
alias ggs='gradlew spotlessApply'
alias gdep='gradlew dependencies --configuration compile'
alias gdepdw10='gradlew dependencies --configuration compileWithDW10'
alias gcb='gradlew clean; gradlew build;'

# Handy tools
alias greps='grep -rn . -e'
alias grepw='grep -rnw . -e'

# compile thrift
alias thriftc="./bootstrap.sh && ./configure LDFLAGS='-L/usr/local/opt/openssl/lib' CPPFLAGS='-I/usr/local/opt/openssl/include' --prefix=/usr/local PHP_PREFIX='/usr/local/Cellar/php55/5.5.38_11/lib/php' && make && sudo make install"
