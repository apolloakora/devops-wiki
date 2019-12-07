


@todo -- add this command to the ci.md batch

- **`sudo sysctl -w vm.max_map_count=262144`** # increases open files for elasticsearch to operate



## max virtual memory areas vm.max_map_count is too low, increase ...

If you encounter the error **`max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]`** then know that this concerns the maximum number of open files on the host. Elasticsearch needs it to be at least 262144 so run this command to enable that.

- **`sudo sysctl -w vm.max_map_count=262144`**

Elasticsearch 5 and 6 services stop their initialization on encountering this error.



#### [ELK Stack Docker Compose Logging Example](https://docs.fluentd.org/v/0.12/container-deployment/docker-compose)

