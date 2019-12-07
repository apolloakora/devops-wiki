# Docker Frequently Asked Questions

## How can <code>git clone</code> run every time in Dockerfile without disabling cache?

Using ***<code>git clone</code> in a Dockerfile during a docker build is a common use case.***

>***If I use the image cache*** git clone odes not run (so no fresh copy of repo)!
>***Using <code>--no-cache</code>*** makes the **docker build slow** - aasregenerating each layer.

### Solution - use the cache, put git clone last, and stamp the cloned folder

- put `git clone` as **far down in the Dockerfile** as possible.
- stamp the target repository folder name as shown below.

**`git clone https://www.eco-platform.co.uk/content/devops.wiki.git wiki.18036.1528`**

Now the cache will be used for almost all Dockerfile layers.
And the new ***wiki.18036.1528*** timestamp guarantees that **docker will run the git clone again**.

![docker logo](/media/docker-logo-horizontal.png "Docker Dockerfile Docker Compose logo")
