
# Using Docker


## How to Save and Load Docker Images

Use **`docker save`** and **`docker load`** to save and load images.

```
docker image ls
docker save <<repository>> > my-docker-image.tar
# move my-docker-image.tar somewhere else
docker load --input my-docker-image.tar
docker image ls
```

