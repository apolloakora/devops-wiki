
#### [devopswiki.co.uk home page](/)

# Kubernetes Wiki

Kubernetes is a container orchestration tool engineered by Google and donated to the Cloud Native Foundation.

- **[microk8s | install a kubernetes cluster](/kubernetes/microk8s-install)**
- **[microk8s | import a docker image into kubernetes microk8s](/kubernetes/microk8s-image-import)**
- Jenkins Pipeline **[Use Kubernetes to run Jenkins Jobs](/jenkins/kubernetes-slaves)**
- **[kubernetes secrets user guide](/kubernetes/kubernetes-secrets)**
- **[kubectl independent install](/kubernetes/kubectl-install)**
- **[kubectl user guide](/kubernetes/kubectl)**
- **[Kubernetes Troubleshooting Guide](/kubernetes/troubleshooting)**



## Example Deployment Descriptor

Use this with this command.

#### **`kubectl create -f wiki-deployment.yaml --record`**

```
apiVersion: apps/v1
kind: Deployment
metadata:
    name: wiki
spec:
    replicas: 3
    selector:
        matchLabels:
            pod-type: wiki
    template:
        metadata:
            name: wiki
            labels:
                pod-type: wiki
        spec:
            containers:
            -   name: vm-wiki
                image: devops4me/wiki:latest
                env:
                -   name: WIKI_CONTENT_REPO_URL
                    value: "https://github.com/apolloakora/devops-wiki"
                ports:
                -   containerPort: 4567
```


## Did You Know

- **[Deployments - Kubernetes Official Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)**
- **[Run a Stateless App using Deployments](https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/)**
