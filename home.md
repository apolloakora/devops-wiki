
![eco-platform logo](media/eco-platform.co.uk-logo.png "Kubernetes Clusters, Terraform, Gollum Wiki for DevOps Engineers")


# devopswiki.co.uk homepage



---



# [Use Kubernetes to run Jenkins Jobs](/jenkins/kubernetes-slaves)

The benefits of running your Jenkins slaves (workers/builds) in Kubernetes are

- the Jenkins master and UI **never gets overburdened** hence rarely fails
- you can run a complex Jenkins workload locally against branches
- a different team can manage the Kubernetes stack implementing **platform as a service**
- you can use multi-tenancy to run pipelines and app environments in the same cluster
- you can **scale Jenkins horizontally** as well as vertically

#### [Full Article | How to Run Jenkins Builds in Kubernetes](/jenkins/kubernetes-slaves)



---



## [Install a Jenkins/Sonar/Nexus Pipeline with Docker Compose]()

#### [The Full Blog is Here](ci/ci)

These steps will create a continuous integration pipeline with a dockerized **`Jenkins`**, **`SonarQube`**, **`Nexus Repository Manager`**, **`Docker Registry`** and an **`ELK stack`** for collating and visualizing container logs.

Execute these commands inside an unbent and unbroken **Ubuntu 18.04** machine.

- **`sudo apt install -y docker.io`** | to install docker
- **`git clone`** this project and step into it
- **`sudo cp daemon.json /etc/docker/daemon.json`** | to allow pushing to a http docker registry
- **`sudo service docker restart`** | to assimilate the daemon.json configuration
- **`docker-compose up`** | to bring up all the pipeline docker services
- **`curl "http://localhost:9000/api/webhooks/create" -X POST -d "name=jenkins&url=http://localhost:8080/sonarqube-webhook/"`** | to allow SonarQube to call back Jenkins
- use CUrl to give Jenkins the Git repository credentials where your microservices are

#### [Continue Reading me Here](ci/ci)

---

