# Expose Kubernetes Services via an Ingress Controller and a Load Balancer

Your bare metal kubernetes setup needs to expose services using the de-facto ingress pattern fronted by a load balancer. The basic steps to achieving this is to

- deploy 2 kubernetes cluster resident services
- install the **nginx ingress controller**
- configure the ingress controller to route traffic to the 2 services we setup
- discuss why we should install a bare metal load balancer
- install an external **nginx load balancer**
- configure traffic flows from load balancer through the ingress controller to the services and back


---

## Deploy 2 Services into the Cluster

Let's deploy a Jenkins and a RabbitMQ pod and then create a cluster Service object to access the pods. We will use these services first through an ingress controller and then later we'll put an external load balancer outside the cluster to send traffic to available cluster worker nodes.

```
kind: Pod
apiVersion: v1
metadata:
  name: rabbitmq-pod
  labels:
    app: rabbitmq-app
spec:
  containers:
    - name: rabbitmq-container
      image: rabbitmq:3-management
      ports:
      - containerPort: 15672
---
kind: Service
apiVersion: v1
metadata:
  name: rabbitmq-service
spec:
  selector:
    app: rabbitmq-app
  ports:
  - protocol: TCP
    port: 15672
---
kind: Pod
apiVersion: v1
metadata:
  name: jenkins-pod
  labels:
    app: jenkins-app
spec:
  containers:
    - name: jenkins-container
      image: mlucken/jenkins-arm
      ports:
      - containerPort: 8080
      securityContext:
        privileged: true
---
kind: Service
apiVersion: v1
metadata:
  name: jenkins-service
spec:
  selector:
    app: jenkins-app
  ports:
  - protocol: TCP
    port: 8080
```

Use **`kubectl apply -f `** to create the two pods and the two cluster resident servcies.


---


## Install the nginx ingress controller

Using the nginx ingress controller gives you a professional application layer (network layer 7) traffic routing service which can

- load balance across many pods on many nodes
- send traffic to different kubernetes services based on the url or hostname
- use the TLS (https) protocol to talk to services
- use readiness and liveness probes to decide whether a pod can receive traffic
- decouple external clients from cluster implementation specifics

Installing the ingress controller amounts to one simple kubectl apply of github resident yaml. After the apply a pod called **`ingress-nginx-controller-abcdef-12345`** should exist.

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

I'm using a **bare metal raspberry pi cluster** with machines named **`pi-r1d1`** and **`pi-r1d2`** and so on. The below urls all give me the ingress controller **404 not found** page.

```
http://pi-r1d1:32560
http://pi-r1d2:32560
http://192.168.0.60:32560
http://192.168.0.61:32560
https://pi-r1d3:30348
https://192.168.0.61:30348
```

Now we are ready to first configure the ingress controller to point to our cluster resident services before fronting the whole setup with an external load balancer.


---


## Configure nginx Ingress Controller

Note the **`kind`** on the yaml below. The ingress object is decorated with the nginx ingress controller. Once you **`kubectl apply -f`** on the yaml below, any traffic sent to the ingress controller port with

- **`http://jenkins`** will route to the jenkins service
- **`http://rabbitmq`** will route to the rabbitmq service

```
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: website-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
  - host: rabbitmq
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: rabbitmq-service
            port:
              number: 15672
  - host: jenkins
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: jenkins-service
            port:
              number: 8080
```


---


## Why Install a Bare Metal Load Balancer 

I have a home Raspberry Pi kubernetes cluster and I have installed the below load balancer setup. **Why?**

Compared to my sturdy load balancer machine the cheap commodity raspberry pi's are more likely to

- fail
- run out of disk space
- require upgrades or
- require service/machine restarts
- be too busy to talk

So binding (sending) web and api requests directly to a cluster machine results in frustrating outages to clients of the cluster.

### The Benefits of a Load Balancer

**The cost of cloud load balancers is astronomic.** So using one load balancer coupled with a kubernetes ingress controller is now the de-facto pattern for exposing services.

Let's mimic this within our bare metal kubernetes cluster.

A load balancer in cost efficient bare metal home/office/garage settings can

- mirror the de-facto **one load balancer** pattern
- detect and avoid failed machines
- perform health and readiness checks 
- spread the load using congurable algorithms
- perform content caching and SSL termination
- be a test-bed before promoting to the cloud


---


## Install nginx load balancer onto Bare Metal

If you decide to run a bare metal load balancer there is not better choice than nginx. The steps are

- setup Ubuntu Server on a simple (but sturdy) machine
- give it a hostname of **`pathway`**
- **`sudo apt-get update`**
- **`sudo apt-get install nginx`**
- **`sudo systemctl restart nginx`**
- put the IP address and **`pathway`** name in /etc/hosts

Use **`htp://pathway`** to acquire the ubiquitous nginx welcome page.


---


### The Load Balancer Configuration

Replace the nginx configuration file at **`/etc/nginx/nginx.conf`** with this one.

```
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 768;
}

http {

    upstream pathway {
        server 192.168.0.61:32560;
        server 192.168.0.59:32560;
        server 192.168.0.62:32560;
    }

    # This server accepts all traffic to port 80 and passes it to the upstream.
    # Notice that the upstream name and the proxy_pass need to match.

    server {
        listen 80;

        location / {
            proxy_pass http://pathway;
        }
    }
}
```

Now we will

- remove the default link in **`/etc/nginx/sites-enabled`**
- place our configuration file into **`/etc/nginx/nginx.conf`**
- and restart nginx (to read the new config)

```
sudo rm /etc/nginx/sites-available/default # remove the default symbolic link
sudo systemctl restart nginx               # read load balancer configuration
```

If an error occurs you can start trouble shooting with

- **`sudo systemctl status nginx.service`**
- **`journalctl -xe`**


---


## Access Services via the nginx ingress controller

Before trying to access your service make sure you have

1. setup the **website-pod** and **website-service** above
1. installed the nginx ingress controller and can access it


I used this nginx configuration file to access a RabbitMQ Pod via **`http://rabbitmq`** and a Jenkins setup via **`http://jenkins`**

```
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 768;
}

http {

    # The instruction is to accept all traffic coming into port 80 and pass
    # it on to the servers defined in the upstream block. The upstream names
    # must match the urls within the proxy_pass lines.

    upstream rabbitmq {
        server 192.168.0.61:32560;
        server 192.168.0.59:32560;
        server 192.168.0.62:32560;
    }

    server {
        listen 80;
        server_name rabbitmq;
        location / {
            proxy_pass http://rabbitmq;
        }
    }

    upstream jenkins {
        server 192.168.0.61:32560;
        server 192.168.0.59:32560;
        server 192.168.0.62:32560;
    }

    server {
        listen 80;
        server_name jenkins;
        location / {
            proxy_pass http://jenkins;
        }
    }
}
```

## The `/etc/hosts` on Client Machines

Note that on my local network this **`/etc/hosts`** file was used to route traffic to the nginx load balancer (on 192.168.0.63) which in turn routes the calls to the **nginx ingress controller** sitting in the kubernetes cluster (with worker machines ending in 59, 61 and 62) listening on port 32560 for http traffic (see command above to ascertain this port).

```
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost
192.168.0.60	pi-r1d1
192.168.0.61	pi-r1d2
192.168.0.59	pi-r1d3
192.168.0.62	pi-r1d4

## The Load Balancer Host
192.168.0.63	orbit
192.168.0.63	jenkins
192.168.0.63	rabbitmq
```

Note the final two names enable simple http access via the load balancer to the kubernetes cluster.
