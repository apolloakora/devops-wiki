
# How to Configure AWS Credentials

To use the ***programmatic IAM user*** you must configure the IAM ***access key id*, the ***secret access key*** and the *region*. Refer to ***create iam user*** to understand how to create the user, attach policies directly or align the user to a group.

<img id="right50" src="/media/aws-logo-50.png" title="AWS Amazon Web Services Logo" />
You then store the two IAM user access credentials user Unix Pass, KeePass, KeePassX or LastPass (for use below).


## 4 Ways to Configure AWS Credentials

You can configure AWS credentials

- by using assume-role to get **temporary credentials**
- through environment variables
- via an INI formatted ***credentials file***
- using software like JAVA, Ruby, Python etc


## 1. How to Provision Temporary Credentials

We can provision temporary AWS security credentials for a set duration of up to 12 hours, or up to the maximum set by a role (if one is being used), whichever is the smaller. But  why?

### An AWS Temporary Credentials Use Case

During development we may want to pass credentials into a docker container to test its interaction with AWS resources. The intention may be to run the container on an EC2 server with instance profiles set.

### Using the safe

Using safedb.net is an extremely secure (low-friction) method because all credentials are encrypted at rest. You open the safe book and turn to the chapter and verse with the long standing IAM user credentials and Role Arn if applicable.

You then ask the safe to **create a new verse** that is a clone of the present one. The key difference is that the new verse will contain the security credentials.

### Provision AWS Temporary Credentials Steps

The pre-condition here is that we have a role that is configured within the **`~/.aws`** folder. AWS allows a maximum of 12 hours for temporary credentials but the role can override this configuration.

| Time Period | Duration      |
|:----------- |:------------- |
|  1 hour     |  3600 seconds |
|  4 hours    | 14400 seconds |
|  6 hours    | 21600 seconds |
| 12 hours    | 43200 seconds |

```
aws sts assume-role \
    --role-arn <<role-arn>> \
    --role-session-name <<use-case>> \
    --profile <<profile-name>> \
    --duration-seconds 3600
```

A JSON data structure is returned by default. Use the data encapsulated within it to export these **four (4)** temporary security credentials.

```
$ export AWS_ACCESS_KEY_ID=<<access.key>>
$ export AWS_SECRET_ACCESS_KEY=<<secret.key>>
$ export AWS_SESSION_TOKEN=<<session.token>>
$ export AWS_DEFAULT_REGION=<<region.key>>
```

Don't be puzzled if everything grinds to a halt when the time duration is up.


## 2. Environment Variables | AWS Credentials

***Environment variables*** work well inside single purpose (lightweight) Docker containers. These variables can be set by **Kubernetes** or via the **<code>docker run</code>** command.

### Windows 10

You can use ***setx*** to permanently set the environment variables. Unfortunately to delete them you will need the ***reg delete*** command.

### Windows 7

Use the blog on setting environment variables using Powershell. Again, deletion requires ***reg delete***.

### Ubuntu 16.04

To permanently set the environment variables you need to export them and then append the key-value pairs to the ***/etc/environment*** file.
Alternatively - you can append to dot profile so that the variables are exported each time a login occurs. A vagrant inline script can achieve this.


### Delete Windows Environment Variable

You need to ***delete*** your **AWS Environment Variables** if moving to an **AWS Credentials file**.
In Windows you achieve this through the REG delete commmand (note - there is no setx delete command).

```batch
REG delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /F /V FOOBAR
```


## 3. INI (Policy) File | AWS Credentials

A development or test ***workstation*** should use the credentials file because different use cases tend to use different IAM users.

The credential INI file will have ***many sections*** - each section configures a user. Within the SDK a ***profile name*** can be specified for the AWS Seahorse software to select the required user.

```ini
[default]

aws_access_key_id = AKIAABC123
aws_secret_access_key = iTAbc123
region = eu-west-1

[s3.reader]

aws_access_key_id = AKIAABC456
aws_secret_access_key = iTAbc456
region = eu-west-1
```


### Linux &raquo; Ubuntu, Centos, CoreOS, RHEL | AWS Credentials File

Create a folder named ***.aws*** inside the user's home directory be it /home/apollo or /var/lib/jenkins or /var/opt/gitlab.

Within the .aws folder create a file named **credentials** (with no extension).


### Windows AWS Credentials File

In Windows the AWS credentials file has a different name and it ***does not*** live in a .aws folder. You

- name the file ***.awscredentials*** (not credentials).
- place file in folder defined by the <code>USERPROFILE</code> environment variable.

Aside from that the content formatting is the same as it is in Linux.




## Inline Software | AWS Credentials

The Aws.config command within Ruby v2 is formatted like the below.

```ruby
    Aws.use_bundled_cert!
    Aws.config.update({
      region: 'eu-west-1',
      credentials: Aws::Credentials.new('AKIAABC123', 'iTAbc123')
    })
```

Inline configuration is the least portable and risks getting the credentials checked into your Git repository. Don't forget to set the **AWS region** as well as the access IDs.


