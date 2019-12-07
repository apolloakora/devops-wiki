
# Configure ELB Access Logs | Terraform

> Technologies Used Here : S3 Buckets, S3 Bucket Policy, ELB/ALB Load Balancers, Terraform
> Capability Delivered : For simple setups ELB can replace nginx within EC2 saving you money and time
> Problem : nginx and apache gave us access logs and error logs - can ELB do the same?
> Also Important : How to Setup an S3 Bucket, How to Setup an ELB

![terraform logo](/media/terraform-logo-rectangle.png "HashiCorp Terraform Logo")

## Terraform ELB Access Logs | Declaration

This snippet declares to Terraform (and AWS) that you want the load balancer to **write higly informative access logs** into an S3 bucket, at a location, **every 5 minutes**.

```hcl
resource "aws_elb" "bar" {

  name               = "elb-name"
  availability_zones = [ "eu-west-1a", "eu-west-1b" ]

  access_logs {
    bucket        = "<<s3-bucket-name>>"
    bucket_prefix = "<<some-prefix>>"
    interval      = 5
  }

  ... (omitted)
}
```

Understand that

- **`<<some-prefix>>`** is explained below
- **`<<s3-bucket-name>>`** is the simple text of the bucket name (not terraform names or IDs)
- interval means a file comes every 5 minutes with 5 minutes worth of access logs

For a high volume site it is worth getting 288 medium sized files a day using a 5 minute interval. Also while developing you don't want to wait 60 minutes! For mid volume sites a 60 minute interval gives 24 files a day whilst low volume sites could set a 144 minute interval to receive just 10 files daily.

| **Request Volumes** | **Interval** | File Number |
|:-------------------:|:------------:|:-----------:|
High Traffic | 5 minutes | 288 per day
Medium Traffic | 60 minutes | 24 per day
Low Traffic | 144 minutes | 10 per day

Note that the AWS console only allows 5 minutes or 60 minutes.

> The AWS documentation leaves to the imagination (or experimentation)
> the minimum and maximum intervals.
>
> There is no commitment that the files will arrive bang on time or
> even in the right order.

## Understand ARN for S3 Bucket

**Do not confuse `<<your-aws-account-id>>` and `<<load-balancer-account-id>>`**

```
arn:aws:s3:::<<s3-bucket-name>>/<<some-prefix>>/AWSLogs/<<your-aws-account-id>>/*
```

To understand the S3 bucket ARN, know that

 - it will go into your bucket (permissions) policy
 - you choose bucket name and bucket prefix `<<some-prefix>>` (mimics folders)
 - you **hardcode** the word AWSLogs
 - you insert your n digit <<your-aws-account-id>> (not the load balancer account ID)


## S3 Bucket Policy | Permissions for ELB to write Access Logs to S3 Bucket

The ARN above goes into the S3 bucket policy below.

Visit how to setup an S3 bucket policy because here we concentrate on **what goes into the policy** to enable the load balancer to write logs deep into your S3 bucket.

### The S3 Bucket Policy

```json
{
  "Id": "Policy1429136655940",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1429136633762",
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::<<s3-bucket-name>>/<<some-text>>/AWSLogs/<<your-aws-account-id>>/*",
      "Principal": {
        "AWS": [
          "<<load-balancer-account-id>>"
        ]
      }
    }
  ]
}
```

To understand the S3 bucket policy, know that

- you replace `<<load-balancer-account-id>>` using the table below
- in us-west-2 you use 797873946194 and 054676820928 in eu-central-1
- you hardcode the Id, Sid and Version
- PutObject is the only action needed
- the S3 bucket **folder the load balancer writes to** is always `<<some-text>>/AWSLogs/<<your-aws-account-id>>/*`

'''We know S3 buckets don't have folders!'''

## Load Balancer Account IDs

**Use the below table to find the above `<<load-balancer-account-id>>`.**

Load balancer account IDs depend on the AWS region. If you use the devopswiki module the translation is automatically built in.

| **Region** | **ELB Account ID** |
|:---------- |:------------------:|
us-east-1 | 127311923021
us-east-2 | 033677994240
us-west-1 | 027434742980
us-west-2 | 797873946194
ca-central-1 | 985666609251
eu-central-1 | 054676820928
eu-west-1 | 156460612806
eu-west-2 | 652711504416
eu-west-3 | 009996457667
ap-northeast-1 | 582318560864
ap-northeast-2 | 600734575887
ap-northeast-3 | 383597477331
ap-southeast-1 | 114774131450
ap-southeast-2 | 783225319266
ap-south-1 | 718504428378
sa-east-1 | 507241528517


## Real World ELB Access Logs

You can read this website's **real world** access logs over here.

### Real World S3 Bucket Policy

This is the real-life S3 bucket policy used to allow the load balancer to write access logs.

```json
{
  "Id": "Policy1429136655940",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1429136633762",
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::pot.devopswiki.access.logs/production/AWSLogs/12345678901/*",
      "Principal": {
        "AWS": [
          "156460612806"
        ]
      }
    }
  ]
}
```

### Real World Terraform ELB Snippet

```hcl
    access_logs
    {
        bucket        = "pot.devopswiki.access.logs"
        bucket_prefix = "production"
        interval      = 5
    }
```

This goes into the aws_elb terraform resource. It says deliver my access logs every 5 minutes please to this S3 bucket at the location (url) **production/AWSLogs/120725610885** that (in this case) the load balancer is configured to use.

## Terraform | Don't Hardcode AWS Account ID

Most terraformers hardcode their AWS account ID, region and availability zones.

**Don't give hackers a head start! Read the Howto.**

[[How to Avoid Hardcoding AWS Account ID and Region|terraform hardcode aws ids]]

