
# Gollum Wiki | Eco System


***Gollum*** - a ***Git backed wiki*** is powers both the DevOpsHub and the GitHub websites.

The ***Git back-end*** is the best bit - everyone can use their favourite text editor - rather than the clunky WordPress and MediaWiki browser interfaces.

## Gollum Wiki | Plus Points

The *Gollum* plus points when compared to **WordPress or MediaWiki** are

- no MySQL database to manage, backup, upgrade and migrate
- state of the art change tracking and auditing (c/o Git)
- a familiar Git workflow (pull requests, merges)
- lightweight ***markdown*** pages
- each team member can use their favourite text editor

Gollum is no gimmick - the essence is a small core which is extensible via an eco-system of familiar tools. You take only what you need to remain agile.


# Gollum Wiki | Eco System

Delivering your Wiki content requires you to provision infrastructure and employ an eco-system (hub) of technologies and tools. A Gollum Wiki core involves a mandatory set of technologies, some optional ones and then nice to haves.


## Gollum Wiki Core Technologies

To run Gollum Wiki in development, test or production requires a small eco-system of core technologies. These include

- a Ruby environment atop Ubuntu, CentOS, RHEL or CoreOS
- a Git Repository for backend file storage
- Ruby gems to provide gollum, markdown, web and other wiki servicees
- Wiki pages within the Git repo in markdown format
- Docker to build the Gollum container from the Gollum Dockerfile
- DockerHub, Amazon ECR or a private docker container registry


## Gollum Wiki In Production (Amazon EC2)

To create a Gollum Wiki production instance on an Amazon EC2 platform, you can use

- Terraform to provision the EC2 server, block store and security groups
- Terraform to provision Route53 hosted zone record sets
- nginx to reverse proxy the http/https web requests to the Gollum WebBrick server
- Certbot to provision SSL certificates that will last 3 months
- Disqus to provide comment functionality for your wiki blog pages
- S3 buckets to serve static/large media like pdf docs and images
- gollum gem for wiki internal links, breadcrumbs and elastic search integration
- PanDoc for offering a PDF version of the markdown/html page
- Fluentd for docker container logging and Kibana dashboard integration
- DataDog or other services for monitoring the Gollum Wiki service


## Gollum Wiki In Production (Kubernetes)

More and more DevOps engineers are turning to Kubernetes as their defact production platform.

In keeping with Google's Borg architecture - everything released is a container. A container is the smallest unit of deployment - not files, database SQL, nor scripts.

If deploying a Gollum Wiki to a Kubernetes platform the steps are to

- get the Gollum (production-ready) container into a registry like DockerHub or ECR
- add Kubernetes configuration for managing loads, service discovery and monitoring

