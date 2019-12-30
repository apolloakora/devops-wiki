
# Use Kaniko to Build Docker Images on Kubernetes

When running Jenkins on a Kubernetes cluster how do we securely build docker images. Building docker images is a common use case during the execution of dockerized pipelines driven by a Jenkinsfile, a JNLP slave sidecar container and a pod template in YAML format.

The other common options have pitfalls including

- **dind** (docker in docker) - using docker as a container to build means running it in privileged mode
- docker from the kubernetes node host (exposing **`/var/run/docker.sock`**) also requires privileged execution
- running docker builds on the Jenkins master loses the benefit of not overloading the Jenkins master node
- doing Docker builds elsewhere (like Dockerhub) is a separation that add complexity and confusion

A big disadvantage of the docker out of docker (using the pod's node) is that random nodes begin to fill up with random docker images. **Repeatability suffers** when say a job running on this node with layer caching behaves differently to it being run on that node.

## Kaniko to Dockerhub | Securing Docker Login with Kubernetes Secrets

**Problem** - Kaniko is a transient container so if you want a docker image to survive after the job runs you must provide a Docker registry. You must mitigate http (insecure-registry) issues if creating a local registry. Suppose you opt to use Dockerhub - now you must authenticate to push images (unlike with a local registry). So how do we authenticate without putting Dockerhub credentials into a Git repository?

**Solution** - Pump registry credentials as Kubernetes secrets during cluster initialization. This way the pod only references the secret thus keeping the secret completely out of the Git repository. Ideally you would use safe to inject the secrets straight into Kubernetes so that at the credentials are always encrypted at rest.

```
safe login <book>
safe open <chapter> <verse>
safe docker login
cat ~/.docker/config.json
kubectl create secret generic registrycreds \
    --from-file=.dockerconfigjson=$HOME/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
safe docker logout
```

Why not ask safe to publish the secret with a **`safe ksecrets create`** - behind the scenes it runs the below command filling it the blanks for us. The default secret name is **`registrycreds`**.

```
kubectl create secret docker-registry registrycreds --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
```

You can observe the secret configuration with these commands.

```
kubectl get secret registrycreds --output=yaml
kubectl get secret registrycreds --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode
```

## Giving Kaniko Access to the Docker Login Credentials

For kaniko to access the credentials we mount the kubernetes secret as a file at the point that the **`kaniko container`** is started.

The configuration for this is in the **yaml pod template** for kaniko.


```
# This kubernetes pod template instantiates a slave (JNLP) sidecar container
# for Jenkins master slave communications and the Google Kaniko container for
# building docker images without demanding privileged docker in/out access.
---
kind: Pod
metadata:
    name: kaniko
spec:
    containers:

    -   name: jnlp
        image: jenkins/jnlp-slave:latest

    -   name: kaniko
        image: gcr.io/kaniko-project/executor:debug
        imagePullPolicy: Always
        volumeMounts:
        -   name: regcredsvolume
            mountPath: /kaniko/.docker/config.json

    volumes:
        -   name: regcredsvolume
            secret:
                secretName: registrycreds

    command:
    -   /busybox/sh
    -   "-c"

    args:
    -   /busybox/cat
        tty: true
```