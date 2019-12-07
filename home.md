
![eco-platform logo](media/eco-platform.co.uk-logo.png "Kubernetes Clusters, Terraform, Gollum Wiki for DevOps Engineers")


# Use Docker Compose to Create a Continuous Integration Pipeline

#### [The Full Blog is Here](ci/ci)

Continuous integration pipelines are the heart and soul of a software development project. The pipeline starts with version controlled assets and creates something deployable like a docker image, database evolution files or a Java web archive. Aside from this

- for **developers** they provide **fast early feedback**
- for **testers** they ensure bugs already found do not reappear
- for the **customer** they ensure a **quality baseline**

## How to Build a Continuous Integration Pipeline for JAVA and .NET Microservices

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

