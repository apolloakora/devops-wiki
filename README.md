
# The Devops Wiki | [devopswiki.co.uk](https://www.devopswiki.co.uk)

This repository holds the content of the devops wiki which is served via the **[gollum devops4me/devopswiki.co.uk docker container](https://hub.docker.com/r/devops4me/devopswiki.co.uk)** in **dockerhub**.

## how to run the wiki

This wiki's image lives in Dockerhub so you can simply run it and start browsing.

```
docker run \
    --detach \
    --name vm.wiki \
    --publish 4567:4567 \
    devops4me/devopswiki.co.uk
docker logs vm.wiki
```

Now visit **`http://localhost:4567/`** to browse the WiKI locally.


## docker build the wiki | how to

To build **[the Dockerfile](https://github.com/apolloakora/devops-wiki/blob/master/Dockerfile)** you execute the docker build command with a **`--build-arg`** called **`WIKI_CONTENT_URL`** that specifies the git location url of the wiki's content.

```
docker build       \
    --no-cache     \
    --rm           \
    --build-arg WIKI_CONTENT_URL=https://github.com/apolloakora/devops-wiki.git \
    --tag img.wiki \
    .
```

**Beware there is a period (dot) on the final line of the build command.**

## docker run the locally built wiki

To run the docker image `img.wiki` that we built we use the same docker run command except we change to use the local image.

```
docker rm -vf vm.wiki && \
docker run \
    --detach \
    --name vm.wiki \
    --publish 4567:4567 \
    img.wiki
docker logs vm.wiki
```

Now visit **`http://localhost:4567/`** to browse the WiKI locally. Amend things to your liking and then push the docker image to the repository of your choice.

## Peripheral Wiki Files

All the markdown files are part of the wiki's content and are served up by Gollum. Aside from these the other resources are

- **media** (images and icons) within the media folder
- **stylesheets** containing the CSS definition files
- **templates** holding **mustache** web page templates for dynamic content
- **.gitignore** to stop unnecessary files/folders being checked in

## Wiki Continuous Integration Pipeline

The continuous integration pipeline runs on top of a dockerized **Jenkins and Kubernetes platform** and if successful is deployed into a cloud production Kubernetes platform.

The pipeline steps defined in the Jenkinsfile are to

- use [Google Kaniko] to build this Dockerfile from this wiki base image
- push the Dockerfile with the latest tag to this Dockerhub repository
- create another pod to run the just-built devopswiki.co.uk image
- configure the container with a readiness probe so it does not receive traffic too early
- run a linkcheck activity using this Dockerhub linkcheck image (from this Github repo)
- if the linkchecking produces errors the pipeline fails and stops
- on success the devopswiki image is tagged with build number, Git commit ref and timestamp
- a kubectl rollout is issued based on the newly tagged devopswiki image
- change the standing start Kubernetes deployment configs to reflect the new tag


## Useful Links

- **[Online URL Encoder/Decoder](https://www.urlencoder.org/)**
