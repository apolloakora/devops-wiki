
# How to Add a Java Microservice to the CI Pipeline

We've created our CI pipeline with Jenkins, SonarQube and a Docker Registry. Now we need some blood to flush through the pipeline. That blood in this instance is a Java Microservice.

Below is a great template for a JAVA microservice that goes inside the root of the project's directory structure (within a Git repository).

It assumes a SonarQube installation exists with the ID **`sonarqube-service`** and it creates a docker image that is dynamically tagged using the **Jenkins Job Name** and the 7 characters of the **Git Commit Reference**.

An improved solution would not hardcode the registry url location.

```
pipeline
{
    agent
    {
        docker { image 'maven:3.6.0-jdk-11' }
    }
    stages
    {
        stage( "Unit Tests" )
        {
            steps
            {
                sh 'mvn clean test'
            }
        }
        stage( "Static Code Analysis" )
        {
            steps
            {
                withSonarQubeEnv( 'sonarqube-service' )
                {
                    sh 'mvn clean package sonar:sonar'
                }
            }
        }
        stage( "Wait 4 Quality Judgement" )
        {
            steps
            {
                timeout( time: 2, unit: 'MINUTES' )
                {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage( "Push to Docker Registry" )
        {
            steps
            {
                script
                {
                    docker.withRegistry('http://<<hardcoded-ip-address>>:5000')
                    {
                        def customImage = docker.build( "${env.JOB_NAME}:1.0.${env.BUILD_ID}-${env.GIT_COMMIT.take(7)}" )
                        customImage.push()
                        customImage.push( 'latest' )
                    }
                }
            }
        }
    }
}
```

The JAVA microservice also requires a Dockerfile to create the image that the runtime container will be instantiated from. Here is a Dockerfile that uses a don't call us we'll call you embedded tomcat to handle calls to the microservice.

```
FROM maven:3.6.0-jdk-11
RUN mkdir -p /code
ADD . /code/
WORKDIR /code/
RUN mvn clean install
EXPOSE 6080
ENTRYPOINT [ "java", "-jar", "/code/target/banking-0.0.1-SNAPSHOT.jar" ]
```

Note that the "banking" reference needs to be changed.


## Adding the Microservice CI Pipeline Job to Jenkins

Some teams will choose to do this in an automated fashion using the branch source plugin to scan a Github repository and load up all the projects whose names (and branch names) meet certain patterns and that have a Jenkinsfile to define the pipeline.

To manually add the microservice you

- go to Jenkins
- click on New Item
- enter the name (without spaces as the docker image tag will be constituted from this name)
- select pipeline and click okay

At this point you can re-use one you've done before which is so much faster.

Otherwise you configure the pipeline job by

- entering a brief description
- select Discard Old Builds and choose 7 days and 7 builds
- select **Do not allow concurrent builds**
- select "Poll SCM" - and enter * * * * * for the CRON schedule
- select Pipeline Script from SCM
- select Git
- enter the git repository url
- if there are no credentials for the repository ADD the credentials
- use git credentials username and password - then enter an ID like gitlab-creds and a description like "Gitlab Jenkins Credentials
- untick the lightweight checkout

Once saved your job is created.

## Test the Job

Test the job by clicking on **Build Now**. To see the detailed logs you click on the date and then click on "Console Output" and troubleshoot.



## Troubleshooting

