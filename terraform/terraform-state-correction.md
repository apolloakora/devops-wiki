
# How to Correct Terraform State | 2 Scenarios with 3 fixes

There are 2 scenarios that cause terraform state mirroring errors and you need to be able to deal with them.

- resource has been deleted in cloud so terraform fails because it tries to talk to it
- terraform state has been deleted locally so terraform tries to create but fails as already exists

## Resource Deleted in Cloud

To fix the first scenario we delete the terraform state.

```
terraform state rm resource-class-name.resource-object-name
```

To fix the second we need to have 2 skills. The first skill is easy - simply go and delete the resource in the cloud. Now terraform tries to recreate and it no longer exists so all is good.

### What if you cannot delete the resource in the cloud

There are some resources you cannot delete in the cloud.

```
Error: Error creating CryptoKey: googleapi: Error 409: CryptoKey projects/devops4me/locations/europe-west2/keyRings/cluster-key-ring/cryptoKeys/cluster-key already exists.

  on main.tf line xxx, in resource "google_kms_crypto_key" "cluster_key":
 xxx: resource google_kms_crypto_key cluster_key {
```

In the google cloud you cannot delete KMS key rings and keys. So to fix the already exists error we need to  import the object's state into terraform.

```
terraform import google_kms_crypto_key.cluster_key projects/devops4me/locations/europe-west2/keyRings/cluster-key-ring/cryptoKeys/cluster-key
```


## terraform import | using resource specifiers

Using terraform import with a resource specifier of projects/abc/locations/xyz/clusters/mycluster sometimes does not work. The resource needs to be specified more succinctly.

#### Error Message

```
Error: googleapi: Error 409: Already exists: projects/<project-name>/locations/<location-id>/clusters/<cluster-id>., alreadyExists

  on kubernetes.tf line 13, in resource "google_container_cluster" "terraform-resource-name":
  13: resource "google_container_cluster" "terraform-resource-name" {
```

To import this resource we a more succinct resource specifier holding the project slash location slash cluster identifiers.

```
terraform import google_container_cluster.<terraform-resource-name> <project-id>/<location-id>/<cluster-id>
```

## terraform import (Example 2)

### Error creating GlobalAddress: googleapi: Error 409: The resource 'projects/...' already exists, alreadyExists

```
  on main.tf line 15, in resource "google_compute_global_address" "postgres-db":
  15: resource "google_compute_global_address" "postgres-db" {
```

With this we use the below terraform import command.

```
terraform import google_compute_global_address.postgres-db projects/...
```



## Invalid Index Error

```
Error: Invalid index

  on this_file.tf line 3, in locals:
   3:     "serviceAccount:${google_service_account.this-one[0].email}",
    |----------------
    | google_service_account.this-one is empty tuple

The given key does not identify an element in this collection value.
```

When state gets out of sync you can get this invalid index error and fix it by (target) destroying the resource specified.

```
terraform destroy -target google_service_account.this-one
```
