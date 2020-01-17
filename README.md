
# The Devops Wiki | [devopswiki.co.uk](https://www.devopswiki.co.uk)

This repository holds the content of the devops wiki which is served via the **[gollum devops4me/wiki docker container](https://hub.docker.com/r/devops4me/wiki)** in *dockerhub**.

## Run Wiki Locally

To run this wiki locally you use a simple docker build and run.

```
git clone https://github.com/apolloakora/devops-wiki
cd devops-wiki
docker build --no-cache --rm --tag img.wiki .
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
- configure the container with a readiness probe so it does no receive traffic too early
- run a linkcheck activity using this Dockerhub linkcheck image (from this Github repo)
- if the linkchecking produces errors the pipeline fails and stops
- on success the devopswiki image is tagged with build number, Git commit ref and timestamp
- a kubectl rollout is issued based on the newly tagged devopswiki image
- change the standing start Kubernetes deployment configs to reflect the new tag
