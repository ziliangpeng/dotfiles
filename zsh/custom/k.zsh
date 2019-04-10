alias k="kubectl"
alias kc="kubectl config"
alias kcnow="kc current-context"
alias kccontexts="kc get-contexts"
alias kcclusters="kc get-clusters"

alias kg="k get"
alias kd="k describe"

alias kinfo="k cluster-info"
func knodes() { k get nodes | grep "$1" }
func kpods() { k get pods | grep "$1" }
alias kdpod="kd pod"

alias gc="gcloud"
