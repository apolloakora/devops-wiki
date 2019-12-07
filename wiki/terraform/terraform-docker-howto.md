
# How to Run Terraform in Docker

### terraform docker use cases

A number of use cases lend themselves well to running terraform inside a docker container. These include

- running projects in Terraform 0.12 when your laptop has Terraform 0.11 installed
- multiple infrastructures with state managed in different docker volumes
- dockerizing terraform so that Jenkins can run it without polluting it with Terraform binaries
- delivering to a colleague (a terraform codebase) has a higher chance of working than guessing what is in their environment
- Terraform local_exec may demand python, curl etc on the host environment - docker is perfect for this
- using docker volumes (and maybe volume drivers) to manage Terraform state if you don't want to use S3 or Dynamo DB

## Terraform Docker Example | Creating VPCs in AWS

Our example will use a simple **[terraform module in github that creates VPCs](https://github.com/devops4me/terraform-aws-vpc-network)**.



### Step 1 | git clone into docker volume

First we create a docker volume (called **`vol.tfstate`**) and add the terraform module code to it by way of an **alpine git** container.

```
docker volume create vol.tfstate
docker run --interactive \
           --tty         \
	   --rm          \
	   --volume vol.tfstate:/terraform-work \
	   alpine/git \
	   clone https://github.com/devops4me/terraform-aws-vpc-network /terraform-work
sudo ls -lah /var/lib/docker/volumes/vol.tfstate/_data
```

When you list the files in the container you will see the terraform module's contents there.



### Step 2 | terraform init via docker

As our volume contains the terraform module code from git we are now ready to perform a terraform init. We use the **[devops4me/terraform container](https://cloud.docker.com/repository/docker/devops4me/terraform/general)** container which adds a VOLUME mapping to the **[hashicorp/terraform](https://hub.docker.com/r/hashicorp/terraform/)** container at the **`/terraform-work`** location.

**example** - there is a working [example directory](https://github.com/devops4me/terraform-aws-vpc-network/tree/master/example) in the git terraform module that demonstrates module use and is used by continuous integration actors.

```
docker run --interactive \
           --tty \
	   --rm \
	   --name vm.terraform \
	   --volume vol.tfstate:/terraform-work \
	   devops4me/terraform init example
sudo ls -lah /var/lib/docker/volumes/vol.tfstate/_data
```

The directory listing **verifies** that our volume now contains a **`.terraform`** directory.



### Step 3 | terraform apply via docker

At last we can run the terraform apply. Provide a **role arn** only if your organization works with roles alongside the other 3 AWS authentication keys.

```
docker run --interactive \
           --tty \
	   --rm \
	   --name vm.terraform \
	   --env AWS_DEFAULT_REGION=<<aws-region-key>> \
	   --env AWS_ACCESS_KEY_ID=<<aws-access-key>> \
	   --env AWS_SECRET_ACCESS_KEY=<<aws-secret-key>> \
	   --env TF_VAR_in_role_arn=<<aws-role-arn>> \
	   --volume vol.tfstate:/terraform-work \
	   devops4me/terraform apply -auto-approve example
sudo ls -lah /var/lib/docker/volumes/vol.tfstate/_data
```

Examining the **docker volume** should reveal a **tfstate file** which documents the state of your infrastructure just after the terraform apply execution.


<blockquote>
The benefits of running terraform in a docker container with docker volumes really start to reveal themselves at this stage.

You can create another infrastructure simply by using another docker volume. Your host environment need not even have terraform installed. You can git clone different branches and commits. You can use different terraform versions to build the infrastructure.
</blockquote>


### Step 4 | terraform destroy via docker

After running plan and apply either once or multiple times you may feel the need to **`terraform destroy`** the infrastructure.

```
docker run --interactive \
           --tty \
	   --rm \
	   --name vm.terraform \
	   --env AWS_DEFAULT_REGION=<<aws-region-key>> \
	   --env AWS_ACCESS_KEY_ID=<<aws-access-key>> \
	   --env AWS_SECRET_ACCESS_KEY=<<aws-secret-key>> \
	   --env TF_VAR_in_role_arn=<<aws-role-arn>> \
	   --volume vol.tfstate:/terraform-work \
	   devops4me/terraform destroy -auto-approve example
sudo ls -lah /var/lib/docker/volumes/vol.tfstate/_data
```

Verify the destroy from your AWS console and also check that your volume now has a **tfstate backup file** created by terraform.
