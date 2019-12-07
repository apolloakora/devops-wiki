
# Install Gitlab Using Docker

Installing Gitlab using the docker image alongside docker volumes and volume drivers is the preferred method. Other options are a bare metal install, using Ansible and installation into a Kubernetes cluster using Helm  charts.

## Prepare the Gitlab Persistence Volume

Clearly we want Gitlab's state to **survive not only the death of its container, but also the death of the host VM** (virtual machine). We would ideally employ docker managed volumes and a volume driver that can speak to the long term state provider, however - we are choosing for expediency to use host-managed volumes.

If we are setting up Gitlab for the first time we need to map the volume to an area such as **`~/runtime/gitlab`**

```
mkdir -p runtime/gitlab/config
mkdir -p runtime/gitlab/logs
mkdir -p runtime/gitlab/data
```

### Migrating Gitlab's Data

If you already have data to migrate then this should find its way from a USB stick to a volume that is then mapped using docker's **`--volume`** switch.

### Taking a Backup of Gitlab's Data

To recursively zip up a directory and then unzip it somewhere else here is the command set.

```
sudo apt install --assume-yes zip gzip tar
cd <<folder-containing-folder-to-zip>>
zip -r <<name-of-package>>.zip <<folder-to-zip>>
unzip <<name-of-package>>.zip
```

Note that Gitlab likes to write files to disk as root and this causes problems when copying to external media. To workaround this issue we can stage the directory tree elsewhere and then change its owner.

```
mkdir ziptime
cd ziptime/
sudo cp -R ~/runtime/* .
sudo chown -R $USER:$USER *
```

## Gitlab Port Bindings

Gitlab requires 4 ports to be published.

1. port 443 for accessing secure traffic
1. port 80 - for politely telling the requesting agent to use port 443
1. port 22 - for pushing to the repositories using SSH public/private keypairs
1. a port for the Gitlab REST API which is out of scope of this documentation

## Gitlab Configuration

The most important config option is the ability to send emails. Gitlab needs to send emails to invite users to login and change their passwords. Achieving this is done via configuration in **`/etc/gitlab/gitlab.rb`** and the steps are to

- add the configuration to gitlab.rb
- log into the container with **`docker exec -it vm.gitlab /bin/bash`**
- issue the command **`gitlab-ctl reconfigure`**

### GMail Configuration

```
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.gmail.com"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_user_name'] = "xxxxxxxxxxxxxxxxxxxxxxxx@gmail.com"
gitlab_rails['smtp_password'] = "XXXXxxxxXXXXXxxxxXXXXXxxxxxx"
gitlab_rails['smtp_domain'] = "smtp.gmail.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = false
gitlab_rails['smtp_openssl_verify_mode'] = 'peer'
```

### Setting the External Url in Gitlab's Configuration File

This line needs to be set in the **`/etc/gitlab/gitlab.rb`** configuration file when the access URL is known.

```
external_url "https://example.com/gitlab"
```

## Install Docker on the VM

We've chosen an Ubuntu VM and these are the run-once commands to install docker on it.

- **update the ubuntu packages** - **`sudo apt update`**
- **upgrade the ubuntu installation** - **`sudo apt upgrade`**
- **install docker** - **`sudo apt install -y docker.io`**
- **verify the docker installation** - **`docker --version`**


## Run the Gitlab Docker Image

Use **`docker ps -a`** to ensure nothing is binding to either port 80 or 22. Note that sudo is mandatory even when you can access docker without it. This is for permissions to access the protected ports below 1024.

```
cp YOUR_OWN_gitlab.rb /home/apollo/runtime/gitlab/config/gitlab.rb
docker run --detach \
    --publish 7443:443 \
    --publish 7080:80  \
    --publish 7022:22  \
    --name vm.gitlab   \
    --restart always   \
    --volume /home/apollo/runtime/gitlab/config:/etc/gitlab   \
    --volume /home/apollo/runtime/gitlab/logs:/var/log/gitlab \
    --volume /home/apollo/runtime/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
```

To troubleshoot the common **`bind: address already in use`** errors use these commands.

```
sudo apt install --assume-yes net-tools
sudo netstat -pna | grep 7022
sudo netstat -pna | grep 7080
```


## Login to Gitlab

Use the url setup within Gitlab's configuration to access the Gitlab login screen.
