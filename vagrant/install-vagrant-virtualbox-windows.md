
# Install Vagrant / Oracle VirtualBox on Windows

Visit the how to [install chocolatey] use case. Once done use the same (or different) Powershell (as administrator) window to install virtual box. To do this

## Install VirtualBox

- **`choco feature enable -n allowGlobalConfiguration`**
- **`choco install virtualbox`**

In order to get VBoxManage on your path you will need to open up another shell. Get an ordinary shell with start button run and type cmd [Enter].

Then type in VBoxManage and you should get a flurry of command options. If you get the dreaded *"is not a recognized as an internal or external ..."* then start to check whether it is really installed and then look to put it on the path.


## Install Vagrant

Once VirtualBox is up and running we can turn our attention to installing vagrant.

- **`choco install vagrant`**

At this point you will need to reboot.



