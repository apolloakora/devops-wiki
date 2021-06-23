
# Install Concourse in a Kubernetes Cluster using helm3

The quick way to just get concourse running in kubernetes (and then destroying it) is using these commands.

```
kubectl get pods
helm3 repo add concourse https://concourse-charts.storage.googleapis.com/
helm3 install concoursee-dev-release concourse/concourse
helm3 uninstall my-release
```

---


## Install Concourse using Helm

The default helm chart with ID **`concourse/concourse`** can be found in this github repository.

**`git clone https://github.com/concourse/concourse-chart`**

Pay attention to the values.yml file which you will most likely override parts of. Create a config override file called **`concourse-helm-values.yml`** with contents like this.

```
concourse:
  web:
    postgres:
      host: 10.50.0.3
      port: 5432
      sslmode: verify-ca
      connectTimeout: 5m
      database: rm

postgresql:

  enabled: false

secrets:

  create: true
  postgresUser: rmuser
  postgresPassword: password
```

Now install (and uninstall) concourse with these commands.

```
helm3 install ci-concourse -f concourse-helm-values.yml concourse/concourse
helm3 uninstall ci-concourse
kubectl get pods
```

You should have one web pod, two workers and a postgres database pod.


---


## How to Connect to a Custom Google CloudSQL (PostgreSQL) Database

For Concourse to use a Google Cloud SQL database we need to create the database and the certificates with terraform and then put them into kubernetes secrets (again with terraform) and add the names of those secrets to the Helm yamlo values override file.


## How to Connect to Prometheus to deliver metrics

For Concourse to use a Google Cloud SQL database we need to create the database and the certificates with terraform and then put them into kubernetes secrets (again with terraform) and add the names of those secrets to the Helm yamlo values override file.

