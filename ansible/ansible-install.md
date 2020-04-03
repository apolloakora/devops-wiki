
# Install Ansible | Ubuntu | Mac | AWS | Azure


``` bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
```

## Installing Ansible for Azure | MacBook

Ansible makes you productive when automating infrastructure provisioning and configuration management in Azure.

On the Mac (with Homebrew) simply install ansible with

```
brew install ansible
ansible --version
brew install python3
pip3 -V
python3 --version
sudo pip3 install 'ansible[azure]'
```

## Azure Register App and Export Credentials

Go to the **[Azure Portal](https://portal.azure.com)** and on the left click on Active Directory, App registrations then select the app.

| Environment Variable | Azure Portal Name | Description of Text |
|:-------------------- |:----------------- |:--------------------------------------- |
| AZURE_SUBSCRIPTION_ID | Display Name | The name you selected for your application. |
| AZURE_CLIENT_ID |  | Application (Client) Id | Long hyphenated hexadecimal string |
| AZURE_TENANT | Directory (Tenant) ID | Long hyphenated hexadecimal string |
| AZURE_SECRET | (see below) | String containing lower, upper and punctuation chars. |

### How to Acquire an Azure Secret

To acquire a secret against your application registration you

- click on **`Certificates and Secrets`**
- click on **`New Client Secret`**
- enter a description and add the secret
- copy the secrets value and paste

At the terminal export these Azure credentials.

```
export AZURE_SUBSCRIPTION_ID=<your-subscription_id>
export AZURE_CLIENT_ID=<security-principal-appid>
export AZURE_SECRET=<security-principal-password>
export AZURE_TENANT=<security-principal-tenant>
```

If you use a safe to store credentials you can export them like this.

```
safe open microsoft account
export AZURE_SUBSCRIPTION_ID=`safe print azure.subscription.id`
export AZURE_CLIENT_ID=`safe print azure.client.id`
export AZURE_SECRET=`safe print @azure.secret`
export AZURE_TENANT=`safe print azure.tenant`
printenv
```
