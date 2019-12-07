
# Docker Command Listing


## Execute Command Inside Docker Container

The docker container must be running to execute a command within it.

![docker logo](/media/docker-logo-panorama.png "Docker and Docker Compose Logo")

### Run 1 Command with Docker Exec

```
sudo docker exec -it container.gollum.wiki pwd
sudo docker exec -it container.gollum.wiki ls -lah
```

### Run 2 or More Commands with Docker Exec

Use ***<code>bash -c</code>*** for docker exec to run 2 or more commands (that are not inside a script).

>> Don't forget to use double or single quotes.

```
sudo docker exec -it ctr.gollum.wiki bash -c "echo; pwd; echo; ls -lah; echo;"
```

The **docker exec** commands are wrapped in an ***echo sandwich*** for output readability as illustrated below.

<strong>
<pre>

/var/opt/gollum/wiki.18234.1305

total 40K
drwxr-xr-x  7 gollum gollum 4.0K Dec 10 15:48 .
drwxr-xr-x  3 gollum gollum 4.0K Dec 10 15:48 ..
drwxr-xr-x  8 gollum gollum 4.0K Dec 10 15:48 .git
-rw-r--r--  1 gollum gollum   76 Dec 10 15:48 _Sidebar.md
drwxr-xr-x 16 gollum gollum 4.0K Dec 10 15:48 devops
-rw-r--r--  1 gollum gollum 6.1K Dec 10 15:48 home.md
drwxr-xr-x  2 gollum gollum 4.0K Dec 10 15:48 media
drwxr-xr-x  2 gollum gollum 4.0K Dec 10 15:48 stylesheets
drwxr-xr-x  3 gollum gollum 4.0K Dec 10 15:48 templates

</pre>
</strong>


| Command Parameter | Value | Comment |
| ------ | ------------ | -------- |
| Container Name | ctr.gollum.wiki | The container name from <code>sudo docker ps -a</code> |
| Command to Run | <code>pwd</code> and <code>ls -lah</code> | Command wrapped in an echo sandwich |


## Docker Image Commands | build | tag | image ls | image inspect rmi

    docker images
    docker images --all             # show intermediaries too
    docker rmi <<xyz123abc>>        # delete just the one image
    docker rmi $(docker images -aq) # delete all the images
    docker system df -v             # image size plus containers
    docker image inspect <<idxyz>>  # examine image properties


    docker build --tag jenkins2-image -f Dockerfile_jenkins2 .
    docker build --tag devops4me/jenkins2:v0.0.0001 -f Dockerfile_jenkins2 .

    # tag an image already in the repository for major/minor version changes
    docker image tag devops4me/jenkins2:v0.0.0001 devops4me/jenkins2:lts

    docker history devops4me/jenkins2:v0.0.0001 # powerful image layer examination

    docker system df -v  # examine docker image sizes


## docker registry commands | build | tag | pull | push | history | login | logout | image ls | image inspect

    doker login --username=<<username>> --password=<<secret12345>>
    docker push devops4me/jenkins2
    docker logout

