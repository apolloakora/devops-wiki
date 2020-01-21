# How to Install Vagrant and VirtualBox on Ubuntu

<img id="right30" src="/media/virtualbox-logo-square.png" title="Oracle VirtualBox Logo" />
Installing **HashiCorp's Vagrant** and ***Oracle's VirtualBox*** hypervisor takes just 3 commands as long as

+ you are using Ubuntu (Client or Server)
+ the **virtualization flag** in the **BIOS** is set
+ you are not using SecureBoot (home partition encryption)

If the above does not apply - read the key issues section to prep before installing Vagrant and VirtualBox.

## Install Vagrant and VirtualBox on Ubuntu

Our development workstation needs a bare metal installation of ***Vagrant and VirtualBox*** for maximum performance in order to emulate real ***container management systems***.

``` bash
sudo apt-get update && sudo apt-get --assume-yes upgrade
sudo apt-get install --assume-yes virtualbox virtualbox-dkms linux-headers-$(uname -r)
sudo dpkg-reconfigure virtualbox-dkms virtualbox
```

Do not install the Ubuntu vagrant because it is bug-ridden and simply will not work.

**[Download and Install Vagrant](https://www.vagrantup.com/downloads.html)**

Click on the **Debian** (64-bit) option and you should be given the choice to open the deb file with the installer. From there you click install and you are done.

(To automate the install use curl to get the deb file and install it as per the ubiquitous technique).


The above 3 commands take longer than you'd expect - but it's worth the wait!

![vagrant logo](/media/vagrant-logo-horizontal.png "HashiCorp Vagrant Logo")

## Smoke Test the Vagrant and VirtualBox Install

Once done, sanity check the install by asking for the versions.

``` bash
vagrant --version
VBoxManage --version
```

The replies should be similar to the below printout.

<pre>
Vagrant 1.8.1
5.0.40_Ubuntur115130
</pre>

## Verify the Vagrant and VirtualBox Install

```
vagrant init
vagrant up
```

To verify the Vagrant/VirtualBox duo is ready to rumble you run <code>vagrant init</code> and check for th existence of a newly created  Vagrantfile in the same folder.

Then a <code>***vagrant up***</code> command will get you going.

**[[Visit Key Vagrant Command List for more.|vagrant commands]]**


## Key Vagrant/VirtualBox Install Issues

If ***<code>codeVBoxManage --version</code>*** spits out the below error, check that ***virtualbox-dkms*** is installed and you have run the two ***<code>dpkg-reconfigure</code>*** commands.

> WARNING: The character device /dev/vboxdrv does not exist.
>          Please install the virtualbox-dkms package and the appropriate
>	   headers, most likely linux-headers-generic.


### Vagrant Install and Secure Boot Warning

Vagrant and Secure Boot cannot exist happily side by side. One needs 3rd party drivers whilst the other disallows their use.
If you must have both then a password is requested which you will have to then re-enter when rebooting the system.

The Secure Boot error says &raquo;

> Your system has UEFI Secure Boot enabled.
> UEFI Secure Boot is not compatible with the use of third-party drivers.
> The system will assist you in toggling UEFI Secure Boot. To ensure that this 
> change is being made by you as an authorized user, and not by an attacker, you 
> must choose a password now and then use the same password after reboot to 
> confirm the change.
> If you choose to proceed but do not confirm the password upon reboot, Ubuntu 
> will still be able to boot on your system but the Secure Boot state will not be 
> changed.
> If Secure Boot remains enabled on your system, your system may still boot but 
> any hardware that requires third-party drivers to work correctly may not be 
> usable.

### Rebooting after Secure Boot Warning

***If you chose to bypass Secure Boot you must reboot your system.***

You will then be asked for character 7 then 8 then ... etc of the password you gave.
Once that is entered you can opt to switch off SecureBoot whilst you use Vagrant.

### The VT-x is Disabled in the BIOS Issue

This error occurs only when Vagrant is actually using a Hypervisor (like VirtualBox) to create the Virtual Machine.

See build business websites for a discussion on this error.

<pre>
Stderr: VBoxManage: error: VT-x is disabled in the BIOS for all CPU modes (VERR_VMX_MSR_ALL_VMX_DISABLED)
VBoxManage: error: Details: code NS_ERROR_FAILURE (0x80004005), component ConsoleWrap, interface IConsole
</pre>

Once you've gone into the BIOS and reset the setting - you should then be able to use Vagrant.
