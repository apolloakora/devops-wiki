<!-- facts

[page]
authority = KMS, DynamoDb, python utility, credentials, security, aws credentials manager

[https://github.com/fugue/credstash]
#--
#-- Include link in source of pages discussing kms and/or dynamodb
#--
source = aws, kms, dynamodb

[https://blog.fugue.co/2015-04-21-aws-kms-secrets.html]
#--
#-- override internet page title with this one
#--
title = Use Aws KMS to Manage Secrets in your Infrastructure

[https://www.fpcomplete.com/blog/2017/08/credstash]

source = terraform, kms

[https://docs.ansible.com/ansible/devel/plugins/lookup/credstash.html]

source = terraform, ansible, aws, kms

-->

# Credstash | Credentials Management based on AWS Key Management Service

Credstash is a **little utlity that goes a long way** to helping you manage credentials and other sensitive information. Credstash is an up and coming (moderately mature) python utility with a meteoric adoption from early 2017 through to 2018. The concept has already been ported to Java, Ruby, Javascript and Go.

The utility is command line only and it stores the encrypted credentials in DynamoDb (for your AWS account).

## Credstash | EcoSystem

pip installs **credstash** giving you command line access to get and set credentials. The credstash eco-system is

- a pythonic environment (so Linux, Windows, MAC etc qualify)
- an AWS account with IAM user (programmatic access) with appropriate policies and roles.
- the AWS Key Management Service for storing (and rotating) root keys
- DynamoDb for storing and retrieving the encrypted materials

## Credstash | Example

The core credstash use cases are getting and setting credentials so on the command line you type

``` bash
credstash store mypc.address 192.168.2.47
credstash store mypc.username "Joe Bloggs"
credstash store mypc.private_key --file "/media/0144-3422/keys/mypc.private_key.pem"
rm /media/0144-3422/keys/mypc.private_key.pem
```

Note that you can retrieve the above credentials with an asterix like so mypc.*

Also it an store keys as well as passwords.

## Credstash | Install

The install steps are

- create an IAM user with KMS and DynamoDB access
- put the AWS credentials in environment variables or on the filesystem
- install the pip installer (if it is not already there).
- use pip to install credstash
- start putting and retrieving credentials


## Credstash | Script (Programmatic) Access

KeyPass is GUI only - credstash has had **command line** and **software api** in its blood from day one.

You can bring up EC2 servers with roles in place so the onboard scripts and software can access the AWS infrastructure it needs without exposing the credentials within the environment.

If you are writing programs in Java, Ruby or Go, you can import appropriate credstash API packages and then read/create credentials as necessary.
