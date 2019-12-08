
# Install Full Kubernetes on Ubuntu | microk8s

Installing the Full Kubernetes system on Ubuntu using snap is fast and simple. You can tie up a number of laptops or PCs by installing microk8s and then adding (and subsequently) removing them to form a powerful n-node cluster.

```
sudo snap install microk8s --classic
sudo usermod -a -G microk8s $USER
# Now logout and login again
microk8s.status
```

### [microk8s userguide](https://microk8s.io/docs/)

After putting the user in the microk8s group you need to completely logout (not just grab a new shell) and login again. It is worth it to avoid continually having to use the sudo prefix.

## Alias the microk8s kubectl command

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

## Enable Dns and Kibana Dashboard Add-ons

Dns and dashboard are core services and must always be enabled. Despite the alias you must use sudo to do this.

```
sudo microk8s.enable dns dashboard
microk8s.status
```

The status command assures as that microk8s is running and the dns and dashboard add-ons have been enabled.

## Access the Grafana Dashboard

The first command finds the URL of the Grafana dashboard. The microk8s.config command tells us the username password to use to access the dashboard.

```
microk8s.kubectl cluster-info
microk8s.config | grep -E "(username|password):"
```

Now go to the grafana dashboard url and use the username password provided by the **`microk8s.config`** command.


## Finding out tokens

```
kubectl -n kube-system get secret | grep default-token | cut -d " " -f1
TOKEN_NAME=$(kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
echo $TOKEN_NAME
kubectl -n kube-system describe secret $TOKEN_NAME
```


## Adding a Node to the Microk8s Cluster

**Kubernetes is no fun with just one node!** Ask the first node for the token (and command) that other nodes should use to join.

```
microk8s.add-node
kubectl get nodes
```

The reply should be something like this.

```
Join node with: microk8s.join 192.168.0.57:25000/cTrQpOfEhNhfbhbnRmiRVZoimVDEveXZ
```

On the second node simply issue the aforementioned command and the next time you do **`kubectl get nodes`** verifies that your new node has joined.


## Run nginx from kubectl command line

```
kubectl run nginx --image nginx
kubectl expose deployment.apps/nginx --port 80
kubectl get service
kubectl describe svc/nginx
kubectl proxy
```

The describe command has an **`Endpoints`** field. Pump this into your browser and the nginx welcome page should show up.


## Run Wiki from a Deployment Descriptor

You can run simple images like nginx from the command line but most of the time you use a deployment descriptor in the default yaml format.


```
kubectl apply -f example-deployment.yaml
```


``` yaml
apiVersion: v1
kind: Pod
metadata:
    name: devops-wiki
    labels:
        purpose: host-devops-wiki
spec:
    containers:
    - name: vmwiki
      image: "devops4me/wiki"
      env:
      - name: WIKI_CONTENT_REPO_URL
        value: "https://github.com/apolloakora/devops-wiki"
```