
# microk8s | How to Install Kubernetes on Ubuntu

Installing the Full Kubernetes system on Ubuntu using snap is fast and simple. You can tie up a number of laptops or PCs by installing microk8s and then adding (and subsequently) removing them to form a powerful n-node cluster.

## Step 1 | Install Kubernetes using Snap

```
sudo apt-get update && sudo apt-get --assume-yes upgrade
sudo snap install microk8s --classic
sudo usermod -aG microk8s $USER
# Now logout and login again
microk8s.status
```

You **avoid using sudo** by adding your user to the microk8s group. For this to take effect you must **completely logout** (not just grab a new shell) and login again.


---


## Step 2 | Alias the microk8s kubectl command

Use either **`microk8s.config`** or **`microk8s.kubectl config view --raw`** to view the yaml-ized kubectl config. What the below kubectl alias commands do is point that config to the **`$HOME/.kube/config`** file.

If kubectl is already installed on the system then you'll need to prefix commands for microk8s as below.

```
microk8s.kubectl get nodes
microk8s.kubectl get services
```

However if microk8s provides the only kubectl you need you can alias it.

```
sudo snap alias microk8s.kubectl kubectl
kubectl get nodes
kubectl get services
```

You can subsequently remove the alias if need be.

```
sudo snap unalias kubectl
```


---


## Step 3 | Enable Dns and Kibana Dashboard Add-ons

Dns and dashboard are core services and must always be enabled. Despite the alias you must use sudo to do this.

```
sudo microk8s.enable dns dashboard
microk8s.status
```

The status command assures as that microk8s is running and the dns and dashboard add-ons have been enabled.


---


## Step 4 | Access the Grafana Dashboard

The first command finds the URL of the Grafana dashboard. The microk8s.config command tells us the username password to use to access the dashboard.

```
microk8s.kubectl cluster-info
microk8s.config | grep -E "(username|password):"
```

Now go to the grafana dashboard url and use the username password provided by the **`microk8s.config`** command.


---


## Step 5 | Add a Node to the (microk8s) Kubernetes Cluster

**Kubernetes is no fun with just one node!**. Also **microk8s is the full kubernetes software** unlike _miniqube_ which rewrites and removes many core Kubernetes elements.

<blockquote>
To save money (paying for cloud machines) we use Kubernetes to run our Continuous Integration pipeline. Every laptop participates in the cluster and no laptop is important. Switch any off and the cluster elects new leaders for the control plane and is happy for worker nodes to leave or join the cluster.
</blockquote>

The simple way to add a node is to ask the first node for the token (and command) for joining.

```
microk8s.add-node
kubectl get nodes
```

The reply should be something like this.

```
Join node with: microk8s.join 192.168.0.57:25000/cTrQpOfEhNhfbhbnRmiRVZoimVDEveXZ
```

To join, simply install Kubernetes and issue the aforementioned command taking care to slot in the correct **ip address**, **port** and **cluster token**.

```
sudo apt-get update && sudo apt-get --assume-yes upgrade
sudo snap install microk8s --classic
sudo usermod -aG microk8s $USER
microk8s.join <<master-ip-address>:25000/<<cluster-token>>
```

Now verify your new node has joined by issuing **`kubectl get nodes`** from any master.



---


## Did You Know?

Did you know these useful microk8s commands.

```
sudo snap logs microk8s
sudo microk8s.inspect
sudo microk8s.status
sudo microk8s.stop
sudo microk8s.start
sudo microk8s.reset
sudo systemctl restart snap.microk8s.daemon-containerd
```


Did you know that

- the **[kubernetes secrets knowledge base is here](kubernetes/kubernetes-secrets)**
- the full **[microk8s userguide is here](https://microk8s.io/docs/)**


