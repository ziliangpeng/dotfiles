# Nuro-specific namespace shortcuts
alias knmon="kubectl config set-context --current --namespace=appframework-monitoring"
alias knsignalfx="kubectl config set-context --current --namespace=signalfx"


# Switch clusters
alias klocal="kc use-context     kubernetes-admin@kubernetes"
alias khq="kc use-context        superuser@kube-hq"
alias kimporter="kc use-context  importer-admin@importer-hq"
alias ksim="kc use-context       gke_nuro-simulation_us-west1_simtest-private-west1"
alias ksimprod="kc use-context   gke_nuro-simulation-prod_us-central1_private-simtest-us-central1"
alias kdevsimc="kc use-context   gke_nuro-dev-simtest_us-central1_simtest-us-central1"
alias kdevsimc2="kc use-context   gke_nuro-dev-simtest_us-central1_simtest-us-central1-2"
alias kinfra="kc use-context     gke_nuro-ai_us-west1_private-us-west1"
alias kvictor="kc use-context    gke_nuro-ai_us-west1-a_victor-test-cluster-1"
alias kvictorc="kc use-context   gke_nuro-ai_us-central1_victor-test-central1"
alias kwest="kc use-context      gke_nuro-ai_us-west1-a_west1a"
alias kml="kc use-context        gke_nuro-ml_us-west1_ml-private-west1"
#alias kmlcent="kc use-context  gke_nuro-ml_us-central1_ml-private-central1"
alias kmlw="kc use-context       gke_nuro-ml_us-west1_us-west1"
alias kmlc="kc use-context       gke_nuro-ml_us-central1_us-central1"
alias kmlmlw="kc use-context       gke_nuro-ml_us-west1_ml-us-west1"
alias kmlmlc="kc use-context       gke_nuro-ml_us-central1_ml-us-central1"
#alias kgc="kc use-context      gke_nuro-ai_us-central1-c_us-central1-nuro-platform-c-a54bfcdc-gke" 
alias kgc-test="kc use-context   gke_nuro-ai_us-central1-c_us-central1-nuro-platform-t-ea90dc33-gke"
alias kgc="kc use-context        gke_nuro-ai_us-central1-c_us-central1-nuro-platform-0a47a734-gke" 
alias kgc2="kc use-context       gke_nuro-platform-dev_us-central1-c_us-central1-nuro-platform-v-3997dd63-gke" 
alias kbates="kc use-context     gke_nuro-bates_us-west1_bates-us-west1"
alias klsw="kc use-context       gke_nuro-dev-large-scale_us-west1_ls-us-west1"
alias klsc="kc use-context       gke_nuro-dev-large-scale_us-central1_ls-us-central1"
alias ktools="kc use-context     gke_nuro-tools-prod_us-west1_tools-us-west1"
alias kcalib="kc use-context     gke_nuro-calibration_us-west1_calibration-us-west1"
alias kmapw="kc use-context      gke_nuro-mapping-257717_us-west1_mapping-private-us-west1" 
alias kplatform="kc use-context  gke_nuro-platform-dev_us-west1_platform-dev-us-west1"

alias kpfap="kc use-context      gke_nuro-platform-dev_us-west1_platform-dev-us-west1-autopilot" 
alias kpf="kc use-context      gke_nuro-platform-dev_us-west1_platform-dev-us-west1" 

alias kdp-w="kc use-context      gke_nuro-data-platform-prod_us-west1_data-platform-prod-us-west1"


# Auth clusters
alias gke-auth-infra-private="gcloud container clusters get-credentials private-us-west1 --region=us-west1"

alias gke-auth-ls-west="gcloud container clusters get-credentials ls-us-west1 --region=us-west1 --project nuro-dev-large-scale"
alias gke-auth-ls-central="gcloud container clusters get-credentials ls-us-central1 --region=us-central1 --project nuro-dev-large-scale"

alias gke-auth-sim-private="gcloud container clusters get-credentials simtest-private-west1 --region us-west1 --project nuro-simulation"
alias gke-auth-sim-prod="gcloud container clusters get-credentials private-simtest-us-central1 --region us-central1 --project nuro-simulation-prod"
alias gke-auth-sim-dev="gcloud container clusters get-credentials simtest-us-central1 --region us-central1 --project nuro-dev-simtest"
alias gke-auth-sim-dev-2="gcloud container clusters get-credentials simtest-us-central1-2 --region us-central1 --project nuro-dev-simtest"

alias gke-auth-west="gcloud container clusters get-credentials west1a --zone=us-west1-a"
alias gke-auth-victor="gcloud container clusters get-credentials victor-test-cluster-1 --zone=us-west1-a"
alias gke-auth-victorc="gcloud container clusters get-credentials victor-test-central1 --zone=us-central1"

alias gke-auth-ml-private="gcloud container clusters get-credentials ml-private-west1 --region us-west1 --project nuro-ml"
alias gke-auth-ml-private-cent="gcloud container clusters get-credentials ml-private-central1 --region us-central1 --project nuro-ml"
alias gke-auth-ml-west="gcloud container clusters get-credentials us-west1 --region us-west1 --project nuro-ml"
alias gke-auth-ml-central="gcloud container clusters get-credentials us-central1 --region us-central1 --project nuro-ml"
alias gke-auth-ml-ml-west="gcloud container clusters get-credentials ml-us-west1 --region us-west1 --project nuro-ml"
alias gke-auth-ml-ml-central="gcloud container clusters get-credentials ml-us-central1 --region us-central1 --project nuro-ml"

alias gke-auth-dp-west1="gcloud container clusters get-credentials data-platform-prod-us-west1 --region us-west1 --project nuro-data-platform-prod"

alias gke-auth-gc-test="gcloud container clusters get-credentials us-central1-nuro-platform-t-ea90dc33-gke --region us-central1-c" # the composer test cluster
alias gke-auth-gc="gcloud container clusters get-credentials us-central1-nuro-platform-0a47a734-gke --region us-central1-c" # the composer cluster

alias gke-auth-pf-ap="gcloud container clusters get-credentials platform-dev-us-west1-autopilot --region us-west1 --project nuro-platform-dev"
alias gke-auth-pf="gcloud container clusters get-credentials platform-dev-us-west1 --region us-west1 --project nuro-platform-dev"

alias reset-gke-auth="gcloud config set account zpeng@nuro.ai"
#alias gauth='reset-gke-auth; gke-auth-west; gke-auth-ls-b; gke-auth-ls-c; gke-auth; gke-auth-sim; \
#  gke-auth-sim-private; gke-auth-ml; gke-auth-ml-private; gke-auth-victor; gke-auth-infra-private; \
#  gke-auth-ml-private-cent; gke-auth-gc-test'
alias gauth='reset-gke-auth; gke-auth-west; gke-auth-sim-prod; \
  gke-auth-sim-private; gke-auth-ml-private; gke-auth-victor; gke-auth-infra-private; \
  gke-auth-ml-private-cent; gke-auth-gc-test; gke-auth-ml-west; gke-auth-ml-central; gke-auth-pf-ap'


alias gssh='gcloud compute --project nuro-ai ssh --zone us-west1-a'
alias gsshb='gcloud compute --project nuro-ai ssh --zone us-west1-b'
alias gsshc='gcloud compute --project nuro-ai ssh --zone us-west1-c'








