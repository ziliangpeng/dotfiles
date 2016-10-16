# Only for airship

# PATHS
export JAVA7_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_79.jdk/Contents/Home
export JAVA8_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home
export JAVA_HOME=$JAVA8_HOME

export AIRPATH=$ZSH_CUSTOM/plugins/airbnb-zsh

export PATH=$PATH:~/bin
export PATH=$PATH:$JAVA_HOME/bin
export PATH=$PATH:$AIRPATH/bin
export PATH=$PATH:/opt/airbnb/bin


alias airedit='vim $AIRPATH/airbnb-zsh.plugin.zsh'
alias rekey='goldkey'
alias v='cd ~/airlab && vagrant up;  vagrant ssh'

# dev tool
alias gdm='git branch --merged | grep -v "\*" | grep -v master | grep -v dev | xargs -n 1 git branch -d'

# Login to data center
function ssha() {
  sid=$1
  shift
  ssh -A -o StrictHostKeyChecking=no -o NumberOfPasswordPrompts=0 $sid".inst.aws.airbnb.com" -t $*
}

function converge-log() {
  ssha $1 tail -f /var/log/init.err
}

function sshr() {
  ssha `inst $@`
}
