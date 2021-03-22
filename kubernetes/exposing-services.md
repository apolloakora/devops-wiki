
# How to Expose Services Implemented Inside and Outside Kubernetes

**How do we expose services implemented by one or more pods inside Kubernetes to external clients and conversely how do we expose externally implemented services (like a database cluster) to applications running within Kubernetes?**

This is your goto list for exposing services in and out of Kubernetes and I tell you when and why it is appropriate to use each method. So how do you

- access services from within the cluster
- use **`kubectl port-forward`** to expose services
- use a NodePort to expose services
- use the (costly) LoadBalancer to expose services in clouds
- use an Ingress - the gold standard of exposing services
- install an ingress controller on bare metal clusters
- route traffic to multiple services from one domain name

## Use `kubectl port-forward` to expose services

Put the below in a file called **`website.yml`** and then **`kubectl apply -f website.yml`**

```
kind: Pod
apiVersion: v1
metadata:
  name: website-pod
  labels:
    app: website-app
spec:
  containers:
    - name: website-container
      image: nginx
---
kind: Service
apiVersion: v1
metadata:
  name: website-service
spec:
  selector:
    app: website-app
  ports:
    - port: 80
```

Now you can use any one of these port-forward commands to expose the nginx webpage.

```
kubectl port-forward pod/website-pod 7788:80
kubectl port-forward service/website-service 7788:80
```

Now go to this link [http://localhost:7788/] and you'll see the nginx welcome page.

### When to use kubectl port-forward

Only use this command during development or troubleshooting to look at the response given by a pod, deployment or service. As soon as you Ctrl-C the port-forward command the exposure vanishes.


---


## Exposing Services via an Ingress Controller

If you are running a local (non-cloud) cluster and you want to expose your services professionally you need
 to use an Ingress Controller.

## The nginx ingress controller

Using the nginx ingress controller gives you a professional application layer (network layer 7) traffic routing service which can

- load balance across many pods on many nodes
- send traffic to different kubernetes services based on the url or hostname
- use the TLS (https) protocol to talk to services
- use readiness and liveness probes to decide whether a pod can receive traffic
- decouple external clients from cluster implementation specifics


## Install the nginx ingress controller

Once the yaml below is applied a pod called **`ingress-nginx-controller-abcdef-12345`** should exist.

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/deploy/static/provider/baremetal/deploy.yaml
kubectl get pods -o wide --all-namespaces
kubectl exec -n ingress-nginx ingress-nginx-controller-<POD_ID> -- /nginx-ingress-controller --version
kubectl describe service -n ingress-nginx ingress-nginx-controller
```

Describing the **`ingress-nginx-controller`** tells us which ports we can access the **http** and the **https** through.

```
Name:                     ingress-nginx-controller
Namespace:                ingress-nginx
Labels:                   app.kubernetes.io/component=controller
                          app.kubernetes.io/instance=ingress-nginx
                          app.kubernetes.io/managed-by=Helm
                          app.kubernetes.io/name=ingress-nginx
                          app.kubernetes.io/version=0.44.0
                          helm.sh/chart=ingress-nginx-3.23.0
Annotations:              kubectl.kubernetes.io/last-applied-configuration:
                            {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"labels":{"app.kubernetes.io/component":"controller","app.kubernetes.io/i...
Selector:                 app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
Type:                     NodePort
IP:                       10.107.236.168
Port:                     http  80/TCP
TargetPort:               http/TCP
NodePort:                 http  32560/TCP
Endpoints:                172.16.5.10:80
Port:                     https  443/TCP
TargetPort:               https/TCP
NodePort:                 https  30348/TCP
Endpoints:                172.16.5.10:443
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```

Using the above we can go to any machine (control plane and workers) in the cluster at port **`32568`** to access our services. As we haven't setup any routing rules we are happy to see the **404 Not Found** nginx ingress controller default respose page.

### Bare Metal Raspberry Pi Cluster

I'm using a **bare metal raspberry pi cluster** with machines named **`pi-r1d1`** and **`pi-r1d2`** and so on. The below url all give me the ingress controller **404 not found** page.

```
http://pi-r1d1:32560
http://pi-r1d2:32560
http://192.168.0.60:32560
http://192.168.0.61:32560
https://pi-r1d3:30348
https://192.168.0.61:30348
```


---


## Access Services via the nginx ingress controller

Before trying to access your service make sure you have

1. setup the **website-pod** and **website-service** above
1. installed the nginx ingress controller and can access it

