<img id="left30" src="/media/ubuntu-client-logo-square.png" title="Ubuntu Client Logo" />
#### An important lean principle states that if it hurts, do it often until finally, it is automated.

# Machine Setup for Devops (SRE) Engineers

The high level tasks are to

- install emacs and configure the theme
- setup password-less sudoer privileges
- **upgrade** the installed packages
- [install git] configuring the global user email and name
- [install docker] adding user to the docker group
- login to firefox and assume last known good configuration
- set firefox Ctrl-TAB behaviour and google.co.uk 4 Alt-Home
- install the safedb.net personal credentials database
- see [disk commands] to mount and unmount usb drives
- visit [install ansible] to setup and use configuration management
- use 4 raspberry pies to install a local kubernetes cluster
- install Jenkins locally to manage valuable transitions
- see **[raspberry pi setup]** for anomalous behaviour
- change screensaver settings to keep things running for one hour


## The First Steps (to this page)

The first steps to  building the machine is to

- choose a mininal ubuntu installation
- bring up firefox and set home page and new tab preferences
- login into your gmail account
- bring up a terminal and install emacs and git
- open emacs and set the default font to size 11
- `export GIT_SSL_NO_VERIFY=1` if necessary and clone content/devops.wiki
- then bring up this page and continue with the setup


## Sudoer User Setup

**Don't ask for the password every time we issue a sudoer command.**

```
sudo usermod -a -G sudo $USER
sudo su root
cd; pwd; echo $SUDO_USER
sudo echo "$SUDO_USER ALL=NOPASSWD: ALL" >> /etc/sudoers
exit; exit
```

## Install and Configure Core Tools

Install important packages like **tree** and **curl**.

```
sudo apt update && sudo apt --assume-yes upgrade
sudo apt install --assume-yes tree curl gnome-tweak-tool
```

Now go to "Tweaks" and

- set top bar to show date and day (as well as time)
- remove desktop icons
- opt for emacs keys from the get-go


## Configure the Git Repository Manager

```
git config --global user.email "apolloakora@gmail.com"
git config --global user.name "Apollo Akora"
git config --global core.pager cat
git config --global credential.helper store
```

## Install Adobe Flash Plugin for Firefox

If you install the more expansive IUbuntu 18.04 client you do not need to install Adobe - and it is better not to as the below setup could possible be responsible for freezing Ubuntu every so often.

Flash needs to be installed in order to use BBC iPlayer and other streaming sites. Ensure Firefox and/or Chrome are closed down before starting.

```bash
sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
sudo apt update
sudo apt --assume-yes upgrade
sudo apt --assume-yes install adobe-flashplugin
sudo apt-get --assume-yes install browser-plugin-freshplayer-pepperflash
```

Now startup your browsers.

[The above procedure was based on documentation here.](https://computingforgeeks.com/how-to-install-latest-adobe-flash-player-on-ubuntu-18-04-linux/)

## safedb.net | the safe personal database

Install the safedb.net credentials management software - a friend you can trust.

```
sudo apt install --assume-yes ruby-full xclip g++ make
sudo chown -R $USER:$USER /var/lib/gems
sudo chown -R $USER:$USER /usr/local/bin
sudo chown -R $USER:$USER /usr/local/lib
gem install safedb
echo "export SAFE_TTY_TOKEN=\`safe token\`" >> ~/.bash_aliases
source ~/.bash_aliases
printenv | grep SAFE
```

The printenv command should fling something like this.

**`SAFE_TTY_TOKEN=4yAMX2L9XxxwsTvDP%3JAjbls5yV2u0kOaL4qfqpju5JzR1biO8jbNddOCIii@wz03GeNs0BFcBASw1MBuhX4%626hSCyEiJaXxkQ1h3wDZyY4QK3g0LEKWb@UWBFzuoOH/rbEqehldaRhx0cew3EX01`**

From here vist **[safe usage documentation](https://github.com/devops4me/safedb.net.git)** on how to create a book and add credentials to it.

## safedb development environment

### install safe and clone the github repositories

### *pre-condition*

- the safe personal database gem has been installed as described above
- git is installed and both user.name and user.email globally configured
- opened the **github/devops4me** safe chapter/verse with private key

### *flow of events*

Here we install the gem with the development dependencies which requires that we install **`libicu-dev`**. We must set the private key that allows us to commit to the safedb.net github repository **and** the credential token for **[pushing the gem into rubygems.org](https://rubygems.org/gems/safedb)**.

```
sudo apt install --assume-yes libicu-dev
gem install safedb --dev
gem install bundler gem-release yard
mkdir -p ~/assets/projects; cd ~/assets/projects
git clone https://github.com/devops4me/safedb.net.git safedb.net; cd safedb.net
git remote -v
git remote set-url --push origin git@safedb.code:devops4me/safedb.net.git
yard config --gem-install-yri
rake install
```

### write ssh keys and rubygem credentials


```
sudo systemctl enable ssh   # setup ssh
mkdir -p ~/.ssh             # create .ssh if need be
safe at github/devops4me
safe write github.ssh.config
safe write safedb.code.private.key
safe write safedb.crypt.private.key
safe write devops4me.code.private.key
chmod 600 *.pem
safe at rubygems.org/do4me
cd ~/.gem
safe write rubygems.org.credentials
chmod 0600 ~/.gem/credentials
```

### safedb gem release

You can **release the safedb gem** once the ability to ssh push to git has been acquired. The **`~/.gem/credentials`** file containing the rubygems.org token must exist.

### `gem bump patch --tag --push --release --file=$PWD/lib/version.rb`

This command bumps up the **patch version** of the gem, tags it, pushes the version change and the tags and then releases to rubygems.org.


## Google Chrome Install

```bash
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
sudo apt-get install --assume-yes google-chrome-stable
```
## Audio and Music Players

For playing Samsung S8 recordings, mp4 videos, mp3 music files and more.

```
sudo apt-get --assume-yes install vlc browser-plugin-vlc
sudo apt-get --assume-yes install gstreamer1.0-plugins-bad
```


## Change emacs cursor color

To change the emacs cursor color add the following **lisp** to the end of the **`~/.emacs`** file.

```lisp
; Set cursor color to white
(set-cursor-color "#ff4444")
```

Then perform an **`alt-x load-file`** and enter the **`~/.emacs`** path.

## installing other packages

It is very likely you will want to install other packages so it pays to visit

- **[install terraform]**


# Installing Favourite Projects

It pays to clone your favourite git projects right from the get-go.

```
git clone 
```

## Mount Samsung Phone as a Local Drive in Ubuntu

Achieve this, and you'll be able to save your frontend safe files on the phone rather than a USB key. You will almost always have your phone with you. With safe - you can also back this up just in case you lose your phone.

```
sudo apt --assume-yes install libmtp-dev mtp-tools
```

The below example output tells us it has found a **Samsung Galaxy**.

```
Listing raw device(s)
Device 0 (VID=04e8 and PID=6860) is a Samsung Galaxy models (MTP).
   Found 1 device(s):
   Samsung: Galaxy models (MTP) (04e8:6860) @ bus 1, dev 6
Attempting to connect device(s)
ignoring libusb_claim_interface() = -6PTP_ERROR_IO: failed to open session, trying again after resetting USB interface
LIBMTP libusb: Attempt to reset device
ignoring libusb_claim_interface() = -6LIBMTP PANIC: failed to open session on second attempt
Unable to open raw device 0
OK.
```

