# Login to data center

function sshUtil() {
    ssh -A -o StrictHostKeyChecking=no -o NumberOfPasswordPrompts=0 $dc-$sid".rfiserve.net" -t $*
}

function remote() {
    if [[ -z $1 ]]; then
        exit
    fi
    dc=$1
    shift
    if [[ -z $1 ]]; then
        echo "Usage : "$dc" <machine_number>"
    else
        sid=$1
        shift
        #if [ $(sshUtil ls -la /home/zpeng | grep -c '^\.vimrc$') = 0 ]; then
            #echo 'no .vimrc detected. downloading...'
            #sshUtil $dc $sid 'wget --no-check-certificate -O - https://raw.githubusercontent.com/vgod/vimrc/master/auto-install.sh | sh'
        #fi
        #if [ $(sshUtil ls -la /home/zpeng | grep -c '\.oh-my-zsh\s*$') = 0 ]; then
        #    echo 'need to install oh-my-zsh'
        #    sshUtil 'wget --no-check-certificate https://raw.github.com/ziliangdotme/oh-my-zsh/master/tools/install.sh -O - | sh'
        #    sshUtil 'echo "exec /bin/zsh" >> /home/zpeng/.bash_profile'
            #sshUtil 'ssh-keygen -R github.com'
        #fi
        sshUtil $*
    fi
}
function inw() { remote 'inw' $* }
function lsv() { remote 'lsv' $* }
function fra() { remote 'fra' $* }
function tca() { remote 'tca' $* }

# My lucky machines
alias prodad='inw 322'
alias devad='inw 233'
alias prodbid='inw 1150'
alias devbid='inw 1196'
alias hive_inw='inw 81'

export ADLOG=/srv/var/server.rfi/adLogs
export BIDLOG=/srv/var/server.rfi/bidLogs
export LOG_PATH=/srv/var/server.rfi/logs
export CRAWLLOG=/srv/var/pixelcrawler-crawler/logs
export CHECKERLOG=/srv/var/pixelcrawler-checker/logs
alias adLog="cat $AD_LOG_PATH/*.log"
alias bidLog="cat $BID_LOG_PATH/*.log"
alias serverLog="cat $LOG_PATH/serverLog.txt"
alias errorLog="cat $LOG_PATH/errorLog.txt"
alias hv='python ~/.oh-my-zsh/custom/scripts/hive-z.py'

# Only for rocketware
export PATH=$PATH:~/git/repo/rrepo
export CVSROOT=:ext:zpeng@cvs1001.corp.xplusone.com:/usr/local/dev/src

alias edit_rfi='vim ~/.oh-my-zsh/custom/plugins/rfi/rfi.plugin.zsh'
export DBSCHEMA=~/git/common/schema/src/main/resources/db_schema/rfi_meta_data
export GIT_PATH=~/git

