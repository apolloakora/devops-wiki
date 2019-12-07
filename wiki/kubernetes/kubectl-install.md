
# kubectl | How to Install the Kubernetes CLI on Ubuntu 16.04 and 18.04

You use kubectl to talk to and manage your **Kubernetes cluster** from a remote machine. You can ask it to list the available nodes and many other parameters.

Commonly certificates are used to control access and we'll need to get kubectl to use our key and we will also need to add the signing authority certificates to the browser to use https but avoid the security exception warnings.

### Download the kubectl executable.

Use this link to download the latest version for Linux - it is important to check that kubectl matches the Kubernetes server version or at least has backwards compatibility from client to server or server to client.

``` bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
```

To download a specific version, replace the `$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)` portion of the command with the specific version.

### Deploy kubectl and make it executable

Deploy the executable into /usr/local/bin/kubectl and use chmod to give it execute permissions.

