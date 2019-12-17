
# How to Run Jenkins Build Jobs in Kubernetes

The benefits of running your Jenkins slaves (workers/builds) in Kubernetes are

- the Jenkins master and UI **never gets overburdened** hence rarely fails
- you can run a complex Jenkins workload locally against branches
- a different team can manage the Kubernetes stack implementing **platform as a service**
- you can use multi-tenancy to run pipelines and app environments in the same cluster
- you can **scale Jenkins horizontally** as well as vertically

## What you need

Follow the **[How to Setup Microk8s on Ubuntu](kubernetes/microk8s-install)** to setup a Kubernetes cluster with 2 or 3 commands. If you have another laptop then repeat the setup and then join the node to have a true distributed Kubernetes cluster in your room or on any cloud.


---


## Step 1 | Configure the Jenkins Kubernetes Plugin

The **[Jenkins/Kubernetes plugin](https://plugins.jenkins.io/kubernetes)** is already configured into **[this DockerHub Jenkins docker image](https://hub.docker.com/r/devops4me/jenkins-2.0)**. You can extend it or copy and change the Dockerfile.

This **[Jenkins Worker Docker Image](https://hub.docker.com/r/jenkinsci/jnlp-slave)** is used as the vanilla template to run jobs. It is _open for extension_ as object orienteers would say.

### Manual Configuration of Kubernetes Plugin

It pays to perform a manual configuration first and then automate the steps usually through building your own Jenkins dockerfile.

The manual configuration steps of the Jenkins plugin are to

- enter the Name **`kubernetes`**
- use **`kubectl cluster-info | grep master`** to uncover the kubernetes url
- if you get a 27.0.0.1 url you can use the machine's IP address
- if the jenkins master is itself running within kubernetes you can use an svc cluster local address
- tick the **`Disable https certificate check`** if you haven't setup custom certificates
- **important** - use the **Test Connection** button to do just that
- if Jenkins master is in Kubernetes use **`kubectl get pods -o wide`** for the IP and maybe add **`:8080`**
- also if Jenkins master is a Kubernetes service use **`kubectl get services`** for the (no port) IP address
- setup the pod label with key **`jenkins`** and value **`slave`**
- setup a **Pod Template** with **Name** and **Labels** set to **`jenkins-slave`** and **Namespace** as **`jenkins`**
- for **Usage** select **`Use this node as much as possible`**
- Create a container with **Name** **`jnlp`** and **Docker Image** as **`jenkinsci/jnlp-slave`**
- Create a volume with both **Host path** and **Mount path** as **`/var/run/docker.sock`**



---



## Step 2 | Configure the Jenkinsfile

Suppose we are building a JAVA project with Maven. Then our kubernetes pod template defined within **`pipeline-pod.yaml`** must contain a container called **`maven`**.

This simple Jenkinsfile will perform the build within Kubernetes.

```
pipeline {
    agent {
        kubernetes {
            yamlFile 'pipeline-pod.yaml'
        }
    }    
    stages{
        stage('test'){
            steps{
                container('maven') {
                    sh 'mvn clean test'
                }
            }
        }
     }
}
```



---



## Step 3 | Configure the Pod Template Yaml

The YAML for creating the pod will lbe sent to Kubernetes embellished with extra details and environment variables. Go to the **`Console Output`** in Jenkins (right at the start) to see the actual YAML used.

Create this pipeline-pod.yaml file in the same directory as the Jenkinsfile.

```
metadata:
  labels:
    pod-type: jenkins-worker
spec:
  containers:
  - name: jnlp
    env:
    - name: CONTAINER_ENV_VAR
      value: jnlp
  - name: maven
    image: maven:3.3.9-jdk-8-alpine
    command:
    - cat
    tty: true
    env:
    - name: CONTAINER_ENV_VAR
      value: maven
```

This pod runs the jnlp container that keeps the Jenkins master apprised. It also runs maven to do the bulk of the build work.



---



## Step 4 | Watch Kubernetes Run your Jenkins Job

In the Jenkins job **`Configure`** section ensure that you **allow concurrent builds** to see multiple pods (hopefully on multiple nodes) running the builds.

Go to the job and **`Build Now`** - wait a few seconds - click Build Now again - and then again.

Now do **`kubectl get pods -o wide`** to see multiple Jenkins builds being run by Kubernetes on multiple nodes. Gone are the days of your Jenkins master slowing down under the burden of builds. You can now **scale Jenkins horizontally** rather than vertically.



## Did You Know?

- the [Jenkins Kubernetes plugin is well documented here](https://plugins.jenkins.io/kubernetes)
- this is a great article on **[scaling Jenkins with Kubernetes](https://www.blazemeter.com/blog/how-to-setup-scalable-jenkins-on-top-of-a-kubernetes-cluster/)**

