
# Infrastructure 3.0 Requirements

**This is about a scaleable, resilient, secure, responsive, extensible and reusable infrastructure from the top down.**

This is about what is required to build a high quality cloud stack with the top 6 Devops technologies namely **Terraform**, **Git**, **Docker**, **AWS**, **Kubernetes**, **Java** and **Jenkins** from the top down.

## Continuous Integration Pipeline Requirements

- Jenkins must be run within a docker (Kubernetes or ECS) cluster
- Jenkins must organically scale up and down as workloads fluctuate
- Adding microservices to Git should automatically add them to Jenkins
- Jenkins must dynamically assimilate its pipelines
- Aside from the cluster no special infrastructure should be provisioned to support Jenkins
- any Jenkins instances should be used either for Continuous Integration or Continuous Deployment but not both
- the Jenkins Blue Ocean interface should be used for dashboards


The same applies for SonarQube with the exception of optionally provisioning an external database to add persistence.


## Portal Dashboard for Infrastructure Views

A portal dashboard must be built as a one-stop shop for accessing the multitude of infrastructure views including
- the Jenkins Continuous Integration job views
- the SonarQube quality dashboard views
- the Prometheus/Grafana views on Kubernetes health
- the continuous deployment views
- textual log views from containers, VPC logs, database logs, SIEM (security) logs
- the log visualization views through tools like Grafana, Kibana and Splunk
- infrastructure monitoring views through tools like DataDog and New Relic


## Cleaning an AWS Account and then Terraforming it to support a set of Applications

When terraforming an AWS account to support applications the following tasks will likely need to happen.

- root user account setup (see AWS books on full list)
- user accounts setup with MFA
- IAM roles, groups and profiles are setup to carry access policies
- credentials provisioned along with ROLE ARN for automated API access
- credentials communicated to the appropriate places
- domain TLS Certificates provisioned and/or imported into the ACM (Certificate Manager)
- private keys are added to KMS (Key Management Store)
- Domain Names are added to Route53
- DNS and routing artifacts are added to CloudFront
- machine to machine certificates are provisioned
- required media files, images and electronic documents are added to S3
- conduits for logging and monitoring are setup
- secrets may be added to the SecretsManager

The **process should be generic** for any application and driven by a YAML/JSON configuration file. The process may be "married" with other on-premises and foreign cloud configurations including 

Once the above tasks are done the business of terraforming to create clusters and other infrastructure can begin.
