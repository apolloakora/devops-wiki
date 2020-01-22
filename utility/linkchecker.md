
# linkchecker | check website links

With **one simple docker run statement** you can link check any website, git repository or wiki.

## robots.txt | link check pre-conditions

Before running the linkchecker ensure that a **robots.txt** file exists at the website root otherwise link checking will not happen (to prevent abuse of the link checker).

Follow **[instructions here](https://www.robotstxt.org/robotstxt.html)** configure robots.txt to accept just some robots (like Google) or allow link checking from a sub location tree.

```
User-agent: *
Disallow:
```

## how to run the link checker

#### `docker run --env LINK_CHECKER_URL=https://www.devopswiki.co.uk/ devops4me/linkchecker`

The command link checks the **[devopswiki.co.uk](https://www.devopswiki.co.uk)** website. Add **`--network host`** to the docker run command to check a docker service running on the same host.

You can link check portions of websites by using the below urls.

```
https://dzone.com/articles/kafka-producer-and-consumer-example
https://www.devopswiki.co.uk/wiki/openvpn/openvpn
```

## Link Checker Configuration

The [linkcheckerrc configuration file](https://github.com/devops4me/docker-linkchecker/blob/master/linkcheckerrc) is placed in the .linkchecker folder off the home directory and drives the primary checking behaviour. The key linkchecker directives are stated here.

```
## ################################ ##
## Configure the linkchecker output ##
## ################################ ##

[output]
status=1   ; print status output
log=text   ; set the logging type
verbose=0  ; switch verbosity on or off
warnings=1 ; report warnings
quiet=0    ; set quiet mode

## ################################# ##
## Configure Link Checker Operations ##
## ################################# ##

[checking]
threads=10        ; the maximum number of threads
timeout=10        ; connection timeout in seconds
aborttimeout=300  ; grace period awaiting checks to finish after Crl-C
recursionlevel=7  ; the recursion depth to dig into
sslverify=1       ; verify the SSL certificates for https links
maxrunseconds=600 ; Stop checking new urls after these many seconds
maxnumurls=10000  ; maximum number of urls to check

maxrequestspersecond=30   ; max number of requests per second
allowedschemes=http,https ; allowed URL schemes
```

**Note that command line settings will always override those provided inside the linkcheckerrc configuration file.**

### Watch Successful Checks

Add **`--verbose`** to the command line to see the successful checks.

---

## local development | linkchecker

To locally develop the linkchecker or tweak the configuration, you can perform a docker build and a docker run from your local image.

```
git clone https://github.com/devops4me/docker-linkchecker
cd docker-linkchecker
docker build --no-cache --rm --tag img.linkchecker .
docker run                \
    --network host        \
    --env LINK_CHECKER_URL=http://10.152.183.167/ \
    img.linkchecker
```
