
# Multi-Cloud and On-Premises Infrastructure Tooling

To facilitate an infrastructure that can run on-premises and multi-cloud a number of primal architectural decisions need as far as is humanly possible to hold true.

These include

- a 100% dockerized infrastructure
- operating systems like CoreOS that is dedicated solely to making containers run fast with efficient resource utilization in the cluster
- machine boot technologies like ignition that can bring up machines on-premises and in all the major clouds
- opting for dockerized ElasticSearch, Redis Cache as opposed to AWS only versions

