
# How to Add a Dot Net (.NET / C# ) Microservice to the CI Pipeline

We've created our CI pipeline with Jenkins, SonarQube and a Docker Registry. Now we need some blood to flush through the pipeline. That blood in this instance is a Microsoft .NET (written in C#) Microservice.

The below template is for a .NET microservice and it sits at the root of the project's directory structure (within a Git repository).

### MSBuild SonarQube

The tasks to get MSBuild for a .NET project integrated inside Jenkins with SonarQube are to

- check with Jenkins / Manage Jenkins / Global Configuration for a SonarQube server setup with name **`sonarqube-service`**
- Create a SonarQube MSBuild installation
- create a SonarQube project key
- install the project key within Jenkins as described in the Jenkins pipeline setup blog.

It assumes a SonarQube installation exists with the ID **`sonarqube-service`** and it creates a docker image that is dynamically tagged using the **Jenkins Job Name** and the 7 characters of the **Git Commit Reference**.

An improved solution would not hardcode the registry url location.

```
pipeline
{
    agent any

    stages
    {
        stage('Build and Test .NET Code')
        {
            steps
            {
                echo 'Starting to build docker image'
                script
                {
                    def customImage = docker.build( "${env.JOB_NAME}:${env.BUILD_ID}" )
                }
            }
        }

        stage('SonarQube analysis')
        {
            steps
            {
                script
                {
                    scannerHome = tool 'sonarqube-msbuild'
                }

                withSonarQubeEnv('sonarqube-service')
                {
                    sh "${scannerHome}/sonar-scanner-4.1.0.1829/bin/sonar-scanner"
                }
            }

        }

        stage( "Push to Docker Registry" )
        {
            steps
            {
                script
                {
                    docker.withRegistry('http://172.27.78.33:5000')
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

The .NET microservice also requires a Dockerfile to create the image that the runtime container will be instantiated from. Here is a Dockerfile that does the build, executes xUnit tests and creates the docker image to be deployed to the registry.

```
FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0-buster AS build
WORKDIR /src
COPY ["<<project-name>>/<<project-name>>.csproj", "<<project-name>>/"]
COPY ["<<project-name>>Business/<<project-name>>Business.csproj", "<<project-name>>Business/"]
COPY ["<<project-name>>Repository/<<project-name>>Repository.csproj", "<<project-name>>Repository/"]
RUN dotnet restore "<<project-name>>/<<project-name>>.csproj"
COPY . .
WORKDIR "/src/<<project-name>>"
RUN dotnet build "<<project-name>>.csproj" -c Release -o /app/build
WORKDIR "/src/<<project-name>>Test"
RUN dotnet test

FROM build AS publish
WORKDIR "/src/<<project-name>>"
RUN dotnet publish "<<project-name>>.csproj" -c Release -o /app/publish
RUN dir

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "<<project-name>>.dll"]
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

You know that it has run all the way through when the docker registry reports a new tag with the current job name and build number attached.

