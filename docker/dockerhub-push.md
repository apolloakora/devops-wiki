# How to Push an Image to DockerHub

The simple way if you have an account with dockerhub is to use the docker login command. My username is ***apolloakora***


```bash
docker login --username=apolloakora
docker tag img.platform apolloakora/img.platform
docker push apolloakora/img.platform
```

Enter the password when prompted.

The ***docker tag*** is extremely important. Tagging the image ***maps*** the local name with its repository coordinates which are a composition of the username and the repository id (in this case eco).

This image will be called platform in docker hub after the push.

After the login you simply push the image into the repository you have setup. I have a repository called eco ***apolloakora/eco*** and have pushed the docker img.platform image into it.

Optionally you can specify a tag using a ***colonic separator***.

```bash
docker push img.platform:v17342.1428
```


