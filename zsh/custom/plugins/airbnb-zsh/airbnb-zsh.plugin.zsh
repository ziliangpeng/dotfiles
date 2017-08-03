# Only for airship

# PATHS
export JAVA7_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_79.jdk/Contents/Home
export JAVA8_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home
export JAVA_HOME=$JAVA8_HOME

export AIRPATH=$ZSH_CUSTOM/plugins/airbnb-zsh

export PATH=$PATH:~/bin
export PATH=$PATH:$JAVA_HOME/bin
export PATH=$PATH:$AIRPATH/bin
export PATH=$PATH:/opt/airbnb/bin


alias airedit='vim $AIRPATH/airbnb-zsh.plugin.zsh'
alias v='cd ~/airlab && vagrant up;  vagrant ssh'


# Login to data center
function config_ec2() {
  scp -o StrictHostKeyChecking=no $DOTFILES_PATH/bash/minimal-bashrc $1.inst.aws.airbnb.com:~/.bash_profile
}

# Helper for ssh'ing to ec2
alias ssh='ssh -A -o StrictHostKeyChecking=no -o NumberOfPasswordPrompts=0'
LAST_HOSTNAME=/tmp/last_ec2
CONFIGED_HOSTNAMES=/tmp/cached_hostnames
function ssha() { # log into a EC2 instance
  host=$1
  echo $host > $LAST_HOSTNAME
  shift
  ssh $host".inst.aws.airbnb.com" -t $@
}
function ssht() { # configure and log into a EC2 instance
  grep $1 $CONFIGED_HOSTNAMES &> /dev/null
  if [[ $? -ne 0 ]]; then
    config_ec2 $1
    echo $1 >> $CONFIGED_HOSTNAMES
  fi
  ssha $1 "tmux a -t $1|| tmux new -s $1"
}
function picka() { # pick a instance of role, configure, login
  ssht `inst $@`
}
alias pa=picka
function last-ssh() {
  ssht `cat $LAST_HOSTNAME`
}
alias empty_cache_ec2="rm $CONFIGED_HOSTNAMES"

# Other commands over ssh
function converge-log() {
  ssha $1 tail -f /var/log/init.err
}
