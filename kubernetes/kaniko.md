
# Use Kaniko to Build Docker Images on Kubernetes

When running Jenkins on a Kubernetes cluster how do we securely build docker images. Building docker images is a common use case during the execution of dockerized pipelines driven by a Jenkinsfile, a JNLP slave sidecar container and a pod template in YAML format.

![kaniko logo](/media/kaniko-logo-rectangle.png "Google Kaniko for Kubernetes Logo")

## Kaniko Docker Login Credentials Problem | Kubernetes Secrets

**Problem** - **Kaniko needs a Docker registry.** If we setup a local registry we must mitigate http (insecure-registry) issues. If we use Dockerhub pulling is easy, but we must authenticate to push. **So with Dockerhub how do we authenticate without putting docker login credentials into a Git repository?**

**Solution** - Pump registry credentials as Kubernetes secrets after cluster initialization. This way the pod only references the secret name - the username/password is now not in the Git repository.

## Step 1 | Create Registry Creds Kubernetes Secret

```
docker login
cat ~/.docker/config.json
kubectl create secret generic registrycreds \
    --from-file=config.json=$HOME/.docker/config.json
docker logout
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

If using Amazon's ECR you execute **`ecr login`** to get a docker login command. That docker login command produces the config.json with a rather large body of hexadecimal characters.


### Verify | View Kubernetes Secret

You can observe the secret configuration with these commands.

```
kubectl get secret registrycreds -o json
kubectl get secret registrycreds --output=yaml
```

## Step 2 | Create Kaniko Pod Template

The clever part in this pod template configuration is giving Kaniko access to the docker login credentials. Now for kaniko to access the credentials we mount the kubernetes secret as a file at **`/kaniko/.docker/config.json`**

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

Now let's visit a **[Jenkinsfile that uses Kaniko](https://github.com/devops4me/safedb.net/blob/master/Jenkinsfile)** to build its image.

## Step 3 | Jenkinsfile using Kaniko to Build Docker Images

The first stage of this Jenkinsfile uses Kaniko to build a docker image and push it into Docker Hub. The next stage runs **cucumber unit tests** inside the just-built DockerHub image.

```
pipeline
{
    agent none
    stages
    {
        stage('Build Safe Docker Image')
        {
            agent
            {
                kubernetes
                {
                    defaultContainer 'kaniko'
                    yamlFile 'pod-image-builder.yaml'
                }
            }
            steps
            {
               /*
                * We checkout the git repository again because we
                * are running in a different pod setup specifically
                * to build and test the software.
                */
                checkout scm
                sh '/kaniko/executor -f `pwd`/Dockerfile -c `pwd` --destination devops4me/haven:latest --cleanup'
            }
        }
        stage('Run the Cucumber Tests')
        {
            agent
            {
                kubernetes
                {
                    yamlFile 'pod-image-haven.yaml'
                }
            }
            steps
            {
                container('haventests')
                {
                    sh '/home/safeci/code/cucumber-test.sh'
                }
            }
        }
    }
}
```

## Step 4 | Pod to Run Unit Tests

This pod template is for the second half of the Jenkinsfile. It pulls the just-built image from Dockerhub and runs the unit tests within it.

```
metadata:
    labels:
        pod-type: jenkins-worker
spec:
    containers:
    -   name: jnlp
        env:
        -   name: CONTAINER_ENV_VAR
            value: jnlp
    -   name: haventests
        image: devops4me/haven:latest
        imagePullPolicy: Always
        command:
        -   cat
        tty: true
        env:
        -   name: CONTAINER_ENV_VAR
            value: haventests
```


---


## Appendix | Other Ways to Build Docker Images

Kaniko is not the only way to build docker images in and around the Kubernetes platform. The other common options (and their pitfalls) include

- **dind** (docker in docker) - a docker, docker container can build images but only in privileged mode
- docker from the kubernetes node host (exposing **`/var/run/docker.sock`**) also requires privileged execution
- **running the Jenkins master external to Kubernetes** and build images on that but you lose scaleability
- doing **Docker builds elsewhere (like Dockerhub)** but the separation adds complexity and affects readability

Another big disadvantage of the docker out of docker (using the pod's node) is that random nodes begin to fill up with random docker images. **Repeatability suffers** when say a job running on this node with layer caching behaves differently to it being run on that node.


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


## Appendix | Using Safe to Create Kubernetes Secrets

Ideally you would use safe to inject the secrets straight into Kubernetes so that at the credentials are always encrypted at rest.

```
safe login <book>
safe open <chapter> <verse>
safe docker login
cat ~/.docker/config.json
kubectl create secret generic registrycreds \
    --from-file=config.json=$HOME/.docker/config.json
safe docker logout
```

## Appendix | Using safe to publish secret to kubernetes

You can use safe's ubiquitous and well-loved **`publish`** command. We are publishing **`docker-registry-credentials`** as a **`kubernetes-secret`**.

```
safe publish --docker-registry-credentials --kubernetes-secret
```

Behind the scenes it runs the below command filling it the blanks for us. The default secret name is **`registrycreds`**.

```
kubectl create secret docker-registry registrycreds --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
```
