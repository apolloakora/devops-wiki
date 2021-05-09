# Expose Kubernetes Services via `kubectl port-forward`

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
kubectl port-forward pod/website-pod 7889:80
kubectl port-forward service/website-service 7889:80
```

Now go to this link [http://localhost:7889/] and you'll see the nginx welcome page.

### When to use kubectl port-forward

Only use this command during development or troubleshooting to look at the response given by a pod, deployment or service. As soon as you Ctrl-C the port-forward command the exposure vanishes.
