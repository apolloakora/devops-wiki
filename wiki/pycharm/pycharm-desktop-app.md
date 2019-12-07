
# PyCharm Desktop App | JetBrains (IntelliJ)

There are many angles to PyCharm - so visit

- [[PyCharm Desktop App]] - to auto install and configure it on your workstation
- [[PyCharm Python IDE]] - for Python software development, machine learning and scripting aspects
- [[PyCharm Keyboard Shortcuts]] - to up your productivity around the PyCharm IDE and eco-system


## Install PyCharm on Ubuntu 18.04 Bare Metal

We could install IntelliJ on our workstation in these four ways

- by an unzipping and uncompressing a tar.gz file
- by adding the unofficial getdeb repository then using apt-get
- with the snap package dependency management tool
- by building it from scratch through the ubuntu make facility


Using ubuntu-make is perhaps the simplest and best.

``` bash
sudo add-apt-repository ppa:ubuntu-desktop/ubuntu-make
sudo apt-get update
sudo apt-get install --assume-yes ubuntu-make
umake ide pycharm
```

### Configure PyCharm

The steps to get PyCharm going are to

- select the theme (Darcular or ...)
- opt for a "charm" script to launch files and projects at /usr/local/bin/charm
- opt for the markdown and the bash plugins

With that basic setup the next step is to import Pycharm's settings and also create the necessary repositories - then open PyCharm.




### PyCharm | Import Settings





### PyCharm | Export Settings

