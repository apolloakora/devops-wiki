
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
