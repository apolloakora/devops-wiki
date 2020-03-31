
# Working with Azure Devops Cli

First we must install the Azure CLI and then add the Azure devops extension to it. After that we can log in.

## Setting up Azure Cli

On the MAC the setup steps are this.

```
brew update && brew install azure-cli
az --help
az extension add --name azure-devops
az extenion list
az devops -h
```

Listing the azure cli extensions should give you this at least.

``` json
[
  {
    "extensionType": "whl",
    "name": "azure-devops",
    "version": "0.17.0"
  }
]
```

Use this command to look into the details of the Azure CLI.

```
az extension show --name azure-devops
```

You can also now list the azure devops available commands with `az devops -h`

## The Azure Cli Login

The login command is simple.

```
az login
az devops configure --defaults organization=https://dev.azure.com/ahitapplicationteam project=MTT
```

It pops up a browser and you select the organization if you are logge in.


