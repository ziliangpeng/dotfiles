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
func kssh() { k exec -it $@ -- /bin/bash }
func ks() { k scale --replicas=$1 jobs/$2 }


# Switch namespaces
alias knk="kubectl config set-context --current --namespace=kube-system"
alias kndefault="kubectl config set-context --current --namespace=default"
alias knsignalfx="kubectl config set-context --current --namespace=signalfx"


# Switch clusters
alias klocal="kc use-context   kubernetes-admin@kubernetes"
alias khq="kc use-context      superuser@kube-hq"
alias kimporter="kc use-context      importer-admin@importer-hq"
alias ksim="kc use-context     gke_nuro-simulation_us-west1_simtest-private-west1"
alias ksimprod="kc use-context     gke_nuro-simulation-prod_us-central1_private-simtest-us-central1"
alias kinfra="kc use-context   gke_nuro-ai_us-west1_private-us-west1"
alias kvictor="kc use-context  gke_nuro-ai_us-west1-a_victor-test-cluster-1"
alias kvictorc="kc use-context  gke_nuro-ai_us-central1_victor-test-central1"
alias kwest="kc use-context    gke_nuro-ai_us-west1-a_west1a"
alias kml="kc use-context      gke_nuro-ml_us-west1_ml-private-west1"
#alias kmlcent="kc use-context  gke_nuro-ml_us-central1_ml-private-central1"
alias kmlw="kc use-context      gke_nuro-ml_us-west1_us-west1"
alias kmlc="kc use-context  gke_nuro-ml_us-central1_us-central1"
#alias kgc="kc use-context      gke_nuro-ai_us-central1-c_us-central1-nuro-platform-c-a54bfcdc-gke" 
alias kgc-test="kc use-context gke_nuro-ai_us-central1-c_us-central1-nuro-platform-t-ea90dc33-gke"
alias kgc="kc use-context      gke_nuro-ai_us-central1-c_us-central1-nuro-platform-0a47a734-gke" 


# Auth clusters
alias gke-auth-infra-private="gcloud container clusters get-credentials private-us-west1 --region=us-west1"
alias gke-auth-sim-private="gcloud container clusters get-credentials simtest-private-west1 --region us-west1 --project nuro-simulation"
alias gke-auth-sim-prod="gcloud container clusters get-credentials private-simtest-us-central1 --region us-central1 --project nuro-simulation-prod"
alias gke-auth-west="gcloud container clusters get-credentials west1a --zone=us-west1-a"
alias gke-auth-victor="gcloud container clusters get-credentials victor-test-cluster-1 --zone=us-west1-a"
alias gke-auth-victorc="gcloud container clusters get-credentials victor-test-central1 --zone=us-central1"
alias gke-auth-ml-private="gcloud container clusters get-credentials ml-private-west1 --region us-west1 --project nuro-ml"
alias gke-auth-ml-private-cent="gcloud container clusters get-credentials ml-private-central1 --region us-central1 --project nuro-ml"
alias gke-auth-ml-west="gcloud container clusters get-credentials us-west1 --region us-west1 --project nuro-ml"
alias gke-auth-ml-central="gcloud container clusters get-credentials us-central1 --region us-central1 --project nuro-ml"
alias gke-auth-gc-test="gcloud container clusters get-credentials us-central1-nuro-platform-t-ea90dc33-gke --region us-central1-c" # the composer test cluster
alias gke-auth-gc="gcloud container clusters get-credentials us-central1-nuro-platform-0a47a734-gke --region us-central1-c" # the composer cluster
alias reset-gke-auth="gcloud config set account zpeng@nuro.ai"
#alias gauth='reset-gke-auth; gke-auth-west; gke-auth-ls-b; gke-auth-ls-c; gke-auth; gke-auth-sim; \
#  gke-auth-sim-private; gke-auth-ml; gke-auth-ml-private; gke-auth-victor; gke-auth-infra-private; \
#  gke-auth-ml-private-cent; gke-auth-gc-test'
alias gauth='reset-gke-auth; gke-auth-west; gke-auth-sim-prod; \
  gke-auth-sim-private; gke-auth-ml-private; gke-auth-victor; gke-auth-infra-private; \
  gke-auth-ml-private-cent; gke-auth-gc-test; gke-auth-ml-west; gke-auth-ml-central'


alias gssh='gcloud compute --project nuro-ai ssh --zone us-west1-a'
alias gsshb='gcloud compute --project nuro-ai ssh --zone us-west1-b'
alias gsshc='gcloud compute --project nuro-ai ssh --zone us-west1-c'








