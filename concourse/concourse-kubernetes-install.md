
# Install Concourse in a Kubernetes Cluster using helm3

The quick way to just get concourse running in kubernetes (and then destroying it) is using these commands.

```
kubectl get pods
helm3 repo add concourse https://concourse-charts.storage.googleapis.com/
helm3 install concoursee-dev-release concourse/concourse
helm3 uninstall my-release
```


## Download the default concourse helm chart

**`git clone https://github.com/concourse/concourse-chart`**

You'll need this to pick out the sections that we want to override.


## How to Connect to a Custom Google CloudSQL (PostgreSQL) Database

For Concourse to use a Google Cloud SQL database we need to create the database and the certificates with terraform and then put them into kubernetes secrets (again with terraform) and add the names of those secrets to the Helm yamlo values override file.


## How to Connect to Prometheus to deliver metrics

For Concourse to use a Google Cloud SQL database we need to create the database and the certificates with terraform and then put them into kubernetes secrets (again with terraform) and add the names of those secrets to the Helm yamlo values override file.

