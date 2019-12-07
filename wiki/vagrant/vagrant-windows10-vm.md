
<!--
{
  "keywords": [ "virtualbox", "oracle virtualbox", "windows 10" ],
  "original-name": "installing-windows10-on-vagrant-vm"
}
-->

# VirtualBox | A Windows10 Base Box

<img id="right40" src="/media/virtualbox-logo-square.png" title="Oracle VirtualBox Logo" />

***You want a Windows10 virtual machine (especially if you love linux) and even when running Windows on your workstation.*** Why? You can

- coccoon your software development IDE stack
- trial suspicious software and examine its behaviour
- roll back if things don't go to plan

Even if you love linux there will be times when you are sent an Office document and you need to fire up Windows for a limited time.

## What is a Base Box?

When you create a base box - all you need is one line in your Vagrantfile locating the box.

VirtualBox will run your Windows10 base  (box) image and everything you installed during basebox setup will be perfectly preserved and available at the drop of a hat.

## VirtualBox | VirtualBox | VirtualBox

VirtualBox can run the image on its own and you can manipulate behaviour using the **VBoxManage** commands. **Vagrant can be handy (as middlemen invariably are)** - but it isn't strictly required.


## How to Create a Windows10 BaseBox

Refer to the PDF in the technology library for full instructions.

<strong>
<pre>
platform.services/vagrant/vagrant.windows10.virtualbox.vm.pdf
</pre>
</strong>

