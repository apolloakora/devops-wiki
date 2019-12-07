
# Install Docker on Ubuntu 18.04 and Above

It pays to put your user into the docker group to avoid prefixing every docker command with sudo.

```bash
sudo apt install --assume-yes docker.io
docker --version
sudo systemctl status docker
sudo usermod -aG docker ${USER}
id -nG   # confirm that user is added to docker group
```

You can't use the repository technique and likely you will see the below error when adding the repository at `https://download.docker.com/linux/ubuntu`

<pre>
The repository 'http://ppa.launchpad.net/banshee-team/ppa/ubuntu bionic Release' does not have a Release file.
</pre>


## install docker on ubuntu 16.04 and 17.10

Avoid installing docker from the Ubuntu repository as it will be probably be outdated due to Docker's fast growing codebase.

```
sudo apt-get update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get --assume-yes install docker-ce
docker --version
sudo systemctl status docker
```
