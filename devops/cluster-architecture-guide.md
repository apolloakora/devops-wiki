
# Architecture | The 3 Layers of a Cluster

Use **ignition** to bootstrap and configure this ec2 instance cluster so that your infrastructure code **separates the following concerns**

- VPCs, subnets, security groups, routes and load balancers **to build the network**
- either a **fixed size** or auto-scaling modus operandi **to build the cluster**
- **systemd unit files** given to ignition **to build the node** with microservices

### Why separate the concerns I hear you ask?

The infrastructure that devops4me presents **delineates the network** configuration **from the clustering** mechanism, **from the node's dockerized microservices** configuration c/o the systemd unit files.

This separation of concerns enables you to

- reuse the **[network code](https://github.com/devops4me/terraform-aws-vpc-network)** in a serverless architecture like EKS, RDS or AWS Elasticsearch
- **reuse this ec2 clusterer** for **etcd clusters**, **rabbitmq clusters** or even **jenkins clusters**
- **reuse the systemd unit files** without being tied down to an instance type, storage size, AMI or even cloud!


## EDIT THE BELOW SECTION


# CoreOS Machine | AWS | Terraform | Cloud Init and UserData


This module uses Terraform to create a CoreOS machine in the AWS cloud that is configured by a cloud init yaml file.

## Important Software Quality Actions

To make the infrastructure code portable, resilient, secure and reusable we perform the following actions

- read the CoreOS AMI ID dynamically (see xxxx)
- manage dynamically reading and interpolating the etcd discovery url token
- safely injecting the public key without touching disks or git repository


## Securing the Public Key

Injecting the public key in a safe dynamic manner is necessary for infrastructure code that is portable, resilient, secure and reusable. The options are to

- use Terraform and Python to create the AWS keypair and inject in the public key or
- use a Terraform environment variable to inject the public key itself or
- use a Terraform environment variable to detail the location of the public key

Your credentials manager should be able to effect the former two options without either the public or private key touching any disk.

## Requirements

- decide on the cluster size and replace 3 below with your decision
- grab a discovery token using **`curl https://discovery.etcd.io/new?size=3`**
- place discovery token in cloud-config.yml `discovery: "https://discovery.etcd.io/<<discovery_token>>"`



