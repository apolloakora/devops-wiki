
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

If you are not using safe then replace the safe commands below with a **`docker login`** and then cat the config.json file to check. After creating the Kubernetes secret you **`docker logout`**.

```
safe login <book>
safe open <chapter> <verse>
safe docker login
cat ~/.docker/config.json
kubectl create secret generic registrycreds \
    --from-file=config.json=$HOME/.docker/config.json
safe docker logout
```

### Docker's config.json file

If using Dockerhub the config.json file will look something like this.

```json
{
	"auths": {
		"https://index.docker.io/v1/": {
			"auth": "AzByCxxxxxxxxxxxxxxxxXcYbZa"
		}
	},
	"HttpHeaders": {
		"User-Agent": "Docker-Client/18.09.7 (linux)"
	}
}
```

If using Amazon's ECR then you execute **`ecr login`** to get a docker login command. That docker login command produces the config.json with a rather large body of hexadecimal characters.


### Using safe to publish secret to kubernetes

```
safe publish --kubernetes-secret --docker-login
```

Why not ask safe to publish the secret with a **`safe publish --kubernetes-secret --docker-login`** Behind the scenes it runs the below command filling it the blanks for us. The default secret name is **`registrycreds`**.

```
kubectl create secret docker-registry registrycreds --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
```

### View Kubernetes Secret

You can observe the secret configuration with these commands.

```
kubectl get secret registrycreds -o json
kubectl get secret registrycreds --output=yaml
```

## Giving Kaniko Access to the Docker Login Credentials

For kaniko to access the credentials we mount the kubernetes secret as a file at **`/kaniko/.docker/config.json`**

The configuration for this is in the **[yaml pod template](https://github.com/devops4me/safedb.net/blob/master/pod-image-builder.yaml)** for kaniko.


``` yaml
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
            mountPath: /kaniko/.docker
        command:
        -   /busybox/sh
        -   "-c"
        args:
        -   /busybox/cat
        tty: true
    volumes:
        -   name: regcredsvolume
            secret:
                secretName: registrycreds
```

Finally let's visit a **[Jenkinsfile that uses Kaniko](https://github.com/devops4me/safedb.net/blob/master/Jenkinsfile)** to build its image.

## Jenkinsfile using Kaniko

The first stage of this Jenkinsfile uses Kaniko to build a docker image and push it into Docker Hub.



## Appendix | Kaniko Writing to a Local Registry

In the Jenkinsfile you can use Kaniko to write to a local http registry. You must take extra steps when reading images via Kubernetes due to Docker's quirky desire for https (http daemon error).

```
sh '/kaniko/executor -f `pwd`/Dockerfile -c `pwd` --destination 10.1.61.145:5000/devops4me/image-name:latest --insecure-registry 10.1.61.145:5000 --insecure --skip-tls-verify'
```

## Appendix | Looking Inside Kaniko

To investigate Kubernetes secret mount failures and other file matters you can look inside the container by running this commands in the Jenkinsfile before the main **`/kaniko/executor`** command.

```
sh 'echo $PWD'
sh 'ls -lah /'
sh 'ls -lah /kaniko'
sh 'ls -lah /kaniko/.config'
sh 'ls -lah /kaniko/.docker'
sh 'cat /kaniko/.docker/config.json'
```
