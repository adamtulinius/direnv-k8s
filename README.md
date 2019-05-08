# direnv-k8s

This project makes it easy to switch between different k8s environments depending on the current working dir. 


# how it works

When you enter a directory with this enabled, it will set `$KUBECONFIG`, and create a directory for each namespace found on the cluster.
Each directory will contain another direnv and a `kubectl`-wrapper, that points to the specific namespace. When entering one of these directories, that `kubectl` will end up first in `$PATH`.
These `kubectl`'s are created each time the root environment is loaded. Technically the same can be achieved just by using aliases containing an environment variable, but I found that broke tab completion.

Furthermore, `$KUBECONFIG_NAMESPACE` will also be set inside these directories, to make it easy to include the namespace name in the shell prompt.

This script will use the basename of the current working directory as a name for a kube config. That is, given a directory `/home/adam/k8s/prod`, it will  `export KUBECONFIG=/home/atu/.kube/prod`.


# installation

1.  install direnv and make your shell load it (see https://direnv.net/)
1.  create a kubeconfig named `$name` in `~/.kube/`
1.  create a directory named `$name`
1.  create a symlink from `create-environment.sh` to `$name/.envrc`
1.  cd into the directory, and notice that direnv complains about the env not being allowed yet
1.  READ THROUGH THE ENTIRY `.envrc` (or `create-environment.sh`) SCRIPT, AND CONFIRM THAT IT DOESN'T DO ANYTHING NASTY!
1.  If happy with the above, run `direnv allow .`
