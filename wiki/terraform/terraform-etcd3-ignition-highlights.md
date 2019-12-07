
# Key Points | etcd3 ec2 cluster with Terraform and Ignition

The noteworthy points of using **Terraform** and **Ignition** to create a **coreos etcd3 cluster** in the AWS cloud is covered here. Visit the **[steps to install an etcd3 cluster using Terraform and Ignition](terraform-etcd3-ignition-ec2-create)** atop EC2.

[[_TOC_]]


## Important Software Quality Actions

To make the infrastructure code portable, resilient, secure and reusable we perform the following actions

- read the CoreOS AMI ID dynamically (see xxxx)
- manage dynamically reading and interpolating the etcd discovery url token
- safely injecting the public key without touching disks or git repository


## etcd cluster discovery url token

- decide on the cluster size and replace 3 below with your decision
- grab a discovery token using **`curl https://discovery.etcd.io/new?size=3`**
- place discovery token in cloud-config.yml `discovery: "https://discovery.etcd.io/<<discovery_token>>"`
