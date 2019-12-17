
# microk8s import docker image

There are many reasons to import a docker image into the local microk8s Kubernetes cluster. Reasons like

- you have the docker image in a tar file - docker load won't work for kubernetes
- http server gave HTTP response to HTTPS client | connecting to a http registry
- connecting to AWS or Azure registries where credential passing is awkward
- you have the docker image in a tar file - docker load won't work for kubernetes


## Pull in the Image

Kubernetes **will not cache** an image with the latest tag on it so ensure that you are importing an image with a proper tag.

```
microk8s.ctr images ls
microk8s.ctr --namespace=k8s.io images ls
sudo apt install jq --assume-yes
curl -X GET http://10.0.3.64:5000/v2/<<image-name>>/tags/list | jq .
docker pull <<ip-address>>:<<port>>/<<image-name>>:<<image-tag>>
docker image ls
docker save 10.0.3.64:5000/<<image-name>>:1.0.43-4a0c72b > docker-image-4-microservice.tar
microk8s.ctr --namespace=k8s.io image import docker-image-4-microservice.tar
microk8s.ctr --namespace=k8s.io images ls
```

## Access the Image from a Deployment

Now that the image is within the kubernetes cluster we can access the image from a Deployment like this one.

```
apiVersion: apps/v1
kind: Deployment
metadata:
    name: wiki
spec:
    replicas: 1
    selector:
        matchLabels:
            pod-type: wiki
    template:
        metadata:
            name: wiki
            labels:
                pod-type: wiki
        spec:
            containers:
            -   name: vm-wiki
                image: 10.0.3.17:5000/image-name:image-tag
                ports:
                -   containerPort: 4321
```

Finally run the deployment.

```
kubectl apply -f <<deployment-file>>.yaml --record
```
