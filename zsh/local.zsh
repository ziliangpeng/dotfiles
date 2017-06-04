EC2_IP="54.169.160.22"
PERM_FILE="~/.ssh/shadowsocks-2016.pem"

alias ec2-ssh="ssh -i $PERM_FILE ubuntu@$EC2_IP"
alias ec2-tmux="ec2-ssh -t tmux attach-session"

