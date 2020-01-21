
## Pipelines | Jenkins | SonarQube | Nexus

How do you create an entire **Continous Integration Pipeline** in one step using **[docker compose](/pipeline/pipeline-using-docker-compose)**? How do you use **[Kubernetes PaaS to run your Jenkins Build Jobs](/kubernetes/kubernetes-slaves)**? How do you setup a **[declarative Jenkinsfile for a JAVA microservice](/pipeline/for-java-microservice/)**? What about a **[.NET microservice](/pipeline/for-dotnet-microservice/)**?

- **[use scaleable Kubernetes cluster to run Jenkins Jobs (Slaves)](/kubernetes/kubernetes-slaves)**
- **[use docker compose to setup Jenkins SonarQube Nexus and a Docker Registry](/pipeline/pipeline-using-docker-compose)**
- **[use simple docker run statements to setup Jenkins SonarQube Nexus and a Docker Registry](/pipeline/pipeline-using-docker-run)**
- **[kubectl commands | copy | log | rollout | set-image](/kubernetes/kubectl-commands)**
- **[Google Kaniko for Building Docker Images in Kubernetes](kubernetes/kaniko)**
- **[declarative Jenkinsfile to setup a JAVA microservice pipeline](/pipeline/for-java-microservice/)**
- **[declarative Jenkinsfile to setup a .NET microservice pipeline](/pipeline/for-dotnet-microservice/)**



---



## [Use Kubernetes to run Jenkins Jobs](/kubernetes/kubernetes-slaves)

The benefits of running your Jenkins slaves (workers/builds) in Kubernetes are

- the Jenkins master and UI **never gets overburdened** hence rarely fails
- you can run a complex Jenkins workload locally against branches
- a different team can manage the Kubernetes stack implementing **platform as a service**
- you can use multi-tenancy to run pipelines and app environments in the same cluster
- you can **scale Jenkins horizontally** as well as vertically

#### [Full Article | How to Run Jenkins Builds in Kubernetes](/kubernetes/kubernetes-slaves)



---


## Architecture and System Design Wiki

- **[Top of the Pops 4 Programming Languages](https://www.tiobe.com/tiobe-index/)**
- **[Azure Architecture Guides](https://docs.microsoft.com/en-us/azure/architecture/)**
- **[Enterprise Integration Patterns (Messaging)](https://www.enterpriseintegrationpatterns.com/patterns/messaging/)**
