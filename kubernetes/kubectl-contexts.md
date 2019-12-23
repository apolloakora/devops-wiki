
# kubectl contexts manage kubernetes environments

## What is a Kubernetes Context

If you want to manage more than one deployment (like a canary, production and lab kubernetes), you use contexts. You have to

- add the context to the kubectl configuration file
- then you use (or set) the context you want to work on
- and when finished you switch to the next context

You can also set a default context if you use one a lot more than the others.


``` bash
kubectl config current-context  # find the current context
```

## How to Add a Kubernetes Context

