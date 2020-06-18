
# Kubernetes Troubleshooting Tips

A lot can go wrong in the world of Kubernetes. Here is a list of symptoms, ways to dig deeper, likely culprits, what doesn't work and remedial actions.



## Kubernetes Nodes have Same IP Address

If **`kubectl get nodes -o wide`** returns a table with **INTERNAL-IP** having all the same values like the table below, wht do you do?

```
NAME         STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
k8s-master   Ready    master   18m   v1.18.4   10.0.2.15     <none>        Ubuntu 18.04.4 LTS   4.15.0-106-generic   docker://19.3.11
node-1       Ready    <none>   16m   v1.18.4   10.0.2.15     <none>        Ubuntu 18.04.4 LTS   4.15.0-106-generic   docker://19.3.11
node-2       Ready    <none>   14m   v1.18.4   10.0.2.15     <none>        Ubuntu 18.04.4 LTS   4.15.0-106-generic   docker://19.3.11
```

This problem occurs because if you do not override the kubelet service definition to override the hostname. Without this statement kubelet picks the first interface address available which on Vagrant (the NAT interface) is always the same.

#### `Environment="KUBELET_EXTRA_ARGS=--hostname-override=xx.x.x.xx"`

We need to insert the above line in the kubelet service file and set **`xx.x.x.xx`** to **`10.0.2.16`** then **`10.0.2.17`** and so on. After that we need to restart the kubelet service.

### Solution | Setting the Node's IP Address

On older kubernetes versions the workaround was to manually insert the **`KUBELET_EXTRA_ARGS`** line above into the **`/etc/default/kubelet`** file. More recently this file will not exist and even the official Kubernetes Vagrant Ansible install blog (for Ubuntu 16.04) will cause a **file not found** failure.

The **[kubeadm init documentation](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/)** explains how to address this issue in the **`Setting the node name`** section.

<blockquote>
By default, kubeadm assigns a node name based on a machine's host address. You can override this setting with the --node-name flag. The flag passes the appropriate --hostname-override value to the kubelet.
</blockquote>

So set the --node-name flag when running the kubeadm init command and it will result in **`--hostname-override`** being set in the kubelet service file.


---


## Kubernetes Nodes NotReady

### symptoms | `kubectl get nodes`

The node status is marked as **NotReady** by the **`kubectl get nodes`** command.

```
NAME         STATUS     ROLES    AGE     VERSION
k8s-master   NotReady   master   27m     v1.18.3
node-1       NotReady   <none>   11m     v1.18.3
node-2       NotReady   <none>   10m     v1.18.3
node-3       NotReady   <none>   9m54s   v1.18.3
```

### try | `kubectl describe nodes`

Describing the nodes gives you a lot more information and can reveal the error in many cases. The below example shows that the runtime network is not ready.


#### `runtime network not ready: NetworkReady=false reason:NetworkPluginNotReady message:docker: network plugin is not ready: cni config uninitialized`

```
Conditions:
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  MemoryPressure   False   Tue, 16 Jun 2020 11:13:42 +0000   Tue, 16 Jun 2020 10:03:09 +0000   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Tue, 16 Jun 2020 11:13:42 +0000   Tue, 16 Jun 2020 10:03:09 +0000   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Tue, 16 Jun 2020 11:13:42 +0000   Tue, 16 Jun 2020 10:03:09 +0000   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            False   Tue, 16 Jun 2020 11:13:42 +0000   Tue, 16 Jun 2020 10:03:09 +0000   KubeletNotReady              runtime network not ready: NetworkReady=false reason:NetworkPluginNotReady message:docker: network plugin is not ready: cni config uninitialized
```


---


## Error from server (BadRequest): container in pod is waiting to start: trying and failing to pull image

### Symptoms | ErrImagePull | ImagePullBackOff

When you run **`kubectl get pods`** you see **`ErrImagePull`** and/or **`ImagePullBackOff`**

### Dig Deeper with `kubectl describe pod <<pod-name>>`

Run command **`kubectl describe pod <<pod-name>>`** and the Events section may be similar to this.

```
  Type     Reason     Age                From               Message
  ----     ------     ----               ----               -------
  Normal   Scheduled  33s                default-scheduler  Successfully assigned default/pod-6f9d77b58-nnfvr to app7
  Normal   Pulling    20s (x2 over 32s)  kubelet, app7      Pulling image "10.0.3.17:5000/image-name:latest"
  Warning  Failed     20s (x2 over 32s)  kubelet, app7      Failed to pull image "10.0.3.17:5000/image-name:latest": rpc error: code = Unknown desc = failed to resolve image "10.0.3.17:5000/image-name:latest": no available registry endpoint: failed to do request\
: Head https://10.0.3.17:5000/v2/image-name/manifests/latest: http: server gave HTTP response to HTTPS client
  Warning  Failed     20s (x2 over 32s)  kubelet, app7      Error: ErrImagePull
  Normal   BackOff    7s (x2 over 32s)   kubelet, app7      Back-off pulling image "10.0.3.17:5000/image-name:latest"
  Warning  Failed     7s (x2 over 32s)   kubelet, app7      Error: ImagePullBackOff
```

### Culprit | http: server gave HTTP response to HTTPS client

Docker produces this **`HTTP response to HTTPS client`** error when connecting to a docker registry via HTTP.

### does not work | setting insecure-registries in /etc/docker/daemon.json

Kubernetes does not read this file so setting it does not work.

### solution | for microk8s set /var/snap/microk8s/current/args/docker-daemon.json

```
cp docker-daemon.json /var/snap/microk8s/current/args/
ls -lah /var/snap/microk8s/current/args/
```
