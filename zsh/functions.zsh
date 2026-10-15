# mkcd: make a directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1" || return; }

# kexec: fuzzy-pick a pod and exec into it
kexec() {
  local pod
  pod=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | fzf --prompt="pod> ") || return
  kubectl exec -it "$pod" -- "${1:-sh}"
}

# klogs: fuzzy-pick a pod and tail its logs
klogs() {
  local pod
  pod=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" | fzf --prompt="logs> ") || return
  kubectl logs -f --tail=200 "$pod" "$@"
}

# kdecode: print all keys of a secret, base64-decoded
kdecode() {
  kubectl get secret "$1" -o json | jq -r '.data | to_entries[] | "\(.key)=\(.value | @base64d)"'
}

# port: who is listening on a port
port() { lsof -nP -iTCP:"$1" -sTCP:LISTEN; }

# extract: unpack any archive
extract() {
  case "$1" in
    *.tar.gz|*.tgz) tar xzf "$1" ;;
    *.tar.bz2)      tar xjf "$1" ;;
    *.tar.xz)       tar xJf "$1" ;;
    *.zip)          unzip "$1" ;;
    *.gz)           gunzip "$1" ;;
    *)              echo "don't know how to extract $1" ;;
  esac
}
