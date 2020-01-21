
# Avoid Hardcoding AWS Account Region and Availability Zone

Most terraformers hardcode their AWS account ID, region and availability zones. There is no need to add these even to configuration files as hackers get a headstart if you declare your account ID and other locators.

This hardcoding makes your software brittle and it fails once you deploy it to another region.

## AWS Account ID

     data "aws_caller_identity" "with" {}

This data source delivers the **AWS account ID** (digits) thereby absolving us of the need to hardcode it **even in configuration files**. Why give hackers a head start?

Now your Terraform software is less brittle and more portable.

    ${data.aws_caller_identity.with.account_id}

## AWS Region

This datasource gives us the AWS region we are currently operating in for example **eu-west-2** or **us-east-1**.

     data "aws_region" "with" {}

## AWS Availability Zones

```hcl
data "aws_availability_zones" "indexed" {}
```

This datasource provides the list of availability zones in the current region. It has only one attribute which is names.

Here are some useful interpolation examples.

     ${data.aws_availability_zones.indexed.0.name}     # name of the 1st availability zone
     ${data.aws_availability_zones.indexed.all.names}  # names of all availability zones
     ${data.data.aws_availability_zones.indexed.*.name}     # name of current zone in loop

## How to Avoid Hardcoding Ubuntu AMIs

Use the data source below to avoid hardcoding the Ubuntu AMI and then access it during instance creation like this.

    resource "aws_instance" "this"
    {
        ami           = "${data.aws_ami.ubuntu.id}"
    }

The below datasource provides the HVM AMI variety of Ubuntu 18.04 from Canonical.
You can also select EBS or instance store. It uses Canonical's AWS account ID which is 099720109477.

    data "aws_ami" "ubuntu"
    {
        most_recent = true

        filter
        {
            name   = "name"
            values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
        }

        filter
        {
            name   = "virtualization-type"
            values = [ "hvm" ]
        }

        owners = ["099720109477"]
    }

If you wanted Ubuntu 16.04 you would replace the end of the name filter value to be like this.

> ubuntu-xenial-16.04-amd64-server-*


## How to Avoid Hardcoding CoreOS AMIs

This curl gets the CoreOS Container Linux AMI Image ID on AWS.

     curl -s https://coreos.com/dist/aws/aws-stable.json | jq -r '."eu-west-2".hvm'

You can substitute three parameters into the above CUrl command. These are the

- **AWS region ID**
- **"green-ness"** of the image (**stable**, **beta** or **alpha**)
- [virtual machine type](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/virtualization_types.html) either **PV (paravirtual)** or **HVM (hardware virtual machine)**

To investigate further view the
- [Official CoreOS AWS AMI listings](https://coreos.com/os/docs/latest/booting-on-ec2.html)
- [JSON report for CoreOS AMIs based on AWS region](http://stable.release.core-os.net/amd64-usr/current/coreos_production_ami_all.json)


### Sample JSON of CoreOS AMI IDs by AWS Regions

    {
      "amis": [
        {
          "name": "ap-northeast-1",
          "pv": "ami-03620b047f1abddfc",
          "hvm": "ami-086eb64b7f4485a72"
        },
        {
          "name": "ap-northeast-2",
          "hvm": "ami-085e4381942bede7d"
        },
        {
          "name": "eu-west-2",
          "hvm": "ami-02de9d47add3bab7c"
        },
        {
          "name": "us-west-2",
          "pv": "ami-05da9819ce9ed9159",
          "hvm": "ami-02dea79d6a7f53d15"
        }
      ]
    }


