
# Creating a Continuous Integration Pipeline

Continuous integration pipelines are the heart and soul of a software development project. The pipeline starts with version controlled assets and creates something deployable like a docker image, database evolution files or a Java web archive. Aside from this

- for **developers** they provide **fast early feedback**
- for **testers** they ensure bugs already found do not reappear
- for the **customer** they ensure a **quality baseline**


---


## How to Build a Continuous Integration Pipeline for JAVA and .NET Microservices

These steps will create a continuous integration pipeline with a dockerized **`Jenkins`**, **`SonarQube`**, **`Nexus Repository Manager`**, **`Docker Registry`** and an **`ELK stack`** for collating and visualizing container logs.


---


## Part 1 - Setup Docker on the Machine

Execute these commands inside an unbent and unbroken **Ubuntu 18.04** machine.

- **`sudo apt-get update && sudo apt-get --assume-yes upgrade`** # install latest updates
- **`sudo apt install -y docker.io`** # to install docker
- **`sudo usermod -aG docker ${USER}`** # allow user to run docker commands without sudo
- exit the shell session and login again to allow the usermod command to take effect
- **`git clone https://github.com/apolloakora/devops-wiki`** # pull down this project
- **`cd devops-wiki/ci`** # step into the project files here
- **`sudo cp daemon.json /etc/docker/daemon.json`** # to allow pushing to a http docker registry
- **`sudo service docker restart`** # to assimilate the daemon.json configuration

Now docker is running and you have installed a daemon.json file that will allow our http docker registry.


---


## Part 2 - Setup the Unified Logging Layer

To have an insight into what the docker containers are doing we need to have a unified logging layer and this is provided by the fluentd log collector and the ElasticSearch database. We bring up the Kibana dashboard through which we can visualize the logs.

```
docker run --detach                    \
    --name elasticsearch               \
    --publish 9200:9200                \
    --publish 9300:9300                \
    --restart always                   \
    --log-driver json-file             \
    --env discovery.type=single-node   \
    --env transport.host=127.0.0.1     \
    --env xpack.security.enabled=false \
    docker.elastic.co/elasticsearch/elasticsearch-platinum:6.0.0 && sleep 20
```

```
docker run --detach        \
    --name vm.kibana       \
    --publish 5601:5601    \
    --restart always       \
    --link elasticsearch   \
    --log-driver json-file \
    --env "ELASTICSEARCH_URL=http://elasticsearch:9200" \
    docker.elastic.co/kibana/kibana:6.0.0 && sleep 20
```

```
docker run --detach                        \
    --name vm.fluentd                      \
    --network host                         \
    --restart always                       \
    --log-driver json-file                 \
    --env FLUENTD_CONF=fluentd-simple.conf \
    --env ELASTICSEARCH_HOSTNAME=localhost \
    --env ELASTICSEARCH_PORT=9200          \
    devops4me/fluentd
```

If troubleshooting then instead of using **`--detach`** insert **`docker run --interactive --tty`**


---


## Part 3 - Clone and Use Jenkins Job Definitions

This step automates the manual setup of current Jenkins job definitions. You'll need a URL of the git repository holding the jenkins job config.xml files under a directory which is the job name.

- **`mkdir -p ~/runtime`**
- **`git clone http://gitlab/infrastructure/pipeline-jobs ~/runtime/pipeline-jobs`**


---


## Part 4 - Run Docker Compose

We need to install the latest version of **`docker compose`** and then bring up the entire set of pipeline services with docker-compose.

- **`docker-compose version`**
- **`sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`**
- **`sudo chmod +x /usr/local/bin/docker-compose`**
- log out of the shell session and then log in again
- **`docker-compose --version`**
- **`cd devops-wiki/ci`** # step back into into the project files here
- **`COMPOSE_HTTP_TIMEOUT=300 docker-compose up --detach`** # to bring up all the pipeline docker services

To ascertain the success of the container orchestration we need to visit the Kibana dashboard and check.
**Only continue once you see the SonarQube is Up log message within Kibana.**

The steps are

- visit the Kibana dashboard at **`port 5601`**
- **setup an index pattern for logstash-** - if you cannot even after a while then elasticsearch is not receiving any logs
- go to the Discover section to view the logs


---


## Part 5 - Configure the Jenkins (CI) Service

- **`curl "http://admin:admin@localhost:9000/api/webhooks/create" -X POST -d "name=jenkins&url=http://localhost:8080/sonarqube-webhook/"`** # to allow SonarQube to call back Jenkins
- Use the CUrl below to let Jenkins access your microservices Git repository

```
curl -X POST 'http://localhost:8080/credentials/store/system/domain/_/createCredentials' \
--data-urlencode 'json={
  "": "0",
  "credentials": {
    "scope": "GLOBAL",
    "id": "git.credentials.id",
    "username": "<<git-repository-username>>",
    "password": "<<git-repository-password>>",
    "description": "Git Repository Credentials",
    "$class": "com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl"
  }
}'
```

- go into Jenkins | Manage Jenkins | Configure System and scroll down to the sonarqube-service configuration
- Enter the machine's IP address like **`http://<<ip-address>>:9000`** and **`Save`**


---


## Part 6 - Configure the Nexus Repository

We are going to **set the admin password**, **enable anonymous access** and **allow maven to redeploy artifacts** to the releases and snapshots repositories.

- **`docker exec -it vm.nexus cat /nexus-data/admin.password; echo;`** # discover the Nexus password
- goto Nexus at http://<<ip-address>>:8081 and enter admin and the above password
- enter a new password like p455w0rd and when prompted tick **enable anonymous access**

### Allow Maven to Redeploy Artifacts to Nexus

Let's make Nexus idempotent so that we do not experience failures **the second time we transfer an artifact** that already exists.

To do this you
- click on the **settings wheel** at the top
- select **repositories**
- select **maven-releases**
- Under Hosted / Deployment policy select **Allow Redeploy**
- do the same for the **maven-snapshots** repository


---



## Part 7 - Build Every Pipeline Job then Verify Verify Verify

The time has come to verify and harvest observable value from the running continuous integration pipelines. To do this you

- gently click Build Now on each Jenkins pipeline job **roughly once every minute**
- check for **Build Success** for each and every pipeline job - if not troubleshoot (alongside developers) if need be
- spot check that microservice **Git commit tags** result in a **Docker registry image** sporting that same **tag**
- visit SonarQube to verify that all built JAVA projects have been scanned an drillable quality metrics are available
- visit the Kibana dashboard and examine the **Last Hour"" looking for out of the ordinary content and frequency


---


### You've got to the end. Well done!


---



### The End



---



## Helpful Docker Compose Commands


If things do not go to plan then use
- **`docker-compose rm --force`** # to remove the containers
- **`docker rmi <<image-id>>`** # repeatedly to force pulling images from the registry
- **`docker-compose build --no-cache`** # make docker rebuild images instead of resorting to the cache


---


## Allow Jenkins to Read your Git repository | Optional

**Skip this if your Git repo has public read access but ensure that the job config.xml files do not reference the git.credentials.id**

**Change the username and password fields**.

```
curl -X POST 'http://localhost:8080/credentials/store/system/domain/_/createCredentials' \
--data-urlencode 'json={
  "": "0",
  "credentials": {
    "scope": "GLOBAL",
    "id": "git.credentials.id",
    "username": "<<git-repository-username>>",
    "password": "<<git-repository-password>>",
    "description": "Git Repository Credentials",
    "$class": "com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl"
  }
}'
```

---


## Using SonarQube Authentication | Optional

**Skip this section unless you want Jenkins to authenticate with SonarQube via tokens.**

If using authentication with SonarQube you must
- switch on authentication
- create a user called jenkins
- configure that user to be able to create projects scan code
- create a token with ID sonar.access.token
- paste the token in the CUrl command below to Jenkins

```
curl -X POST 'http://localhost:8080/credentials/store/system/domain/_/createCredentials' \
--data-urlencode 'json={
  "": "0",
  "credentials": {
    "scope": "GLOBAL",
    "id": "sonar.access.token",
    "secret": "2d7ca29d089775c0cb9530d4b4d4c9293e3b92d1",
    "description": "SonarQube Authentication Token",
    "$class": "org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl"
  }
}'
```

---


## Docker Compose CI Pipeline with Jenkins SonarQube Nexus and More

Docker compose is necessary when your continous integration pipeline boasts 5 to 10 docker services with 10 to 30 repository projects. With more than 50 projects the complexity overheads of a container orchestrator like Kubernetes running scaleable Jenkins slaves, are justified.

The above **docker compose** continuous integration pipeline consists of

- **Jenkins** for **orchestrating the pipeline**
- **SonarQube** for **quality gates and metrics**
- **PostgreSQL** for **storing SonarQube's state**
- **Nexus** for **storing private common JAVA libraries**
- a **Docker Registry** for holding **pipeline's microservice docker images**
- **LogStash** for **collating the pipeline's logging output**
- **ElasticSearch** to at as the **unified logging layer database**
- **Kibana** for **visualizing the pipeline's logs**


---



```
ERROR: for vm.registry  UnixHTTPConnectionPool(host='localhost', port=None): Read timed out. (read timeout=60)
ERROR: for vm.sonardb  UnixHTTPConnectionPool(host='localhost', port=None): Read timed out. (read timeout=60)
ERROR: for vm.nexus  UnixHTTPConnectionPool(host='localhost', port=None): Read timed out. (read timeout=60)
ERROR: for vm.jenkins-2.0  UnixHTTPConnectionPool(host='localhost', port=None): Read timed out. (read timeout=60)
ERROR: for docker-registry  UnixHTTPConnectionPool(host='localhost', port=None): Read timed out. (read timeout=60)
ERROR: for sonar-database  UnixHTTPConnectionPool(host='localhost', port=None): Read timed out. (read timeout=60)
ERROR: for nexus-repository  UnixHTTPConnectionPool(host='localhost', port=None): Read timed out. (read timeout=60)
ERROR: for jenkins  UnixHTTPConnectionPool(host='localhost', port=None): Read timed out. (read timeout=60)
ERROR: An HTTP request took too long to complete. Retry with --verbose to obtain debug information.
If you encounter this issue regularly because of slow network conditions, consider setting COMPOSE_HTTP_TIMEOUT to a higher value (current value: 60).
```

---


## Docker Compose Reference Documentation

- **[Docker Compose Command Line Reference](https://docs.docker.com/compose/reference/)**
- **[Docker Compose Reference Documentation](https://docs.docker.com/compose/compose-file/)**
- **[Docker Compose Documentation Menu](https://docs.docker.com/compose/)**
- **[Docker Compose Overview (Flask App)](https://docs.docker.com/compose/gettingstarted/)**


---


## How to Run Maven 3 Locally with Docker

Before letting the build loose on Jenkins, it pays to see it in action locally. This helps **especially when deploying to a Nexus repository** because of the configuration necessary within the **`pom.xml`**, Nexus itself and maven's **`/root/.m2/settings.xml`**

```
docker run -it --rm --name vm.mvn --network host -v $PWD:/root/codebase devops4me/maven-3.6.0-jdk-1 mvn clean deploy
docker run -it --rm --name vm.maven.install -v $PWD:/usr/src/mymaven -w /usr/src/mymaven maven:3.6.0-jdk-11 mvn clean deploy
docker run -it --rm --name vm.mvn -v $PWD:/usr/src/mymaven -w /usr/src/mymaven maven:3.6.0-jdk-11 ls -lh /root/.m2
docker run -it --rm --name vm.mvn -v $PWD:/usr/src/mymaven -w /usr/src/mymaven maven:3.6.0-jdk-11 cat /root/.m2/settings-docker.xml
```

The second command shows us what is inside the key configuration folder **`/root/.m2`** and the third one shows the initial contents of the maven settings.xml file.


---


## SonarQube Restart Problem due to Disk Space

**`message ClusterBlockException blocked by: FORBIDDEN/12/index read-only / allow delete (api)`**

When the disk space available drops below a certain point, SonarQube will not start.

#### [SonarQube ClusterBlockException Blog](https://community.sonarsource.com/t/sonarqube-7-7-developer-upgrade-not-starting/7999/3)

See the above link for some other reasons of occurrence.
