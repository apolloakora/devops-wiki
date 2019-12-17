
# Kubernetes Troubleshooting Tips

A lot can go wrong in the world of Kubernetes. Here is a list of symptoms, ways to dig deeper, likely culprits, what doesn't work and remedial actions.

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
