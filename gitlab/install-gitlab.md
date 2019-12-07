
# GitLab | Install a Production-Ready GitLab

This plugin installs a ***production-ready*** GitLab on a ***Terraform provisioned*** Amazon EC2 server. The result is a blank instance or a clone recovered from tar (or EBS) storage.

Tech Used : GitLab, Terraform, EC2, Ruby, Route53, Certbot, NginX

## GitLab Plugin Highlights

The gitlab.hub eco plugin will

- add Route53 domain ***record sets*** for HTTPS (SSL)
- provision and install SSL certificates using ***Certbot***
- ***clone*** a GitLab recovery file from an S3 bucket
- instigate periodic backups to s3 monitorable by Nagios

## GitLab - Get it Done

***Impatient?*** To install a production-ready instance of **GitLab on Amazon EC2** run these commands on your workstation.

```bash
git clone https://www.eco-platform.co.uk/commons/eco-platform.git mirror.platform
cd mirror.platform/iaas.cmd.provisioners
#
# 1. first eyeball the eco system facts 
# 2. next check the list of dependencies
# 3. then execute the ruby command below
#
ruby eco.do.rb create -w gitlab.production
```

These ***eco-system archetypes*** get you going with the minimum of fuss. As a DevOps engineer you quickly learn how technologies like Terraform, S3, Route53, Certbot and GitLab stack up.


## Production GitLab (Eco System Facts)

The list of eco-system facts.


## Production GitLab (Dependencies)

You must satisfy both the ***workstation and cloud dependencies***. If cloning from an S3 backup or EBS (elastic block) storage, the source and sink GitLab versions must match.

[[Go Back Home|home]]

