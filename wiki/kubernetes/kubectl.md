
# kubectl | The Kubernetes Command Line Management Interface

When running a Kubernetes deployment, you use kubectl (on your client's command line) to ask about status, to perform software as a service (SAAS) releases, and to perform administrative duties.

The **prerequisites** are that

- you have downloaded and installed kubectl on the client
- you have installed (or can access) a (usually remote) kubernetes server deployment
- you can (through OpenVPN and/or SSL certificates) access the Kubernetes server

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

