

# Ansible Commons



## Ansible Modules and Plugins

```
ansible-doc -t lookup -l                      # lookup list of installed plugins
ansible-doc -t <plugin_type> <plugin_name>    # is plugin type and plugin name installed
ansible-doc -t lookup azure_keyvault_secret   # is plugin type lookup and plugin name azure_keyvault_secret installed
```

### ansible-doc could not find module

When ansible doc couldn't find the azure_rm_keyvaultsecret module we used locate with a `.py` to find the directories of other common modules.
We then copied the module py file into the Library/Python ... location.

```
ansible-doc -t lookup -l
locate hashi_vault.py
sudo cp /Library/Python/3.7/site-packages/ansible/modules/cloud/azure/azure_rm_keyvaultsecret.py /Library/Python/3.7/site-packages/ansible/plugins/lookup/
ansible-doc -t lookup -l
```

Now ansible-doc finds the module.


