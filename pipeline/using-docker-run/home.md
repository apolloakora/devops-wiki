
# Install a Dockerized Jenkins CI Pipeline for JAVA and .NET Microservices

This is how to hand build a local docker tool-suite for continuous integration centred on Jenkins 2.0.

 - install the Jenkins 2.0 Continuous Integration Service
 - install PostgreSQL database for SonarQube state
 - install the SonarQube service
 - install a local docker registry to receive images from successful builds
 - configure and customize SonarQube and Jenkins
 - setup CI pipeline jobs for JAVA and .NET microservices


---


## Install the Jenkins 2.0 docker service

Create the Jenkins runtime host-volume mapping. Put the Dockerfile here into a directory and issue the docker build command to produce img.jenkins.

```
mkdir -p ~/runtime/jenkins
docker build --rm --no-cache --tag img.jenkins .
docker run \
    --detach \
    --name vm.jenkins \
    --restart always \
    --network host \
    --volume ~/runtime/jenkins:/var/jenkins_home \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume $(which docker):/usr/bin/docker \
    img.jenkins;
```


---


## Install PostgreSQL database for SonarQube state

Typically **SonarQube will work alongside Jenkins** and we show you here how to configure a seamless SonarQube Jenkins integration. The first step is to setup a database to hold SonarQube's state.

Any serious SonarQube setup will use a production-ready DBMS like MySQL, PostgreSQL, Oracle or SQLServer instead of the onboard H2 database. Here we opt for the dockerized PostgreSQL. For heavily used production environments you would opt for fully featured clustered and environments like Amazon's RDS.


## Setup SonarQube with PostgreSQL

First the database access credentials.

Do not use the default sonar/sonar credentials in a production setting. Let's ensure that the

- **username** is suffixed with 7 to 11 random lower / digit characters
- **password** contains 18 to 27 lower upper (case) and digit characters
- **database name** is suffixed with 4 to 7 random lowercase characters

```
docker run -d \
  --name vm.sonardb \
  --env POSTGRES_USER=sonar_rw_xyz123abc \
  --env POSTGRES_PASSWORD=xyzP23FSsd8ffa8So2bJw4so \
  --env POSTGRES_DB=sonar_db_hyqlbi \
  --network host \
  postgres:11.2;

docker logs vm.sonardb
```

Affirm success via **`docker logs vm.sonardb`** that contains ***`database system is ready to accept connections`***


---


## Run the SonarQube service

```
docker run              \
    --name vm.sonarqube \
    --detach            \
    --network host      \
    --env sonar.jdbc.username=sonar_rw_xyz123abc                     \
    --env sonar.jdbc.password=xyzP23FSsd8ffa8So2bJw4so               \
    --env sonar.jdbc.url=jdbc:postgresql://localhost/sonar_db_hyqlbi \
    sonarqube:7.7-community;
docker logs vm.sonarqube
```

**Now navigate to the SonarQube UI on port 9000.** Affirm with the **`docker logs vm.sonarqube`** command that a line saying ***`SonarQube is up`*** is printed out.


---


## Create a SonarQube API Access Token

**Skip this section if you are not securing SonarQube.**

The Jenkins SonarQube plugin needs to talk to SonarQube and it does this best, via an API access token.

To create the token you

- login to the SonarQube UI (the default is admin/admin)
- click on the user icon ( top right  ) then select **`My Account`**
- click on Security, enter a token name then **`Generate Token`**

A token like **`460ac5f22f08d10aed1d9ed569c182dc0d87d22e`** will be produced.

Now during the Jenkins install this token is best secured via the (core) credentials plugin. The SonarQube plugin can then access this via the credential ID you used.


---


## SonarQube User Adminisration

**Skip this section if you are not securing SonarQube.**

If you are preparing a production SonarQube setup and you plan to reverse engineer the user details - you can set these up locally and then import (with say pgdump) into your production setup.

SonarQube uses the BCrypt algorithm (called a one-way function) to create a hash of the passwords. This means it does not actually store the passwords and it is difficult to derive the passwords from the hash.


---


## Webhook | SonarQube Jenkins Callback Url

SonarQube needs to know the Jenkins URL to callback when it has finished analyzing a given project.

Using the API access token you created (above) is best practise.

```
curl "http://<<sonar.api.access.token>>@<<sonarqube-hostname>>:9000/api/webhooks/create" -X POST -d "name=jenkins&url=http://<<jenkins-hostname>>:8080/sonarqube-webhook/"
```

A successful response from SonarQube looks something like this.

```json
{
  "webhook": {
    "key": "AbcdefgHijkLMOnpqrsTuv123Wxy8z",
    "name": "jenkins",
    "url": "http:\/\/localhost:8080\/sonarqube-webhook\/"
  }
}
```

You can replace the above token with a valid username:password combo like the default **`admin:admin`** credentials.


---


## Run the Custom Docker Registry

Run the below command then check **`http://localhost:5000/v2/_catalog`** to verify that the custom docker registry is working.

```
docker run             \
    --detach           \
    --restart always   \
    --name vm.registry \
    --network host     \
    registry
```

After Jenkins or another agent has built and pushed an image into the docker registry you can verify it with the following commands. The first lists the available image tags.

```
curl -X GET http://localhost:5000/v2/<<image-name>>/tags/list
curl -X GET http://localhost:5000/v2/<<image-name>>/manifests/latest
curl -X GET http://localhost:5000/v2/<<image-name>>/manifests/2.4.xxx
```

### docker push error | http: server gave HTTP response to HTTPS client

When Jenkins tries to push to the local registry it encounters difficulties due to docker daemon security even though we specifiy a url like **`http://localhost:5000`**.

The solution is to create a file at **`/etc/docker/daemon.json`** with the following contents and then restart docker.

```
{
  "insecure-registries" : ["localhost:5000"]
}
```

Use command **`sudo service docker restart`** to restart the docker daemon. Any containers running without the **`--restart always`** flag will be down after restarting docker.


---

## How to Run Maven 3 Locally with Docker

Before letting the build loose on Jenkins, it pays to see it in action locally. This helps **especially when deploying to a Nexus repository** because of the configuration necessary within the **`pom.xml`**, Nexus itself and maven's **`/root/.m2/settings.xml`**

```
docker run -it --rm --name vm.maven.install -v $PWD:/usr/src/mymaven -w /usr/src/mymaven maven:3.6.0-jdk-11 mvn clean install
docker run -it --rm --name vm.mvn -v $PWD:/usr/src/mymaven -w /usr/src/mymaven maven:3.6.0-jdk-11 ls -lh /root/.m2
docker run -it --rm --name vm.mvn -v $PWD:/usr/src/mymaven -w /usr/src/mymaven maven:3.6.0-jdk-11 cat /root/.m2/settings-docker.xml
```

The second command shows us what is inside the key configuration folder **`/root/.m2`** and the third one shows the initial contents of the maven settings.xml file.

---


## Run the Nexus Repository for Java Library Archives

If the project is creating custom JAVA libraries that are not being publicly hosted and are consumed by other (usually) Microservices - we need to setup a JAVA repository archive like Nexus.

```
docker run           \
    --detach         \
    --restart always \
    --name vm.nexus  \
    --network host   \
    sonatype/nexus3
docker exec -it vm.nexus /bin/bash
cat /nexus-data/admin.password; echo
```

We use docker exec to go in and retrieve our admin password and login at **`http://localhost:8081`** and change the password. Tick the anonymous access box.

Now to create an archive repository we

- click on the ubiquitous settings wheel
- select Repositories
- create a repository
- opt for a Maven2 hosted repository
- name it **`java.commons.repository`**
- opt for a mixed version, permissive layout and allow redeployment of the same archive



---


## Configure and Customize SonarQube and Jenkins

The job is easier if the sonar plugin is installed by the Jenkins 2.0 docker image. The ID is **`sonar`**. Otherwise you need to install the plugin.

Within the Manage Jenkins "Global Tool Configuration" and the "Configure System" section sonar needs to be installed.

Again - the ideal is for the docker image to have done this already with a process that dynamically inserts

- the sonarqube installation name (for the Jenkinsfile)
- the sonarqube installation url
- the sonar project key (for .NET projects)


## SonarQube Configuration in Jenkins Home

The SonarQube configuration is powered by files in the Jenkins home directory called

- **`hudson.plugins.sonar.SonarGlobalConfiguration.xml`**
- **`hudson.plugins.sonar.SonarRunnerInstallation.xml`** and
- **`hudson.plugins.sonar.MsBuildSQRunnerInstallation.xml`** for .NET (C#) MSBuild projects

### hudson.plugins.sonar.SonarGlobalConfiguration.xml

Note the **`<<sonarqube-url>>:9000`** in the configuration.
Also note the **`sonarqube-service`** name in the configuration.


```
<?xml version='1.1' encoding='UTF-8'?>
<hudson.plugins.sonar.SonarGlobalConfiguration plugin="sonar@2.9">
  <installations>
    <hudson.plugins.sonar.SonarInstallation>
      <name>sonarqube-service</name>
      <serverUrl>http://<<sonarqube-url>>:9000</serverUrl>
      <credentialsId>sonar.access.token</credentialsId>
      <mojoVersion></mojoVersion>
      <additionalProperties></additionalProperties>
      <additionalAnalysisProperties></additionalAnalysisProperties>
      <triggers>
        <skipScmCause>false</skipScmCause>
        <skipUpstreamCause>false</skipUpstreamCause>
        <envVar></envVar>
      </triggers>
    </hudson.plugins.sonar.SonarInstallation>
  </installations>
  <buildWrapperEnabled>false</buildWrapperEnabled>
  <dataMigrated>true</dataMigrated>
  <credentialsMigrated>true</credentialsMigrated>
</hudson.plugins.sonar.SonarGlobalConfiguration>
```

### hudson.plugins.sonar.SonarRunnerInstallation.xml

Note the **`sonarqube-service`** name in the configuration which matches the reference in the Jenkinsfile.

```
<?xml version='1.1' encoding='UTF-8'?>
<hudson.plugins.sonar.SonarRunnerInstallation_-DescriptorImpl plugin="sonar@2.10">
  <installations>
    <hudson.plugins.sonar.SonarRunnerInstallation>
      <name>sonarqube-service</name>
      <properties>
        <hudson.tools.InstallSourceProperty>
          <installers>
            <hudson.plugins.sonar.SonarRunnerInstaller>
              <id>4.2.0.1873</id>
            </hudson.plugins.sonar.SonarRunnerInstaller>
          </installers>
        </hudson.tools.InstallSourceProperty>
      </properties>
    </hudson.plugins.sonar.SonarRunnerInstallation>
  </installations>
```

### hudson.plugins.sonar.MsBuildSQRunnerInstallation.xml

Note the **`sonarqube-msbuild`** name in the configuration which must match within the Jenkinsfile.

```
<?xml version='1.1' encoding='UTF-8'?>
<hudson.plugins.sonar.MsBuildSQRunnerInstallation_-DescriptorImpl plugin="sonar@2.10">
  <installations class="hudson.plugins.sonar.MsBuildSQRunnerInstallation-array">
    <hudson.plugins.sonar.MsBuildSQRunnerInstallation>
      <name>sonarqube-msbuild</name>
      <properties>
        <hudson.tools.InstallSourceProperty>
          <installers>
            <hudson.plugins.sonar.MsBuildSonarQubeRunnerInstaller>
              <id>4.7.1.2311</id>
            </hudson.plugins.sonar.MsBuildSonarQubeRunnerInstaller>
          </installers>
        </hudson.tools.InstallSourceProperty>
      </properties>
    </hudson.plugins.sonar.MsBuildSQRunnerInstallation>
  </installations>
```

## Configuring sonar.projectKey for .NET projects

For .NET we must configure a sonar.projectKey directive within Jenkins (after adding the SonarQube MSBuild installation).

From the Jenkins HOME directory the configuration file should be located at **`tools/hudson.plugins.sonar.MsBuildSQRunnerInstallation/sonarqube-msbuild/sonar-scanner-4.1.0.1829/conf/sonar-scanner.properties`**

The file needs to be changed to have an uncommented project key.

```
#Configure here general information about the environment, such as SonarQube server connection details for example
#No information about specific project should appear here

#----- Default SonarQube server
#sonar.host.url=http://localhost:9000

#----- Default source code encoding
#sonar.sourceEncoding=UTF-8

sonar.projectKey=b3f0c78bde216102c4288085882c31560fee711d
```

The project key is gained from setting it up within SonarQube.

### Outstanding Scaleability Problem for SonarQube MSBuild

This setup works for .NET with 1 microservice. I don't understand how this would work with multiple microservices. It almost feels like we need to **create a SonarQube MSBuild Installation for EVERY .NET microservice**.

For 2 or 3 microservices this is fine but this method is unlikely to scale well when 20 or more .NET microservices are involved.
