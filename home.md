
## Pipelines | Jenkins | SonarQube | Nexus

How do you create an entire **Continous Integration Pipeline** in one step using **[docker compose](/pipeline/using-docker-compose/)**? How do you use **[Kubernetes PaaS to run your Jenkins Build Jobs](/jenkins/kubernetes-slaves)**? How do you setup a **[declarative Jenkinsfile for a JAVA microservice](/pipeline/for-java-microservice/)**? What about a **[.NET microservice](/pipeline/for-dotnet-microservice/)**?

- **[use scaleable Kubernetes cluster to run Jenkins Jobs (Slaves)](/jenkins/kubernetes-slaves)**
- **[use docker compose to setup Jenkins SonarQube Nexus and a Docker Registry](/pipeline/using-docker-compose/)**
- **[use simple docker run statements to setup Jenkins SonarQube Nexus and a Docker Registry](/pipeline/using-docker-run/)**
- **[tail kubernetes logs from all pods and containers](/kubernetes/kubectl-logs)**
- **[declarative Jenkinsfile to setup a JAVA microservice pipeline](/pipeline/for-java-microservice/)**
- **[declarative Jenkinsfile to setup a .NET microservice pipeline](/pipeline/for-dotnet-microservice/)**

**[Visit pipeline documentation here.](/pipeline/)**


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


