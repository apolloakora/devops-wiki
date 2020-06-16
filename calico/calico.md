# Removing the Calico Overlay Network Plugin

During this spike I have concluded that
- no network policies are set that require the Calico overlay add-on
- whilst I cannot guarantee unwanted side effects - one or more are unlikely to occur


## What I have done during this spike

As well as the research and learning activities I have examined only my isolated Google cloud project as built by the code. I conclude that the differences for building other environments are not pertinent to this area. I have

- applied, run acceptance tests and destroyed the vanilla environment
- removed the below section then applied, ran tests and checked calico not present then destroyed
- applied, removed the section, re-applied, ran'd the tests, checked calico gone then destroyed

### Section Removed from **`kubernetes.tf`**

```
 addons_config {
    network_policy_config {
      disabled = false
    }
  }

  network_policy {
    enabled  = "true"
    provider = "CALICO"
  }
```

## Recommendation

My isolated checks suggest

- we can safely remove calico
- we can remove it by rebuilding from the ground up or
- we can let terraform manage the change

All things being equal **rebuilding from the ground up** is the safer course.
Also worth noting that my tests had many failures (with and without calico).


## Research and Resources

I have researched the Calico/Flannel overlay network matter thoroughly (Blogs, StackOverflow, YouTube videos, Books and Manuals) especially focusing on its use within Google's Kubernetes Engine. Also I have looked at the terraform code that builds the cluster.

The resources pertinent to this spike are

- **kubernetes.tf** in census-rm-terraform and
- the **[terraform documentation for google container cluster](https://www.terraform.io/docs/providers/google/r/container_cluster.html)**



## Terraform Documentation for google_container_cluster

- **`addons_config`** - (Optional) The configuration for addons supported by GKE. Structure is documented below.
- **`network_policy`** - (Optional) Configuration options for the NetworkPolicy feature. Structure is documented below.
- **`network_policy_config`** - (Optional) Whether we should enable the network policy addon for the master. This must be enabled in order to enable network policy for the nodes. To enable this, you must also define a network_policy block, otherwise nothing will happen. It can only be disabled if the nodes already do not have network policies enabled. Defaults to disabled; set disabled = false to enable.

As explained above in the network_policy_config the **`network_policy`** block supports

- **`provider`** - (Optional) The selected network policy provider. Defaults to PROVIDER_UNSPECIFIED.
- **`enabled`** - (Required) Whether network policy is enabled on the cluster.
