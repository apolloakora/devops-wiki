
# kubectl run

## Run nginx from kubectl command line

```
kubectl run nginx --image nginx
kubectl expose deployment.apps/nginx --port 80
kubectl get service
kubectl describe svc/nginx
kubectl proxy
```

The describe command has an **`Endpoints`** field. Pump this into your browser and the nginx welcome page should show up.


---


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
