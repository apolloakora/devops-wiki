

# Use Ansible to Install Kubernetes on Vagrant VMs

Tired of paying through the nose for a cloud kubernetes cluster like AKS, EKS and GKS. You could provision using the **kops** framework but that is costly too. Visit the **[ubuntu microkubernetes (microk8s install blog](microk8s-install)** to see how to use snap to install a mini kubernetes cluster.

To learn the real thing however and have a local cluster there is no better method than using Vagrant, Virtualbox and Ansible to provision the infrastructure and configure the kubernetes cluster itself.

We can easily install a Kubernetes cluster on the Mac using Vagrant and Ansible.

**[Visit the Documentation Here (March 2019](https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/)**


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


## Create the Ubuntu Machines | 1 Kubernetes Master and 2 Workers

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


---


## Create and Validate the Ansible Inventory

To create the Ansible inventory the steps are

- run **`vagrant ssh-config`** to list the ports and the paths to the ssh private keys
- create the section inside the **`~/.ssh/config**` file (see below)
- verify you can ssh into the machines with **`vagrant ssh master`** and similar for the workers
- verify you can ssh with **`ssh vagrant@kubemaster`** and similar for the workers
- create the Ansible inventory **`hosts.ini`** file
- validate the inventory with **`ansible -m ping all -i hosts.ini`**


### The SSH Config File

Put this section inside the **`~/.ssh/config**` file to help Ansible configure the kubernetes cluster machines.

```
Host kubemaster
HostName 127.0.0.1
User vagrant
Port <master_port>
IdentityFile </path/to/master/private/key>
StrictHostKeyChecking no

Host kubeworker1
HostName 127.0.0.1
User vagrant
Port <worker1_port>
IdentityFile </path/to/worker1/private/key>
StrictHostKeyChecking no

Host kubeworker2
HostName 127.0.0.1
User vagrant
Port <worker2_port>
IdentityFile </path/to/worker2/private/key>
StrictHostKeyChecking no
```

### The Ansislbe Inventory (Hosts) File

Create this inventory (hosts) file. The **`ansible_host`** refers to the **`Host`** variable inside the **`~/.ssh/config`** file.

```
master ansible_host=kubemaster
worker ansible_host=kubeworker1
worker ansible_host=kubeworker2
```

Now validate the inventory with **`ansible -m ping all -i hosts.ini`**.


---


## Create the Ansible Playbooks that provision Kubernetes

There are 3 key playbooks that will provision the kubernetes cluster. The steps to creating them are

- create the Ansible dependencies.yml file
- create the Ansible cluster **`kubemaster.yml`** file
- create the Ansible cluster **`kubeworker.yml`** file


### The Ansible dependencies.yml playbook

The dependencies playbook installs necessary software on the masters and workers and also ensures that swapfiles are removed.

```
- hosts: all
  become: yes
  tasks:

  - name: install Aptitude
    apt:
      name: aptitude
      state: present
      update_cache: true

  - name: install Docker
    apt:
      name: docker.io
      state: present
      update_cache: false

  - name: Install Transport HTTPS
    apt:
      name: apt-transport-https
      state: present

  - name: install kubelet
    apt:
      name: kubelet
      state: present
      update_cache: false

  - name: install kubeadm
    apt:
      name: kubeadm
      state: present

  - name: Remove swapfile from /etc/fstab
    mount:
      name: "{{ item }}"
      fstype: swap
      state: absent
    with_items:
      - swap
      - none

  - name: Disable swap
    command: swapoff -a
    when: ansible_swaptotal_mb > 0

  - name: add Kubernetes apt-key
    apt_key:
      url: "https://packages.cloud.google.com/apt/doc/apt-key.gpg"
      state: present

  - name: add Kubernetes' APT repository
    apt_repository:
      repo: deb http://apt.kubernetes.io/ kubernetes-xenial main
      state: present
      filename: 'kubernetes'

- hosts: master
  become: yes
  tasks:

  - name: install kubectl
    apt:
      name: kubectl
      state: present
      force: yes
```

You can validate the dependencies using **`ansible-playbook -i hosts.ini dependencies.yml`**

### The Ansible kubemaster.yml playbook

This playbook provisions the kubernetes master nodes and sets up the pod network.

```
- hosts: master
  become: yes
  tasks:

    - name: Add the "kube" group
      group:
        name: kube
        state: present

    - name: Add the user "kube"
      user:
        name: kube
        comment: Kubernetes user
        group: kube

    - name: initialize the cluster
      shell: kubeadm init --pod-network-cidr=10.99.0.0/16 >> cluster_init.txt
      args:
        chdir: $HOME
        creates: cluster_init.txt

    - name: create .kube directory
      become: yes
      become_user: kube
      file:
        path: $HOME/.kube
        state: directory
        mode: 0755

    - name: copy admin.conf to user's kube config
      copy:
        src: /etc/kubernetes/admin.conf
        dest: /home/kube/.kube/config
        remote_src: yes
        owner: kube

    - name: install Pod network
      become: yes
      become_user: kube
      shell: kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml >> pod_network_setup.txt
      args:
        chdir: $HOME
        creates: pod_network_setup.txt
```

You can validate the master provisioning playbook using **`ansible-playbook -i hosts.ini kubemaster.yml`**

### Create the Kubernetes workers playbook

The kubernetes workers playbook is mainly focused on getting the worker to join the cluster by taking the join command from one (master) and giving it to the worker in question.

```
- hosts: master
  become: yes
  gather_facts: false

  tasks:
    - name: get join command
      become_user: kube
      shell: kubeadm token create --print-join-command --description "Generated by Ansible"
      register: generated_join_command

    - name: grab join command
      set_fact:
        join_command: "{{ generated_join_command.stdout_lines[0] }}"

- hosts: worker
  become: yes
  tasks:

    - name: join cluster
      shell: "{{ hostvars['master'].join_command }} >> node_join.txt"
      args:
        chdir: $HOME
        creates: node_join.txt
```

You can validate the worker joining playbook using **`ansible-playbook -i hosts.ini kubeworker.yml`**


---


## Accessing the Kubernetes Cluster

To access the cluster properly you should export the **`~/.kube/config`** file from the master onto your host laptop which needs to have kubectl installed. Now **`kubectl get nodes`** should return something sensible.

Initially to access the cluster you
- ssh into the master **`vagrant ssh master`**
- become the kube user **`sudo su kube`**
- run **`kubectl get nodes`**

Now your cluster is ready for lots of learning, validating and provisioning in a local setting without the hefty cloud fees.


## Kubernetes Cluster Internet Resources

This is the only resource that works out of the box with one **`vagrant up`** command. However there are still some great references pages where authors have built kubernetes clusters with Ansible and Vagrant.

- **[Create Kubernetes Cluster from IT WonderLab](https://www.itwonderlab.com/ansible-kubernetes-vagrant-tutorial/)**
- **[Install Calico Networking for On-Premise Deployments](https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/onpremises)**
- **[Kubernetes Vagrant and Ansible Github Repo](https://github.com/ctienshi/kubernetes-ansible/tree/master/centos)**
- **[Ansible Official User Guide](https://docs.ansible.com/ansible/latest/user_guide/index.html)**
- **[Installing Kubernetes on Docker](https://www.howtoforge.com/tutorial/how-to-install-kubernetes-on-ubuntu/)**
- **[Out of Date Kubernetes Guide using Ubuntu 16.04](https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/)**
- **[Medium Kubernetes Cluster with Vagrant and Ansible](https://medium.com/@MonadicT/create-a-kubernetes-cluster-with-vagrant-and-ansible-88af7948a1fc)**
- **[Using Ansible to Create a Kubernetes Virtual Lab](https://graspingtech.com/create-kubernetes-cluster/)**
- **[Create a Kubernetes Cluster on Vagrant using Ansible](https://jeremievallee.com/2017/01/31/kubernetes-with-vagrant-ansible-kubeadm.html)**
- **[Create a Standalone Kubernetes Cluster with Vagrant](https://nextbreakpoint.com/posts/article-create-standalone-kubernetes-cluster-with-vagrant.html)**
