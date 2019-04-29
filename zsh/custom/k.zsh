alias k="kubectl"
alias kc="kubectl config"
alias kcnow="kc current-context"
alias kccontexts="kc get-contexts"
alias kcclusters="kc get-clusters"

alias kg="k get"
alias kd="k describe"

alias klocal="kc use-context kubernetes-admin@kubernetes"
alias kcloud="kc use-context gke_nuro-ai_us-west1-a_jie-cluster-1"
alias ktest="kc use-context gke_nuro-ai_us-west1-a_victor-test-cluster-1"
alias kls-b="kc use-context gke_nuro-ai_us-west1-b_large-scale-cluster-1b"
alias kls-c="kc use-context gke_nuro-ai_us-west1-c_large-scale-cluster-1c"

alias gke-auth="gcloud container clusters get-credentials jie-cluster-1 --zone=us-west1-a"
alias gssh='gcloud compute --project nuro-ai ssh --zone us-west1-a'
alias gsshb='gcloud compute --project nuro-ai ssh --zone us-west1-b'
alias gsshc='gcloud compute --project nuro-ai ssh --zone us-west1-c'

alias kinfo="k cluster-info"
func knodes() { k get nodes | grep "$1" }
func kpods() { k get pods | grep "$1" }
alias kdpod="kd pod"
