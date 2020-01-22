
# Python Software Development

Python's eco-system will soon surpass Java to be the largest ever seen for a programming language. To see the many Pythonic angles visit

- [[PyCharm Desktop App]] - to auto install and configure it on your workstation
- [[PyCharm Python IDE]] - for Python software development, machine learning and scripting aspects
- PyCharm Keyboard Shortcuts - to up your productivity around the PyCharm IDE and eco-system


## Install Python 2 and its famous pip installer (package manager).

This is now oldschool (legacy) so for greenfield projects use the newer python3 eco-system.

```bash
sudo apt-get install --assume-yes python-pip
pip --version
pip install awscli --upgrade --user
sudo pip install awscli --upgrade pip
```

## Python 3 | Install and Configure

Python3 is stable and new apps should be built with it. It however is incompatible with Python2 but the major operating systems now ship with both - so no need to install them. The corresponding tools are python3 and pip3.

``` bash
pip3 --version # => pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.6)
sudo apt-get install --assume-yes build-essential libssl-dev libffi-dev python-dev
python3 -V     # => Python 3.6.5
sudo apt-get install --assume-yes python3-pip
```
