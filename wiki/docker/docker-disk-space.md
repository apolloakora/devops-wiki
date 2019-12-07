
# Reclaiming Docker Disk Space

Docker consumes giant chunks of your disk space and to run a scaleable system you need to know how to reclaim it safely.

## Reclaiming Docker Image Space

The **solution** is this command.

```
docker system prune -a --force
```

The **problem** is that Docker **never gives back space** taken up by

- stopped containers
- images not associated with any container
- the build cache
- networks unused by any containers

This hogging behaviour has penalties when you actively build and then run docker containers.