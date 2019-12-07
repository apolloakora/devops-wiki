
# How to Setup Maven 3 with a Nexus 3 Repository

The Maven setup with Nexus is **not easy** so this guide carefully and thoroughly takes you through each and every step to building a JAVA project with (Dockerized )Maven, Nexus and Jenkins.

The build pipeline (via the Jenkinsfile) distinguishes two types of JAVA project namely

- a **shared library project** that ends up with a JAR inside our **custom Nexus repository**
- **microservices** that consume shared libraries and end up as **Docker images in a registry**

## Create a custom Nexus 3 Repository

We use docker to deploy the Nexus repository. The **`--network host`** switch is important for visibility by the Maven docker container that we'll run both from the command line and through a Jenkins CI server.


```
docker run           \
    --detach         \
    --restart always \
    --name vm.nexus  \
    --network host   \
    sonatype/nexus3;
```

### 1. Wait for some moments to retrieve the password

With the command **`$ docker exec -it vm.nexus cat /nexus-data/admin.password; echo;`** you can discover the Nexus password, but give it time.

If you retrieve the Nexus password to early you will get a **`cat: /nexus-data/admin.password: No such file or directory`**


### 2. Configure Nexus Anonymous Access

We are keeping it simple and allowing anonymous read access to Nexus. So armed with the long password like 52f172cc-8d21-4230-a305-86eb64dd4019 you then

- goto Nexus at http://<<ip-address>>:8081 and enter admin and the above password
- enter a new password like p455w0rd and when prompted tick **enable anonymous access**


### 3. Allow Maven to *redeploy artifacts* to Nexus

Let's make Nexus idempotent so that we do not experience failures **the second time we transfer an artifact** that already exists.

To do this you
- click on the **settings wheel** at the top
- select **repositories**
- select **maven-releases**
- Under Hosted / Deployment policy select **Allow Redeploy**
- do the same for the **maven-snapshots** repository


---


## Use Maven to deploy a library to Nexus

You've built a commons library that other projects like microservices (and other libraries) will depend on. You need to get the JAR into Nexus.
Goto the root of your commons library project containing the **pom.xml**.


### 1. Build the Library as a Release


In your POM to build as a release ensure that the version does **not** include the term SNAPSHOT.

```
    <groupId>com.yourcompany</groupId>
    <artifactId>commons-library</artifactId>
    <version>1.0.1</version>
```


### 2. Prepare Distribution Management in the POM


For Maven 3 to deploy any library JAR to a custom Nexus repository there needs to be a **distributionManagement** section in the POM like this.

```
    <distributionManagement>
        <snapshotRepository>
            <id>maven-snapshots</id>
            <url>http://localhost:8081/repository/maven-snapshots/</url>
        </snapshotRepository>
        <repository>
            <id>maven-releases</id>
            <url>http://localhost:8081/repository/maven-releases/</url>
        </repository>
    </distributionManagement>
```

Remember our dockerized Nexus repository is running on localhost at port 8081. Nexus comes pre-configured with the maven-snapshots and maven-releases repositories.

The **IDs** *maven-snapshots* and *maven-releases* must match the server sections in the **[settings.xml file](https://github.com/devops4me/maven-3.6.0-jdk-11)**.


### 3. Run the Maven 3 Library Build and Deploy

```
cd <</path/to/project/root>>
docker run --interactive --tty --rm \
    --name vm.maven \
    --network host \
    --volume $PWD:/root/codebase \
    devops4me/maven:3.6.0-jdk-11 \
    mvn clean deploy
```

This is where it all happens. Your POM is used via the /root/codebase volume mapping. The **[settings.xml file](https://github.com/devops4me/maven-3.6.0-jdk-11)** contains the username/password sections that match the configurations you made above.


---


## Use Maven to Build a Microservice that Depends on your library

How do we build a microservice or another library that depends on the above **`com.yourcompany:commons-library:1.0.1`** library?

There is very little extra to do if we want our microservices or other libraries to build using a custom dependency. Just add the typical dependency declaration like this.

```
<dependency>
    <groupId>commons-library</groupId>
    <artifactId>commons-library</artifactId>
    <version>1.0.1</version>
</dependency>
```

Also remember that
- a microservice does not need the distribution management section
- a custom library does need the distribution management section


### Maven Goals | Microservices vs Libraries

The **maven goal** for building a microservice is **`package`** rather than **`deploy`** because the artifact is going into a Docker image rather than an artifact repository like Nexus.

```
cd <</path/to/project/root>>
docker run --interactive --tty --rm \
    --name vm.maven \
    --network host \
    --volume $PWD:/root/codebase \
    devops4me/maven:3.6.0-jdk-11 \
    mvn clean package
```


## Appendix - the Magic Maven settings.xml file

Most of **the magic happens in the settings.xml file** and you need not do anything as it is already built into the **devops4me/maven** docker image. This image is used above to build and deploy from the command line and it is also used in the Jenkinsfile.


The 3 key sections are 

- the **servers** that allow authentication for the maven deploy plugin to push artifacts into the Nexus repository
- the **mirrors** that help microservices find custom JARs first in the release repository and if not - maven central
- the **profiles** that define the repositories from which projects can collect custom artifacts

```
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                      https://maven.apache.org/xsd/settings-1.0.0.xsd">

    <servers>
        <server>
            <id>maven-snapshots</id>
            <username>admin</username>
            <password>p455w0rd</password>
        </server>
        <server>
            <id>maven-releases</id>
            <username>admin</username>
            <password>p455w0rd</password>
        </server>
    </servers>

    <mirrors>
    
        <mirror>
            <id>maven-releases</id>
            <name>maven releases</name>
            <url>http://localhost:8081/repository/maven-releases/</url>
            <mirrorOf>maven-releases</mirrorOf>
        </mirror>    
 
        <mirror>
            <id>maven-central</id>
            <name>maven central</name>
            <url>http://localhost:8081/repository/maven-central/</url>
            <mirrorOf>*</mirrorOf>
        </mirror>    
 
    </mirrors>
  
    <profiles>
        <profile>
            <id>nexus-setup</id>
            <repositories>
                <repository>
                    <id>maven-releases</id>
                    <name>Maven Releases Repository</name>
                    <url>http://localhost:8081/repository/maven-releases/</url>
                </repository>
            </repositories>
        </profile>
    </profiles>

    <activeProfiles>
        <activeProfile>nexus-setup</activeProfile>
    </activeProfiles>
  
</settings>
```
