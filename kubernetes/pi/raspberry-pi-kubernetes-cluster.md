
# How to build a Raspberry Pi Kubernetes Cluster

This tutorial gives step-by-step instructions on building a Kubernetes cluster with 4 or 8 Raspberry Pis. It includes amazon links to all the hardware you'll need.

Why do you need a Raspberry Pi cluster. Clouds are expensive


## 1. Equipment List

1. a **[52pi Raspberry Pi Rack Case with 4 Slots](https://www.amazon.co.uk/gp/product/B07J9VMNBL/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1)** - **[or 8 slots](https://www.amazon.co.uk/gp/product/B085ZZV66P/ref=ox_sc_act_title_1?smid=A187Y4UVM6ZA0X&psc=1)**
1. **[Raspberry Pi 4 Model B with 4GB of RAM](https://www.amazon.co.uk/gp/product/B07TC2BK1X/ref=ppx_yo_dt_b_asin_title_o03_s01?ie=UTF8&psc=1)** (either x4 or x8)
1. **[128 GB SanDisk Extreme Pro SD Card](https://www.amazon.co.uk/SanDisk-Extreme-microSDXC-Adapter-Performance/dp/B07G3H5RBT/ref=sr_1_3?crid=4MJLDBM9IVLL&dchild=1&keywords=extreme+pro+micro+sd&qid=1614018535&sprefix=extreme+pro+mi%2Caps%2C168&sr=8-3)** (either x4 or x8)
1. **[Micro HDMI to HDMI Cable](https://www.amazon.co.uk/gp/product/B08DY45G2D/ref=ox_sc_act_title_1?smid=A1ED6JEOF71PSI&psc=1)** - two recommended
1. **[NetGear 8-Port Gigabit Ethernet Switch](https://www.amazon.co.uk/gp/product/B017LWQIZA/ref=ox_sc_act_title_4?smid=A3P5ROKL5A1OLE&psc=1)**
1. **[short 0.5m ethernet cable](https://www.amazon.co.uk/gp/product/B07YTXCTY5/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1)** from Pi to Ethernet Switch (either x2 or x3)
1. **[medium to long ethernet cable](https://www.amazon.co.uk/gp/product/B0843SBMDD/ref=ppx_yo_dt_b_asin_title_o04_s00?ie=UTF8&psc=1)**  to connect the Ethernet Hub to your ISP's Hub

For the Official USB-C Power Supply for Raspberry Pi 4 you'll need to get 4 or 8 of the

1. **[UK Power Supply](https://www.amazon.co.uk/gp/product/B07VKF1CK8/ref=ox_sc_act_title_1?smid=A2717MKXZVZ1ZW&psc=1)**
1. **[EU Power Supply](https://www.amazon.co.uk/gp/product/B07TZ89BT7/ref=ppx_yo_dt_b_asin_title_o03_s00?ie=UTF8&psc=1)**

You will also need a **Laptop with a SD Card** slot.


## 2. Install Ubuntu Server on the SD Card

Use this **[Ubuntu tutoriall to write Ubuntu Server on the SD card](https://ubuntu.com/tutorials/how-to-sdcard-ubuntu-server-raspberry-pi#1-overview)**.

- take the SD card out - put it in the bigger case and slot it in
- download RPI imager from Raspberry Pi
- select the lastest **64 bit Ubuntu Server Operating System**
- select the SD card list and image it
- now place the little SD card into a Raspberry Pi and repeat


## 3. Build the Raspberry Pi Rack

This **[official YouTube video](https://www.youtube.com/watch?v=Fq2NmbZIl9c&t=364s)** takes you throught the steps to build the Raspberry Pi rack.


## 4. Connect the Raspberry Pi

With the SD card in the first Raspberry Pi it is time to wire it up. The steps are

1. connect the micro HDMI to a monitor
1. connect the a keyboard to the USB slot
1. put a short ethernet cable between Pi and Ethernet Hub
1. connect Ethernet Hub to ISP's Hub (only once)
1. connect Pi to power supply


## 5. Initial Raspberry Pi Ubuntu Configuration

When the Pi comes on login with username - **`ubuntu`** and password - **`ubuntu`** then change the password. Then proceed to

1. **`sudo apt update`** - update the list of package repositories
1. **`sudo dpkg --configure -a`** - get the package manager ready
1. **`sudo apt upgrade --asssume-yes`** - upgrade the system packages
1. check SSH server is running - **`sudo systemctl status ssh`**
1. **`ip a`** - record the IP address of this pi

## 6. SSH in to Finish Initial Raspberry Pi Configuration

Go to the terminal of your Linux/Mac laptop and ssh in like this.

**`ssh ubuntu@<IP-Address>`**

Enter your password and you are in. Complete the configuration with these steps.

## 7. Set Passwordless Sudo

After these commands you won't need to type the password every time you run a command with sudo. To achieve this we modify the user and then assume root rather than just using sudo.

```bash
sudo usermod -a -G sudo $USER
sudo su root
cd; pwd;
echo $SUDO_USER
sudo echo "$SUDO_USER ALL=NOPASSWD: ALL" >> /etc/sudoers
```

Now you need to exit and then pull up a new terminal.


## 8. Configure the Kernel for Kubernetes

Kubernetes is quite specific with what it need to manage resources on a Linux machine. We need to append these settings to a file called **`/boot/firmware/cmdline.txt`** and its one of those *one line files*.

The settings are

- cgroup_enable=cpuset
- cgroup_enable=memory
- cgroup_memory=1
- swapaccount=1

Use this command **`cat /boot/firmware/cmdline.txt`** to examine the one line file content. Then append the extra settings with this **sed** command.

```
sudo sed -i \
  '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1/' \
  /boot/firmware/cmdline.txt
```

Check the appendage and the space separation and then use **`sudo shutdown -r now`** to reboot the raspberry pi.

### Verification with `docker info`

Once docker is installed run **`docker info`** and if this step has not been done you will see these lines.

```
WARNING: No memory limit support
WARNING: No swap limit support
WARNING: No kernel memory limit support
WARNING: No kernel memory TCP limit support
WARNING: No oom kill disable support
```


## 9. Change Raspberry Pi Hostname

A network with 8 machines called **`ubuntu`** is disconcerting! Set the hostname to uniquely identify the rack and the position in the rack where **1 is high** and **4 is low**.

<blockquote>
pi-r1d1 is the hostname of the top machine in rack one<br/>
pi-r2d8 the eighth (bottom) machine in the second rack
</blockquote>

1. **`sudo apt install emacs --assume-yes`** - install emacs editor
1. **`hostnamectl`** - report the current hostname and machine ID
1. **`sudo hostnamectl set-hostname pi-r1d1`** - change the hostname
1. **`sudo emacs /etc/hosts`** - edit the `/etc/hosts` file
1. add this **`127.0.0.1 pi-r1d1`** as the second line

### If this machine is master
If this machine is going to be the master - add the IP address/hostname mappings for all the other raspberry pis.

### If this machine is a worker
For worker machines we only need to add the IP address/hostname mapping for the master.

Put the mapping/s to access the master raspberry pi (or all the worker pis) right under your new 127.0.0.1 entry.

### Edit the cloud configuration

Now edit the cloud configuration file and shutdown the machine

1. **`sudo emacs /etc/cloud/cloud.cfg`** - edit the cloud config
1. `preserve_hostname: true` - change flag from false to true
1. **`sudo shutdown -r now`** - reboot the raspberry pi

Now on your laptop add a mapping in **`/etc/hosts`** linking the pi's IP address and its new hostname. This method doesn't scale - if you run more than 5 or 6 machines you should consider setting up a dedicated DNS server on one of your Raspberry Pis.

Test connectivity with **`ping -c 4 pi-r1d1`**


## 10. Setup SSH Public/Private Keypair

**Ansible** the configuration management tool will be used to setup our Kubernetes cluster. Ansible requires a private key and needs our Raspberry Pi machines to have the corresponding authorized public key.

Use **`ssh-keygen`** or **`safe keygen`** to produce your keypair.

1. **`ssh ubuntu@pi-r1d1`** - ssh in with password
1. **`echo "<public key text>" >> ~/.ssh/authorized_keys`** - add public key
1. **`cat ~/.ssh/authorized_keys`** - assert public key in authorized_keys
1. **`exit`** - exit the ssh session

Finally we place the private key equivalent inside the .ssh folder and connect **securely without a password**.

1. **`safe write private.key --folder=~/.ssh`** - write the private key into **`~/.ssh`**
1. **`ssh ubuntu@pi-r1d1 -i ~/.ssh/services.cluster.pi-r1d1.pem`** - ssh in securely


## 11. Setup Simple and Secure SSH Access

For humans and Ansible to **simply ssh into each Raspberry Pi** you need the following sections within the ssh config file found at **`~/.ssh/config`** on your Linux laptop (or the Raspberry Pi that Ansible will run from).

```
## ###################################### ##
## Rack 1 Raspberry Pi Kubernetes Cluster ##
## -------------------------------------- ##
## ###################################### ##

Host master
  HostName pi-r1d1
  User ubuntu
  IdentityFile ~/.ssh/services.cluster.pi-r1d1.pem
  StrictHostKeyChecking no

Host worker1
  HostName pi-r1d2
  User ubuntu
  IdentityFile ~/.ssh/services.cluster.pi-r1d2.pem
  StrictHostKeyChecking no

Host worker2
  HostName pi-r1d3
  User ubuntu
  IdentityFile ~/.ssh/services.cluster.pi-r1d3.pem
  StrictHostKeyChecking no

Host worker3
  HostName pi-r1d4
  User ubuntu
  IdentityFile ~/.ssh/services.cluster.pi-r1d4.pem
  StrictHostKeyChecking no
```

For a 4 Raspberry Pi cluster the above inside **`~/.ssh/config`** should be good enough. Test host and ssh connectivity like this.

```
ssh master
ssh worker1
ssh worker2
ssh worker3
```

**Important** - if ssh does not work try the **`ping pi-r1d1`** command. If this fails too check that the **`/etc/hosts`** file contains the IP Address and hostname as explained in the above **Change Raspberry Pi Hostname** section.

Another common problem occurs when the DHCP (router) assigns a different IP address to a PI. Running your own (Pi-based) DNS server is the complete solution for this.


## 12. Install Ansible Somewhere

You can install Ansible either on your Linux laptop, on an (Ubuntu) Vagrant VM if you use Windows, or on one of your Raspberry Pis. Ansible is agentless so you only need to install it in one place.

### Install Ansible on Mac

If you are using a MacBook it is simple to install Ansible.

```
brew install ansible
ansible --version
```

### Install Ansible on Raspberry Pi (Ubuntu)

If you have an Ubuntu VM (Raspberry Pi, or laptop, or built by Vagrant) you can install Ansible with these commands.

```
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
ansible --version
```


## 13. Clone Ansible Playbooks and Setup Inventory

To create your Kubernetes cluster we clone this **[github Ansible repository](https://github.com/devops4me/ansible-kubernetes-cluster)** and setup the **`hosts.ini`** Ansible inventory file.

The steps are

1. **`git clone https://github.com/devops4me/ansible-kubernetes-cluster`**
1. **`cd ansible-kubernetes-cluster`**
1. edit the **`hosts.ini`** file to look like this


### The Ansislbe Inventory **`hosts.ini`** File

```
master ansible_host=master
worker ansible_host=worker1
worker ansible_host=worker2
worker ansible_host=worker3
```

The **`ansible_host`** refers to the **`Host`** variable inside the **`~/.ssh/config`** file. Use this command to validate your hosts file.

- **`ansible -m ping all -i hosts.ini`**

You can expect a response similar to this.

```
master | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
worker | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```


## 14. Ask Ansible to Provision the Kubernetes Cluster

Ansible provisions the Kubernetes cluster with just two commands.

1. **`ansible-playbook -i hosts.ini master-playbook.yml`**
1. **`ansible-playbook -i hosts.ini node-playbook.yml`**


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
