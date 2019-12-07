
# Refresh Gollum Wiki

Refreshing your ***gollum wiki** can be done in 3 ways.

[[_TOC_]]

## ***Git Pull*** to Refresh Gollum Wiki

***<code>git pull origin master</code>***

```
git clone [[https://www.eco-platform.co.uk/content/devops.wiki]]
```

With our design (view with git clone), a git pull will ***refresh***

 - the markdown pages
 - changes made to the **mustache** templates
 - any css (stylesheet) changes 
 - additions to any images store in the repository

To keep things lightweight it is prudent to keep larger images, documents and media resources *externally* (like in an S3 bucket).

## ***Git Pull*** from Docker Container Host

If you are running Gollum in a Docker container - the git pull refresh it done via a docker exec command.

```
sudo docker exec -it ctr.gollum.wiki bash -c "echo; git pull origin master; echo;"
```



