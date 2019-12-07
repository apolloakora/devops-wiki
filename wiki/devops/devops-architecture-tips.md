
# 21 Devops Architecture Tips

Many mistakes are made early on when designing and building infrastructure and these mistakes become harder and harder to refactor and overcome as people scale, microservices scale, requests scale, environments, AWS accounts and request volumes scale. The dream of an automated, scaleable and highly redundant infrastructure gives way to a manual, difficult to change and buggy reality.

### Adopt Just 5

You don't have to learn the hard way thanks to this compilation of 21 simple devops practices. Aim to adopt just 5 - and you'll quickly reap the rewards. After that - you'll come back for more, mark my words.

### The 21 Do's and Don'ts of Devops

Each tip belongs either to CI/CD Pipelines, Infrastructure Provisioning, ToolChains and finally Monitoring and Logging.

1. [Dockerize your Jenkins pipleline]
1. [Separate Continuous Integration (CI) from Continuous Deployment (CD)]
1. [Pipelines End in 3 Places]
1. [5 things everyone hardcodes in Terraform, but shouldn't]



## terraform modules | each to its own

Advice &raquo; **Treat terraform modules like nano-services. Each module does one small thing and has its own git project.**

It is commonplace to see all terraform code in one Github project with lots of code inside a directory called **`modules`**. As the codebase grows, you'll realize that this is the equiavalent of a software monolith.

### Why is it a monolith?

Terraform code in one github project (with a modules directory) is a monolith because
- another project cannot reuse those modules - the monolith keeps reuse posibilities at bay
- module versioning is impossible - any module changes affect every environment
- without module versioning you cannot upgrade modules and declare changes as patch, minor or major
- upgrading from terraform 0.11 to 0.12 say is high risk and everything must be upgraded at once


## Use off-the-shelf docker images

**All docker images extend another image**. This is a truism unless you are in the business of building operating systems. Try as hard as you can to use available official images (as-is).

To collate container logs use the fluentd logger image as is. Use the sonarqube community image as is. Try to use the Hashicorp terraform docker image to manage your infrastructure. Use the cucumber image to run your rubygem/python wheel tests.


## Do not embed (large) docker images in other projects

Separate docker projects from the things that will use the docker containers. So avoid having Dockerfiles within other projects because that prevents reuse. The mother project is keeping reuse posibilities at bay.

**Be balanced** - if you must embed Dockerfiles keep them as small as possible. Put the majority of lines (layers) in its own docker project and then use FROM to extend and add your own little bit. This action enables reuse of the Docker image.


When you extract and free your Dockerfiles, you can then semantically version them so that different parts of your infrastructure can reuse them. Pin the use of container versions so that you can evolve your Docker image without all the reuse consumers swallowing risk at the same time.


## Use Names to make Docker Project Types Explicit

When each docker project is in its own Git project you'll find that you have broadly 3 types of docker image (container).

| Image/Container Type     | Container Description          | Visibility           | Naming Convention    |
|:------------------------ |:------------------------------ |:---------------------------------:|: ---------- |
| devops service container | a service container will run within your cloud infrastructure providing a service | Public  | docker-service-sonar, docker-service-jenkins, docker-service-fluentd |
| pipeline worker container | workload containers do work within your pipeline and once finished they are discarded | Public | docker-work-terraform, docker-work-cucumber |
| microservice container | custom application microservice containers are executed by cluster managers (Kubernetes, ECS) | Private  | app-service-login, app-service-payment |

If you must extend the behaviour of an existing docker image, decide whether it is a **service container** or a use and discard pipeline worker container. Then name the git project like **`docker-service-*`** or **`docker-worker-*`**.


### **Optional** - Separate Simple and Complex Pipelines

You can apply the **easy things easy, hard things possible** mantra by separating pipelines that result in docker images. 

**Let Dockerhub build simple images** that do not need unit tests, quality checks and so on. With web-hooks Dockerhub will monitor Github repositories and build
- infrastructure service images like extensions of fluentd, sonar and jenkins itself
- pipeline worker images like a terraform runtime or a test bench

