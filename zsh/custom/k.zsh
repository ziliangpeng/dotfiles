alias k="kubectl"
alias kc="kubectl config"
#alias kcnow="kc current-context"
alias kccontexts="kc get-contexts"
alias kcc=kccontexts
#alias kcclusters="kc get-clusters"

alias kg="k get"
alias kd="k describe"
alias kdl="k delete"

alias klocal="kc use-context kubernetes-admin@kubernetes"
alias ksimold="kc use-context gke_nuro-ai_us-west1-a_jie-cluster-1"
alias ksim="kc use-context gke_nuro-simulation_us-west1_simtest-us-west1"
alias ksim-private="kc use-context gke_nuro-simulation_us-west1_simtest-private-west1"
alias kinfra="kc use-context gke_nuro-ai_us-west1_infra-us-west1"
alias kinfra-private="kc use-context gke_nuro-ai_us-west1_private-us-west1"
alias kcloud=ksim
alias ktest="kc use-context gke_nuro-ai_us-west1-a_victor-test-cluster-1"
alias kls-b="kc use-context gke_nuro-ai_us-west1-b_large-scale-cluster-1b"
alias kls-c="kc use-context gke_nuro-ai_us-west1-c_large-scale-cluster-1c"
alias kwest="kc use-context gke_nuro-ai_us-west1-a_west1a"
alias kml="kc use-context gke_nuro-ml_us-west1_ml-us-west1"
alias kml-private="kc use-context      gke_nuro-ml_us-west1_ml-private-west1"
alias kml-private-cent="kc use-context gke_nuro-ml_us-central1_ml-private-central1"
alias kvictor="kc use-context gke_nuro-ai_us-west1-a_victor-test-cluster-1"

#alias gke-auth="gcloud container clusters get-credentials jie-cluster-1 --zone=us-west1-a"
alias gke-auth-infra="gcloud container clusters get-credentials infra-us-west1 --region=us-west1"
alias gke-auth-infra-private="gcloud container clusters get-credentials private-us-west1 --region=us-west1"
alias gke-auth-sim="gcloud container clusters get-credentials simtest-us-west1 --region us-west1 --project nuro-simulation"
alias gke-auth-sim-private="gcloud container clusters get-credentials simtest-private-west1 --region us-west1 --project nuro-simulation"
alias gke-auth-ls-c="gcloud container clusters get-credentials large-scale-cluster-1c --zone=us-west1-c"
alias gke-auth-ls-b="gcloud container clusters get-credentials large-scale-cluster-1b --zone=us-west1-b"
alias gke-auth-west="gcloud container clusters get-credentials west1a --zone=us-west1-a"
alias gke-auth-victor="gcloud container clusters get-credentials victor-test-cluster-1 --zone=us-west1-a"
alias gke-auth-ml="gcloud container clusters get-credentials ml-us-west1 --region us-west1 --project nuro-ml"
alias gke-auth-ml-private="gcloud container clusters get-credentials ml-private-west1 --region us-west1 --project nuro-ml"
alias gke-auth-ml-private-cent="gcloud container clusters get-credentials ml-private-central1 --region us-central1 --project nuro-ml"
alias gssh='gcloud compute --project nuro-ai ssh --zone us-west1-a'
alias gsshb='gcloud compute --project nuro-ai ssh --zone us-west1-b'
alias gsshc='gcloud compute --project nuro-ai ssh --zone us-west1-c'

alias kinfo="k cluster-info"
func knodes() { k get nodes | grep "$1" }
func kpods() { k get pods --sort-by=.status.startTime | grep "$1" }
func kjobs() { k get jobs --sort-by=.status.startTime | grep "$1" }
alias kdpod="kd pod"
alias kdnode="kd node"
alias kdp=kdpod
alias kdn=kdnode

func kssh() {
  k exec -it $1 -- /bin/bash
}

func ks() {
  k scale --replicas=$1 jobs/$2
}


alias ktail="k logs -f"


alias reset-gke-auth="gcloud config set account zpeng@nuro.ai"
alias gauth='reset-gke-auth; gke-auth-west; gke-auth-ls-b; gke-auth-ls-c; gke-auth; gke-auth-sim; \
  gke-auth-sim-private; gke-auth-ml; gke-auth-ml-private; gke-auth-victor; gke-auth-infra-private; \
  gke-auth-ml-private-cent;'


alias knk="kubectl config set-context --current --namespace=kube-system"
alias kndefault="kubectl config set-context --current --namespace=default"
