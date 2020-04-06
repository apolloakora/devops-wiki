Also visit

- **[how to install ansible](ansible-install)**
- **[the Official Azure CLI Guide](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)**


# Setting up Azure Credentials

#### Failed to get credentials. Either pass as parameters, set environment variables, define a profile in ~/.azure/credentials, or log in with Azure CLI az login.

To allow the Azure CLI, or Terraform or Ansible to communicate with the Azure REST APIs we need to setup credentials either temporarily through environment variables or more permanently via the **`~/.azure/credentials`** file.

Achieving this means finding the values of these 4 key credentials.

| Environment Variable | Azure Portal Name | Description of Text |
|:-------------------- |:----------------- |:--------------------------------------- |
| AZURE_SUBSCRIPTION_ID | Display Name | The name you selected for your application. |
| AZURE_CLIENT_ID |  | Application (Client) Id | Long hyphenated hexadecimal string |
| AZURE_TENANT | Directory (Tenant) ID | Long hyphenated hexadecimal string |
| AZURE_SECRET | (see below) | String containing lower, upper and punctuation chars. |


## Azure Register App and Export Credentials

So this is how we acquire the four azure credentials.

- go to the **[Azure Portal](https://portal.azure.com)**
- click on Active Directory and check that `App registrations` is set to yes
- go back home and click on **`Active Directory`** then **`App registrations`** then **`New registration`**
- enter a name for the application and **`Register`**
- copy the **`Application (Client) Id`**
- click on **`Certificates and Secrets`** and select **`New Client Secret`**
- set the description and set the secret to expire in a year
- once the secret is created copy it to the clipboard and paste
- go to **`Home`** **`Subscriptions`** then select the **`Subscription`** and copy the Subscription ID
- still with the **`Subscription`** select **`Access Control (IAM)`**
- **`Add a Role Assignment`** - select **`Owner`** for total control - select user by name then click **`Save`**

- maybe goto **`Active Directory`** then **`Properties`** and say yes to **`Access Management for Azure Resources`** then **`Save`**





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
