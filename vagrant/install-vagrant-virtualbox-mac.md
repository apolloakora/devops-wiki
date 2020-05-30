# How to Install Vagrant and VirtualBox on Mac OSX

<img id="right30" src="/media/virtualbox-logo-square.png" title="Oracle VirtualBox Logo" />
Installing **HashiCorp's Vagrant** and ***Oracle's VirtualBox*** hypervisor takes just 3 commands as long as

+ you are using Ubuntu (Client or Server)
+ the **virtualization flag** in the **BIOS** is set
+ you are not using SecureBoot (home partition encryption)


If the above does not apply - read the key issues section to prep before installing Vagrant and VirtualBox.

## Install Vagrant and VirtualBox on Mac

- go to the **[Vagrant downloads page](https://www.vagrantup.com/downloads.html)** and get Vagrant
- go to the **[VirtualBox downloads page](https://www.virtualbox.org/wiki/Downloads)** and get VirtualBox
- install first VirtualBox then install Vagrant

![vagrant logo](/media/vagrant-logo-horizontal.png "HashiCorp Vagrant Logo")

### Smoke Test the Vagrant and VirtualBox Install

Once done, sanity check the install by asking for the versions.

``` bash
vagrant --version
VBoxManage --version
```

The replies should be sensible.


#### **[[Visit Key Vagrant Command List for more.|vagrant commands]]**


---


## Create 3 Machines with this Vagrantfile

Create this **`Vagrantfile`** in the root of the repository and then run **`vagrant up`**.
On the Mac run **`VirtualBox`** and watch the machines listed on the dashboard.

```
# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Generic config

# OS/Box
VAGRANT_BOX = 'ubuntu/xenial64'
# VM User — 'vagrant' by default
VM_USER = 'vagrant'


# Master config params
VM_NAME_MASTER = 'evlab-master'
MASTER_ADDRESS = '192.168.56.50' ########## PLEASE CHANGE ME AS NEEDED
MASTER_HOSTNAME = "evlab-master.everlab.local"

# Worker config params
VM_NAME_WORKER ='evlab-worker'
WORKER_ADDRESS = '192.168.56.100' ########## PLEASE CHANGE ME AS NEEDED
WORKER_HOSTNAME = "evlab-worker.everlab.local"

# Worker1 config params
VM_NAME_WORKER1 ='evlab-worker1'
WORKER1_ADDRESS = '192.168.56.80' ########## PLEASE CHANGE ME AS NEEDED
WORKER1_HOSTNAME = "evlab-worker1.everlab.local"


Vagrant.configure(2) do |config|

  # Configuration definitions for the "Master" kube VM
  config.vm.define "master" do |master|

    # Configure box type
    master.vm.box = VAGRANT_BOX
    master.vm.hostname = MASTER_HOSTNAME

    # Configure the Network
    master.vm.network "private_network", ip: MASTER_ADDRESS

    master.vm.provider "virtualbox" do |v|
      v.name = VM_NAME_MASTER
      v.memory = 2048
    end

    # Script provisioner for Master
    $masterFirstBoot = <<-SCRIPT
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    apt update && apt install software-properties-common --yes
    apt install ansible --yes
    systemctl restart networking
    fallocate -l 256M /swapfile
	  chmod 600 /swapfile
	  mkswap /swapfile
	  swapon /swapfile
	  echo '/swapfile none swap defaults 0 0' >> /etc/fstab
    SCRIPT

    master.vm.provision "shell", inline: $masterFirstBoot
  end


  # Configuration definitions for the "Worker" kube VM
  config.vm.define "worker" do |worker|
    # Configure box type
    worker.vm.box = VAGRANT_BOX
    worker.vm.hostname = WORKER_HOSTNAME

    # Configure the Network
    worker.vm.network "private_network", ip: WORKER_ADDRESS

    worker.vm.provider "virtualbox" do |v|
      v.name = VM_NAME_WORKER
      v.memory = 1024
      worker.vm.synced_folder ".", "/vagrant", disabled: true
    end

    # Script provisioner for worker
    $scriptworker = <<-SCRIPT
    ping -c 10 ${masteraddress}
    systemctl restart networking
    SCRIPT

    worker.vm.provision "shell", inline: $scriptworker, env: {"masteraddress" => MASTER_ADDRESS},
      run: "always"
  end

  # Configuration definitions for the "Worker1" kube VM
  config.vm.define "worker1" do |worker1|
    # Configure box type
    worker1.vm.box = VAGRANT_BOX
    worker1.vm.hostname = WORKER1_HOSTNAME

    # Configure the Network
    worker1.vm.network "private_network", ip: WORKER1_ADDRESS

    worker1.vm.provider "virtualbox" do |v|
      v.name = VM_NAME_WORKER1
      v.memory = 1024
      worker1.vm.synced_folder ".", "/vagrant", disabled: true
    end

    # Script provisioner for worker1
    $scriptworker = <<-SCRIPT
    ping -c 10 ${masteraddress}
    systemctl restart networking
    SCRIPT

    worker1.vm.provision "shell", inline: $scriptworker, env: {"masteraddress" => MASTER_ADDRESS},
      run: "always"
  end

end
```
