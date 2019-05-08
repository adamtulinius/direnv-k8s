config_name=$(basename $PWD)
export KUBECONFIG=~/.kube/"$config_name"

kubectl get ns -o name | cut -d "/" -f2 | while read namespace; do
        root="$PWD/$namespace"
        mkdir -p "$root/.bin"

        # create individual .envrc's and dirs for scripts for each namespace
        cat > "$root/.envrc" << EOM
export PATH="$root/.bin:$PATH"
export KUBECONFIG="$KUBECONFIG"
export KUBECONFIG_NAMESPACE="$namespace"
EOM
        # direnv doesn't support aliases, so we create a kubectl wrapper for it, with the original $PATH, to avoid circular dependencies
        cat > "$root/.bin/kubectl" << EOM
export PATH="$PATH"
KUBECONFIG="$KUBECONFIG" exec kubectl --namespace="$namespace" "\$@"
EOM
        chmod +x "$root/.bin/kubectl"

        # automatically allow each generated envrc, circumventing the whitelisting required by direnv ¯\_(ツ)_/¯
        direnv allow "$PWD/$namespace/.envrc"
done
