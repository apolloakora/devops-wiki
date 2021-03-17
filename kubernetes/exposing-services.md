
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

## Exposing Services via an Ingress Controller

If you are running a local (non-cloud) cluster and you want to expose your services professionally you need to use an Ingress Controller.

## The nginx ingress controller

Using the nginx ingress controller gives you a professional application layer (network layer 7) traffic routing service which can

- load balance across many pods on many nodes
- send traffic to different kubernetes services based on the url or hostname
- use the TLS (https) protocol to talk to services
- use readiness and liveness probes to decide whether a pod can receive traffic
- decouple external clients from cluster implementation specifics


## Install the ingress controller

Once the yaml below is applied a pod called **`ingress-nginx-controller-abcdef-12345`** should exist.

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/deploy/static/provider/baremetal/deploy.yaml
kubectl get pods -o wide --all-namespaces
kubectl exec -n ingress-nginx ingress-nginx-controller-<POD_ID> -- /nginx-ingress-controller --version
```

Replace the **`<POD_ID>`** with the correct hash. This should result in a listing of the NGINX Ingress controller version.

```
-------------------------------------------------------------------------------
NGINX Ingress controller
  Release:       v0.44.0
  Build:         f802554ccfadf828f7eb6d3f9a9333686706d613
  Repository:    https://github.com/kubernetes/ingress-nginx
  nginx version: nginx/1.19.6
-------------------------------------------------------------------------------
```

