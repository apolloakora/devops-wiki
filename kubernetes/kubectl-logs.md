
# Kubernetes Logs using kubectl

We must access logs from **multiple containers** and **multiple pods** in order to productively engineer services on the kubernetes platform.


### `kubectl -n default logs -f deployment/<name> --all-containers=true --since=10m`

This command will **tail all logs** from **all containers in pods** within the `default` namespace.



## Did You Know?

Did you know that

- **in 5 minutes [you can setup a local kubernetes cluster with 2 or 3 commands](microk8s-install)**
- [[Kubernetes Secrets Official Documentation|https://kubernetes.io/docs/concepts/configuration/secret/]]
