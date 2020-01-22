
# Terraform with a Jenkins Docker Pipeline

You can manage Terraform infrastructure state with a **Jenkins Docker Pipeline acting as a build server** or you can continuously integrate Terraform software with Jenkins and truly treat your infrastructure as code.

Let's run Jenkins locally within a docker container and setup Jenkins 2 declarative pipeline jobs that take instructions from your project's Jenkinsfile and Dockerfile.

![Jenkins2 Pipeline in Operation](/media/terraform-in-jenkins-docker-pipeline.png "Terraform in a Jenkins Docker Pipeline")

There are options (other than a Jenkins pipeline) for managing Terraform's infrastructure state. These include Terraform Enterprise, Terragrunt and solutions using S3 buckets or a Hashicorpt Consul backend.

That said, it is hard to look past Jenkins2 pipelines if your team already has some Jenkins and Docker experience.


## Terraform Build Server vs Continuous Integration

The target is a Jenkins2 pipeline using dockerized Terrraform to build VPC's and subnets within AWS. If you desire **continuous integration** then a verification stage can be sandwiched in between the `terraform apply` and `terraform destroy`. Omit these stages if a **build server for managing infrastructure state** is required.

## Jenkinsfile Preview

This **declarative pipeline** reads better than scripted pipelines for much the same reasons that draw you towards Terraform's declarative style.

```
pipeline
{
    environment
    {
        AWS_ACCESS_KEY_ID     = credentials( 'safe.aws.access.key' )
        AWS_SECRET_ACCESS_KEY = credentials( 'safe.aws.secret.key' )
        AWS_REGION            = credentials( 'safe.aws.region.key' )
    }

    agent { dockerfile true }

    stages
    {
        stage('terraform init')
        {
            steps
            {
		sh 'terraform init integration.test.dir'
            }
        }
        stage('terraform apply')
        {
            steps
            {
		sh 'terraform apply -auto-approve integration.test.dir'
            }
        }
        stage('terraform destroy')
        {
            steps
            {
		sh 'terraform destroy -auto-approve integration.test.dir'
            }
        }
    }
}
```

<img id="right40" src="/media/jenkins-logo-square-butler.png" title="Jenkins2 with Declarative Pipelines" />

Do you notice **how generic this Jenkinsfile** is. It is from a **[Terraform module that builds VPCs and subnets](https://github.com/devops4me/terraform-aws-vpc-subnets)** but can apply to literally any Terraform codebase.

A lot goes on here assuming you've setup your AWS credentials within Jenkins (explained later). Jenkins expects a Dockerfile at the source of your project which it builds and then runs passing in the present environment variables.

The first stage runs a terraform init **from within the container** then an apply and finally a destroy.


## Terraform Dockerfile Preview

The Dockerfile employed uses an Ubuntu 18.04 base and installs git plus tools to get and install Terraform. Then it does just that. A current Jenkins bug is avoided by omiting an ENTRYPOINT.

```
FROM ubuntu:18.04
USER root

RUN apt-get update && apt-get --assume-yes install -qq -o=Dpkg::Use-Pty=0 \
      curl  \
      git   \
      tree  \
      unzip

RUN useradd --home /home/tester --create-home --shell /bin/bash --gid root tester

RUN \
    curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.11.9/terraform_0.11.9_linux_amd64.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin && \
    chmod a+x /usr/local/bin/terraform         && \
    rm /tmp/terraform.zip                      && \
    terraform --version

USER tester
WORKDIR /home/tester
```


## Jenkins Dockerfile | Plugins

The full **[Jenkins Dockerfile is here](https://github.com/devops4me/jenkins-cluster/blob/master/Dockerfile)** but this important extract details the plugins employed.

```
RUN /usr/local/bin/install-plugins.sh \
     git                   \
     git-client            \
     ssh-credentials       \
     workflow-aggregator   \
     build-pipeline-plugin \
     docker-workflow       \
     workflow-multibranch  \
     workflow-scm-step
```

The plugins of note here are the build-pipeline-plugin, docker-workflow and workflow-scm-step.

As shown below, all you need do is reference the image **[devops4me/jenkins2 in DockerHub](https://hub.docker.com/r/devops4me/jenkins2/)**.


## How to Build a Terraform Jenkins2 Docker Pipeline

This Jenkins2 pipeline is deployed on localhost but you can easily productionize it by adding authentication and (for the brave), Kubernetes managed Docker slaves that take up the slack without taxing the node that runs your Jenkins master.

## Step 1 | Run the Jenkins 2.1 Docker Container

    $ docker run --name=j2volume devops4me/j2volume:lts
    $ docker run --tty --privileged --detach \
          --volume       /var/run/docker.sock:/var/run/docker.sock \
          --volume       /usr/bin/docker:/usr/bin/docker \
          --volumes-from j2volume     \
          --publish      8080:8080    \
          --name         jenkins2     \
          devops4me/jenkins2:lts;

## Step 2 | Visit Jenkins on Localhost

Jenkins should now be running on http://localhost:8080 if step 1 was successful.


## Step 3 | Clone and Copy Jenkins Job Configuration

Use **git** to pull down the **[Jenkins2 configuration files](https://github.com/devops4me/docker-jenkins-cluster)** and then **docker copy** to place them into the Jenkins docker volume.

    $ git clone https://github.com/devops4me/docker-jenkins-cluster
    $ cd docker-jenkins-cluster
    $ tree
    $ docker cp jobs j2volume:/var/jenkins_home
    $ docker exec -i jenkins2 bash -c "ls -lah /var/jenkins_home/jobs"
    $ docker cp config.xml j2volume:/var/jenkins_home/
    $ curl -X POST http://localhost:8080/reload

It includes jobs that use Terraform to create AWS cloud infrastructure and then they destroy it. These are your typical infrastructure module integration testing Jenkins job type.

### Tree of Jenkins Job Configurations

├── rabbitmq-docker-image<br/>
│   ├── config.xml<br/>
│   └── nextBuildNumber<br/>
├── terraform-coreos-ami-id<br/>
│   ├── config.xml<br/>
│   └── nextBuildNumber<br/>
├── terraform-security-groups<br/>
│   ├── config.xml<br/>
│   └── nextBuildNumber<br/>
└── terraform-vpc-subnets<br/>
    ├── config.xml<br/>
    └── nextBuildNumber<br/>

## Diff of Jenkins Job config.xml

Note that the config.xml in the Terraform (VPC subnets, security groups and fetch CoreOS AMI ID) modules **only differ in three ways** namely

- their directory names (which become the Jenkins job ID)
- their human readable name (within config.xml)
- their Git repository URL

A Jenkinsfile and Dockerfile must exist at the source of their Git repositories. Note that these jobs are configured to

- run at 7am, 11am, 3pm, 7pm and 11pm
- poll the Git SCM repository every 2 minutes and trigger the build if the master branch changes


## Step 4 | Injecting Credentials into Jenkins

The **jobs have all promptly failed** is the prognosis when you visit http://localhost:8080 after the above curl relooad command. The RabbitMQ job needs DockerHub credentials and the **Terraform infrastructure integration tests need AWS cloud credentials**.


## Inject DockerHub Username and Password

The RabbitMQ job is configured to expect credentials with an ID of **dockerhub-credentials**. The DockerHub account username is **devops4me** and lets pretend the password is **password12345** - this would be the curl command you issue.

```bash
curl -X POST 'http://localhost:8080/credentials/store/system/domain/_/createCredentials' \
--data-urlencode 'json={
  "": "0",
  "credentials": {
    "scope": "GLOBAL",
    "id": "dockerhub-credentials",
    "username": "devops4me",
    "password": "password12345",
    "description": "docker login credentials to push built images to Docker registry",
    "$class": "com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl"
  }
}'
```

**If your Jenkins server is not at localhost:8080 do not forget to make the change in the first line above.**

## Inject AWS Cloud Credentials

The AWS Credentials spawn from **StringCredentialsImpl** which is a class apart from the DockerHub credentials that hail from **UsernamePasswordCredentialsImpl**. These are the credential identities that the Terraform jobs expect.

| Credential ID       | Environment Variable  | Description                     |
|:-------------------:|:--------------------- |:------------------------------- |
| safe.aws.access.key | AWS_ACCESS_KEY_ID     | The AWS access key credential.  |
| safe.aws.secret.key | AWS_SECRET_ACCESS_KEY | The AWS secret key credential.  |
| safe.aws.region.key | AWS_REGION            | The AWS region key credential.  |


Look inside their Jenkinsfile and you will see the **environment declaration** which will make the injected credentials available to the environments in each stage and subseequently will be placed into the docker containers via the docker run --env switch.

    environment
    {
        AWS_ACCESS_KEY_ID     = credentials( 'safe.aws.access.key' )
        AWS_SECRET_ACCESS_KEY = credentials( 'safe.aws.secret.key' )
        AWS_REGION            = credentials( 'safe.aws.region.key' )
    }

You must issue the curl command 3 times to inject each of the 3 credentials IDs and their corresponding values. Click on the Credentials item in the Jenkins main menu for some assurance.

```bash
curl -X POST 'http://localhost:8080/credentials/store/system/domain/_/createCredentials' \
--data-urlencode 'json={
  "": "0",
  "credentials": {
    "scope": "GLOBAL",
    "id": "safe.aws.access.key OR safe.aws.secret.key OR safe.aws.region.key",
    "secret": "REPLACE-ME-WITH-ACCESS-KEY-SECRET-KEY-OR-REGION-KEY-VALUE",
    "description": "One of the 3 AWS IAM user credentials",
    "$class": "org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl"
  }
}'
```

**Again - if your Jenkins server is not at localhost:8080 do not forget to make the change in the first line above.**

### Reload Jenkins Configuration

Now that the credentials are in we reload the configuration and click Build Now on the Jobs. They should work!

```bash
curl -X POST http://localhost:8080/reload
```


## Step 5 | A Stateful Terraform Build Server

It's easy to use Jenkins to hold Terraform's state - so any team member can click on "Build Now" and only changes in the master branch are effected be they creates, updates, destroys or a combination.

**Just delete the terraform destroy stage in the Jenkinsfile**.

Enjoy your **Jenkins 2.1 Declarative Docker Pipeline** that runs Terraform to represent your **infrastructure as code**.

Enjoy the stage user interface with the timings of each stage.

## Jenkins | Terraform | Resources

**[How to create a Jenkins Cluster in AWS](http://www.blog.labouardy.com/deploy-jenkins-cluster-aws/)**
