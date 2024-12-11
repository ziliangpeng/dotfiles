# General k commands
alias k="kubectl"
alias kinfo="k cluster-info"
alias kc="kubectl config"
alias kcc="kc get-contexts"
alias kg="k get"
alias kd="k describe"
alias kdl="k delete"
alias ktail="k logs -f"
alias ku="kc use-context"

alias kdpod="kd pod"
alias kdnode="kd node"
alias kdp=kdpod
alias kdn=kdnode

alias kapods="k get pods --all-namespaces"

func knodes() { k get nodes | grep "$1" }
func kpods() { k get pods --sort-by=.status.startTime | grep "$1" }
func kde() { k get deploy | grep "$1" }
func kjobs() { k get jobs --sort-by=.status.startTime | grep "$1" }
func kssh() { k exec -it $@ -- /bin/bash }
func ks() { k scale --replicas=$1 jobs/$2 }
#func kcc() { kc get-contexts | grep $1 }

# Switch namespaces
alias knk8="kubectl config set-context --current --namespace=kube-system"
alias knk="kubectl config set-context --current --namespace=kaas-system"
alias kndbr="kubectl config set-context --current --namespace=dbr"
alias kndefault="kubectl config set-context --current --namespace=default"
alias kn="kubectl config set-context --current --namespace"
