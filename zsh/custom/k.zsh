# General Kubernetes aliases and functions

# Basic kubectl shortcuts
alias k="kubectl"
alias kc="kubectl config"
alias kinfo="k cluster-info"
alias kca="kc get-contexts"
alias kall="kc get-contexts"
alias kcc="kc current-context"
func ku() { kc use-context "$@" }

# Resource operations
alias kg="k get"
alias kgd="k get deploy"
alias ked="k edit deploy"
alias kd="k describe"
alias kdl="k delete"
alias ktail="k logs -f"

# Resource-specific shortcuts
alias kdpod="kd pod"
alias kdnode="kd node"
alias kdp=kdpod
alias kdn=kdnode

# Common listings
alias kapods="k get pods --all-namespaces"

# Namespace operations
alias kndefault="kubectl config set-context --current --namespace=default"
alias knk8="kubectl config set-context --current --namespace=kube-system"
alias kn="kubectl config set-context --current --namespace"

# Utility functions
func knodes() { k get nodes | grep "$1" }
func kpods() { k get pods --sort-by=.status.startTime | grep "$1" }
func kde() { k get deploy | grep "$1" }
func kjobs() { k get jobs --sort-by=.status.startTime | grep "$1" }
func kgr() { kc get-contexts | grep "$1" }
func kssh() { k exec -it $@ -- /bin/bash }
func ks() { k scale --replicas=$1 jobs/$2 }

# Tail logs from all pods in a deployment (vllm-container)
func kvlogs() {
  local deployment=$1
  local namespace=${2:-vllm-model-server}

  if [[ -z "$deployment" ]]; then
    echo "Usage: kvlogs <deployment-name> [namespace]"
    echo "Example: kvlogs qwen3-235b-fp8-deep-synth-lite-prod-c-model-server-deployment"
    return 1
  fi

  local label=$(kubectl get deployment -n $namespace $deployment -o jsonpath='{.spec.selector.matchLabels.app}' 2>/dev/null)

  if [[ -z "$label" ]]; then
    echo "Error: Could not find deployment '$deployment' in namespace '$namespace'"
    return 1
  fi

  echo "Tailing logs from all pods with label app=$label in namespace $namespace..."
  kubectl logs -n $namespace -l app=$label -c vllm-container --prefix=true --max-log-requests=20 -f
}

# Custom completions
_ku_contexts() {
  local -a contexts
  contexts=($(kubectl config get-contexts -o name 2>/dev/null))
  _describe 'contexts' contexts
}

# Register completions
compdef _ku_contexts ku