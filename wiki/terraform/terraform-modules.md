### Terraform Module Hello World

    # In a new directory put this snippet into a file hello-world.tf
    # Check your AWS credentials are in ~/.aws/credentials (or exported)
    #
    #   $ export AWS_DEFAULT_REGION=us-east-1
    #   $ terraform init
    #   $ terraform apply -auto-approve
    #
    # Run terraform init and apply from the directory with hello-world.tf
    # Log into your AWS console to view your new VPC
    #
    # Notice a private and public subnet in every availability zone.

    module vpc_subnets
    {
        source = "github.com/devops-ip/terraform.modules/vpc.subnets"
    }

# High Quality Terraform Modules

This repository holds a fleet of high quality open source **terraform modules** that

- are **versioned** and **well documented**
- are plug and playable with sensible defaults
- keep **easy things easy** and **make hard things possible**
- increase productivity and the capability to automate infrastructure genesis
- **abstract away many of Terraform's foibles**

You are assured compatibility with your Terraform version because modules track Terraform's major and minor versions. For example **0.11.42** is tested against every Terraform **0.11.?** release.

## Terraform Modules List

| Module | Purpose | Stable Version |
|:-------- |:---- |:-------:|
**[vpc.subnets](vpc.subnets)** | Creates a VPC, creates subnets across availability zones in a round robin manner. | v0.11.0001

## Create VPC and Subnets in Availability Zones

This declaration **create 3 public subnets**, one in each availability zone. You can create 6 or even 7 subnets and it will distribute them (as) evenly (as possible) across availability zones.

    locals
    {
        our_ecosystem_id = "eks-cluster"
        our_vpc_cidr     = "10.191.0.0/16"
        our_subnet_cidrs = [ "10.191.0.4/24", "10.191.1.4/24", "10.191.2.4/24" ]
    }

    module vpc_subnets
    {
        source                  = "github.com/devops-ip/terraform.modules/vpc.subnets"
        in_vpc_cidr             = "${ local.our_vpc_cidr }"
        in_public_subnet_cidrs  = "${ local.our_subnet_cidrs }"
        in_private_subnet_cidrs = [ ]
        in_ecosystem_id         = "${ local.our_ecosystem_id }"
    }

If one or more public subnets are specified it creates an internet gateway and a route. This feature can be switched off.

## Modules at a Glance

    ├── ecosystem
    │   └── ecosys.instance-main.tf
    ├── README.md
    └── vpc.subnets
        ├── README.md
        ├── vpc.subnets-main.tf
        └── vpc.subnets-vars.tf

