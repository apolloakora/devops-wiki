
# Vagrant Command List

There aren't many Vagrant commands because Hashicorp design their products with the ***do one thing well*** philosophy.

**[[Click here to Install Vagrant|install vagrant virtualbox ubuntu]]**

[[_TOC_]]


![vagrant logo](/media/vagrant-logo-horizontal.png "HashiCorp Vagrant Logo")

## Create default Vagrantfile

```
vagrant init
```

**<code>vagrant init</code> is like <code>git init</code> and <code>terraform init</code>**.

It creates and deposits a Vagrantfile into the folder. Once there you can use <code>vagrant up</code> to start up your new basic virtual machine.


## Crate a Virtual Machine

```
vagrant up
```

The rubber hits the road with this command. A virtual machine is created via a hypervisor like **Oracle's VirtualBox**.

### VAGRANT_CWD | Running from Another Folder

You (or your script) can issue <code>vagrant up</code> **from a folder** without (or even with) a Vagrantfile. All you need do is to set the VAGRANT_CWD environment variable with an absolute path to the folder containing the Vagrantfile.

***<code>export VAGRANT_CWD=$HOME/path/to/vm_folder</code>***

*Remember the path is to the folder - not the file.*


## Tell Me the SSH Details

```
vagrant ssh-config
```

If you want to know **which port** was used, where the ***ssh private key*** is, what the user is called - you turn to **<code>vagrant ssh-config</code>**

The results will look like this.

<pre>
Host default
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile "/home/apollo/eco-platform.cluster/.vagrant/machines/default/virtualbox/private_key"
  IdentitiesOnly yes
  LogLevel FATAL
</pre>

### The VM / Host Shared Folder

You will use the **mapped shared folder** between the virtual machine and the host, again and again.
From the virtual machine it is mounted at **/vagrant**.

### The Private Key to Access Virtual Machine

If you want to enter the virtual machine from another computer where <code>vagrant ssh</code> is not n option, you'll need the host/ip address, user and private key.

The private key lives off the shared folder at this location.

> **.vagrant/machines/default/virtualbox/private_key**


## List All Vagrant Boxes

```
vagrant global-status
```

<pre>
id       name    provider   state   directory
---
0403361  default virtualbox running C:/Users/apollo/.../box1
8c8397a  default virtualbox running C:/Users/apollo/.../box2
</pre>

The ID is fed into other commands when you are not in the ***Vagrantfile*** directory.


## Destroy a Vagrant Box

```
vagrant destroy
```

Use vagrant destroy when you are in the same directory as the ***Vagrantfile*** for the box.

```
vagrant global-status
vagrant destroy 0403361
vagrant destroy -f 8c8397a
```

The *Are You Sure* prompt will rear itself when destroying the first box. The ***-f*** switch means "force" and is best used in scripts.


## Prune the List of Vagrant Boxes

```
vagrant global-status --prune
```

The box status list can get stale (after a restart for example). The simplest way to deal with this is to issue the ***vagrant global-status --prune*** command.


## Destroy All Vagrant Boxes
```
vagrant global-status --prune
vagrant destroy ec6edf4 4a20a79 14ec14b 974d0a6 043e058 --force
```

You can script getting the box IDs into a list from the `vagrant global-status` command.
Add the ***--force*** switch to disable the "Are you sure?" prompt.


## Print the current Vagrant version.

```
vagrant --version
```
