
# CoreOs Cloud Init Howto

**On AWS EC2 machines where does CoreOS look to find the cloud-init files?**

| Installation Method | Cloud Init File Location | Comment        |
|:------------------- |:------------------------ |:-------------- |
Bare Metal | /var/lib/coreos-install/user_data | For manual CoreOS installs using the coreos-install tool.
Vagrant VirtualBox | /var/lib/coreos-vagrant/vagrantfile-user-data | Vagrant will automatically put cloud-config here
AWS EC2 and Digital Ocean | **`http://169.254.169.254/metadata/v1/user-data`** and/or **`http://169.254.169.254/2009-04-04/user-data`** | These URLs will link to the cloud-config scripts placeable by Terraform or Ansible
Manual Command (or Script) via SSH  | declared by **--from-file** parameter | Use this command $ sudo coreos-cloudinit --from-file=/path/to/cloud-config.yaml

## Login to CoreOS | AWS EC2

To develop and test your script it pays to execute it manually so that you can debug and tailor it.
**core** is the CoreOS user setup within the AMI and it can only be accessed via a private key - not password.

    ssh core@103.42.71.51 -i /path/to/private-key.pem
    sudo coreos-cloudinit --from-file=/path/to/cloud-config.yaml

## Find CoreOS AMI | AWS EC2

Find the CoreOS AMI for the region using the below curl command. Then use Dot (DevOps Task) and Terraform to create the instance, move the file over and kick off the cloud init.

    curl -s https://coreos.com/dist/aws/aws-stable.json | jq -r '."eu-west-2".hvm'





## Find CoreOS AMI | AWS EC2
