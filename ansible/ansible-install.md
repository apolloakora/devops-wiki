
# Install Ansible on Ubuntu and Mac

Ansible makes you productive when automating infrastructure provisioning and configuration management tasks on multiple target machines.


## Install Ansible on Ubuntu

On an Ubuntu machine run these commands to bring Ansible to the table.

``` bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
ansible --version
```


## Install Ansible on a Mac

On the Mac (with Homebrew) simply install ansible with

```
brew install ansible
ansible --version
```


## Installing Ansible for Azure | Ubuntu

On an Ubuntu machine with both python3 and pip3 present you run these commands to bring Ansible and Azure to the table.

``` bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
ansible --version
pip3 -V
python3 --version
sudo pip3 install 'ansible[azure]'
pip3 install pywinrm
```

Now we have to install the Azure CLI. This is how.

```
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```


## Installing Ansible for Azure | MacBook

Ansible makes you productive when automating infrastructure provisioning and configuration management in Azure. On the Mac (with Homebrew) simply install ansible with

```
brew install ansible
ansible --version
brew install python3
pip3 -V
python3 --version
sudo pip3 install 'ansible[azure]'
pip3 install pywinrm
brew update && brew install azure-cli
```

#### Error | objc[15130]: +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called.

This error occurs due to a change within some python libraries. To fix it export this environment variable.

```
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
```



To install the Azure CLI on a mac

```
brew update && brew install azure-cli
```

## Prepare for az login without browser popup

The az login with browser popup is more than trying - if you ssh into another machine you won't have the ability to click on the popped up browser window. This is how to get round this.

- **`az login`** at the command line
- the result tells you the user name, the subscription ID and the tenant ID.


1.Login to Azure.

2.Use az ad sp create-for-rbac to create the service principal.

az ad sp create-for-rbac --name leapapp --password "le4pStr0ngP455W@rd"

Example

az ad sp create-for-rbac --name shuiexample --password "Password012!!" 

You could get result like below:

{
  "appId": "bca24913-026d-4020-b9f1-add600bf9045",
  "displayName": "shuiexample1234",
  "name": "http://shuiexample1234",
  "password": "*******",
  "tenant": "*******"
}

3.Sign in using the service principal using the following:

$appID="bca24913-026d-4020-b9f1-add600bf9045"
$password="******"
$tenant="*******"
az login --service-principal -u $appID --password $password --tenant $tenant


