
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


### Importing Using Resource Specifiers

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
