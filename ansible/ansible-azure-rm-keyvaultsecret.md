
# How to Use azure_rm_keyvaultsecret

When ansible doc couldn't find the azure_rm_keyvaultsecret module we used locate with a `.py` to find the directories of other common modules.
We then copied the module py file into the Library/Python ... location.

```
ansible-doc -t lookup -l
locate hashi_vault.py
sudo cp /Library/Python/3.7/site-packages/ansible/modules/cloud/azure/azure_rm_keyvaultsecret.py /Library/Python/3.7/site-packages/ansible/plugins/lookup/
ansible-doc -t lookup -l
```

Now ansible-doc finds the module.


- name: Look up secret when ansible host is MSI enabled Azure VM
  debug: msg="the value of this secret is {{lookup('azure_keyvault_secret','testSecret/version',vault_url='https://yourvault.vault.azure.net')}}"

- name: Look up secret when ansible host is general VM
  vars:
    url: 'https://yourvault.vault.azure.net'
    secretname: 'testSecret/version'
    client_id: '123456789'
    secret: 'abcdefg'
    tenant: 'uvwxyz'
  debug: msg="the value of this secret is {{lookup('azure_keyvault_secret',secretname,vault_url=url, cliend_id=client_id, secret=secret, tenant_id=tenant)}}"




```yaml
---

- hosts: localhost
  connection: local
  tasks:
    - name: Create a secret
      azure_rm_keyvaultsecret:
        secret_name: victorias_secret
        secret_value: apollos_p455w0rd
        keyvault_uri: https://vmadmin.vault.azure.net/

```