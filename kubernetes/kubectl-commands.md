
# kubectl | The Kubernetes Command Line Interface

When running a Kubernetes deployment, you use kubectl (on your client's command line) to ask about status, to perform software as a service (SAAS) releases, and to perform administrative duties.

## kubectl copy

Copying one file or **recursively copying** a file tree to and from a container in a kubernetes pod is something we all need to do from time to time.

##### `kubectl get pods -o wide`
##### `kubectl cp jenkins-7dc98c4b64-pjr8v:/var/jenkins_home .`

**kubectl copies** everything in and below the Jenkins home directory to the host kubectl is running on.



## kubectl logs

We must access logs from **multiple containers** and **multiple pods** in order to productively engineer services on the kubernetes platform.


##### `kubectl -n default logs -f deployment/<name> --all-containers=true --since=10m`

This command will **tail all logs** from **all containers in pods** within the **`default`** namespace.



## Did You Know?

Did you know that

- **in 5 minutes [you can setup a local kubernetes cluster with 2 or 3 commands](microk8s-install)**
- [[Kubernetes Secrets Official Documentation|https://kubernetes.io/docs/concepts/configuration/secret/]]
