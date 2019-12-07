
# CI Pipeline with ELK Logging | ElasticSearch | Logstash | Kibana | Fluentd

This article focuses on adding logging drivers to the docker run of CI pipeline services. Please refer to the **[CI pipeline install blog](install-jenkins-ci-pipeline.md)** for the nitty gritty of actually installing a CI pipeline.

## Install the Jenkins 2.0 docker service

Create the Jenkins runtime host-volume mapping. Put the Dockerfile here into a directory and issue the docker build command to produce img.jenkins.

```
mkdir -p ~/runtime/jenkins
docker run \
    --detach \
    --name vm.jenkins \
    --restart always \
    --network host \
    --volume ~/runtime/jenkins:/var/jenkins_home \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume $(which docker):/usr/bin/docker \
    --log-driver fluentd \
    devops4me/jenkins-2.0;
```


---


## Install PostgreSQL database for SonarQube state


```
docker run -d \
  --name vm.sonardb \
  --env POSTGRES_USER=sonar_rw_xyz123abc \
  --env POSTGRES_PASSWORD=xyzP23FSsd8ffa8So2bJw4so \
  --env POSTGRES_DB=sonar_db_hyqlbi \
  --network host \
  --log-driver fluentd \
  postgres:11.2;
```


---


## Run the SonarQube service

```
docker run               \
    --name vm.sonarqube  \
    --detach             \
    --network host       \
    --log-driver fluentd \
    --env sonar.jdbc.username=sonar_rw_xyz123abc                     \
    --env sonar.jdbc.password=xyzP23FSsd8ffa8So2bJw4so               \
    --env sonar.jdbc.url=jdbc:postgresql://localhost/sonar_db_hyqlbi \
    sonarqube:7.7-community;
```


---



## Run the Custom Docker Registry

Run the below command then check **`http://localhost:5000/v2/_catalog`** to verify that the custom docker registry is working.

```
docker run             \
    --detach           \
    --restart always   \
    --name vm.registry \
    --network host     \
    --log-driver fluentd \
    registry
```


## Run the Nexus Repository for Java Library Archives

If the project is creating custom JAVA libraries that are not being publicly hosted and are consumed by other (usually) Microservices - we need to setup a JAVA repository archive like Nexus.

```
docker run           \
    --detach         \
    --restart always \
    --name vm.nexus  \
    --network host   \
    --log-driver fluentd \
    sonatype/nexus3
```

