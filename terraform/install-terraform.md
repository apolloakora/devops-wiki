# How to Install Terraform | Ubuntu | Mac | Windows


## How to Install Terraform on Mac (OSx)

On the mac we use Homebrew to install terraform.

```
brew install terraform
```


---



## How to Install Terraform on Ubuntu (Linux)

Installing **HashiCorp's Terraform** on Ubuntu (Linux) requires that you , unpack it and then put the command on the path.

+ **download** a zip file of Terraform's last stable release
+ **unpack** the zip file into a folder on the path (/usr/local/bin)
+ give users **execute permissions** to the terraform binary

First though, how can your script check whether Terraform is installed.

![terraform logo](/media/terraform-logo-rectangle.png "HashiCorp Terraform Logo")

### Step 1 | Is Terraform Installed?

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

### Step 2 | Download the Terraform Zip

The **current terraform version** is ***0.12.5*** and acquiring the Linux 64bit zip file is done using the below url.

```
https://releases.hashicorp.com/terraform/0.12.5/terraform_0.12.5_linux_amd64.zip
```

### Step 3 | Commands to Install Terraform

These are the commands to download, unpack and set execute permissions.

``` bash
curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.12.5/terraform_0.12.5_linux_amd64.zip
sudo unzip /tmp/terraform.zip -d /usr/local/bin
sudo chmod a+x /usr/local/bin/terraform
rm /tmp/terraform.zip
terraform --version
```

The `terraform --version` asserts that Terraform is installed - the command returns a zero exit code.


---



## How to Install Terraform on Windows

Installing Terraform on Windows is simple if you have **Chocolatey** installed.

```
choco install terraform
```

Windows now has an impressive DevOps tool suite including Docker, Kubectl, Terraform, Chef, Puppet and Helm. Only a stable Ansible implementation is missing from this Windows Devops Toolkit.



---



## tfenv | Install Terraform Environment Manager

Like rbenv, pyenv and pipenv, tfenv makes the terraform version equal to the version inside the **`.terraform-version`** file.

You can install tfenv with **`homebrew`** on MacOSx or **`apt`** on Ubuntu.

```
tfenv install          # install the version within .terraform-version
tfenv install 0.12.24  # install this specific version
```
