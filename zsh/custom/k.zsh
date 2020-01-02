# General k commands
alias k="kubectl"
alias kinfo="k cluster-info"
alias kc="kubectl config"
alias kcc="kc get-contexts"
alias kg="k get"
alias kd="k describe"
alias kdl="k delete"
alias ktail="k logs -f"

alias kdpod="kd pod"
alias kdnode="kd node"
alias kdp=kdpod
alias kdn=kdnode

func knodes() { k get nodes | grep "$1" }
func kpods() { k get pods --sort-by=.status.startTime | grep "$1" }
func kjobs() { k get jobs --sort-by=.status.startTime | grep "$1" }
func kssh() { k exec -it $1 -- /bin/bash }
func ks() { k scale --replicas=$1 jobs/$2 }


# Switch namespaces
alias knk="kubectl config set-context --current --namespace=kube-system"
alias kndefault="kubectl config set-context --current --namespace=default"


# Switch clusters
alias klocal="kc use-context   kubernetes-admin@kubernetes"
alias ksim="kc use-context     gke_nuro-simulation_us-west1_simtest-private-west1"
alias kinfra="kc use-context   gke_nuro-ai_us-west1_private-us-west1"
alias kvictor="kc use-context  gke_nuro-ai_us-west1-a_victor-test-cluster-1"
alias kwest="kc use-context    gke_nuro-ai_us-west1-a_west1a"
alias kml="kc use-context      gke_nuro-ml_us-west1_ml-private-west1"
alias kmlcent="kc use-context  gke_nuro-ml_us-central1_ml-private-central1"


# Auth clusters
alias gke-auth-infra-private="gcloud container clusters get-credentials private-us-west1 --region=us-west1"
alias gke-auth-sim-private="gcloud container clusters get-credentials simtest-private-west1 --region us-west1 --project nuro-simulation"
alias gke-auth-west="gcloud container clusters get-credentials west1a --zone=us-west1-a"
alias gke-auth-victor="gcloud container clusters get-credentials victor-test-cluster-1 --zone=us-west1-a"
alias gke-auth-ml-private="gcloud container clusters get-credentials ml-private-west1 --region us-west1 --project nuro-ml"
alias gke-auth-ml-private-cent="gcloud container clusters get-credentials ml-private-central1 --region us-central1 --project nuro-ml"
alias reset-gke-auth="gcloud config set account zpeng@nuro.ai"
alias gauth='reset-gke-auth; gke-auth-west; gke-auth-ls-b; gke-auth-ls-c; gke-auth; gke-auth-sim; \
  gke-auth-sim-private; gke-auth-ml; gke-auth-ml-private; gke-auth-victor; gke-auth-infra-private; \
  gke-auth-ml-private-cent;'


alias gssh='gcloud compute --project nuro-ai ssh --zone us-west1-a'
alias gsshb='gcloud compute --project nuro-ai ssh --zone us-west1-b'
alias gsshc='gcloud compute --project nuro-ai ssh --zone us-west1-c'








