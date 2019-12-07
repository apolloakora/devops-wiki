# How to Install Terraform | Ubuntu

Installing **HashiCorp's Terraform** on Ubuntu (Linux) requires that you , unpack it and then put the command on the path.

+ **download** a zip file of Terraform's last stable release
+ **unpack** the zip file into a folder on the path (/usr/local/bin)
+ give users **execute permissions** to the terraform binary

First though, how can your script check whether Terraform is installed.

![terraform logo](/media/terraform-logo-rectangle.png "HashiCorp Terraform Logo")

## Is Terraform Installed?

Checking whether Terraform is already installed can be done with the below lines is bash.

``` bash
response=`terraform --version > /dev/null 2>&1`
if [ "$?" = "0" ]; then
   echo "@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@"
   echo "@@@ Terraform is already installed.                     @@@@"
   echo "@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@"
fi
```

If the **<code>terraform --version</code>** command returns a zero code - we know it is installed. You can add more code to check to see if an upgrade is required.

## Terraform Zip File Url | Linux (and Ubuntu)

The **current terraform version** is ***0.12.5*** and acquiring the Linux 64bit zip file is done using the below url.

```
https://releases.hashicorp.com/terraform/0.12.5/terraform_0.12.5_linux_amd64.zip
```

## Install Terraform on Linux

These are the commands to download, unpack and set execute permissions.

``` bash
curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.12.5/terraform_0.12.5_linux_amd64.zip
sudo unzip /tmp/terraform.zip -d /usr/local/bin
sudo chmod a+x /usr/local/bin/terraform
rm /tmp/terraform.zip
terraform --version
```

The `terraform --version` asserts that Terraform is installed - the command returns a zero exit code.
