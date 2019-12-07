
# MTPFS | Mount Samsung Phone Drive on Ubuntu

To Connect to Samsung S8 (or any other Android Device) - on Ubuntu

Most times it will be here
cd /run/user/1000/gvfs/

Then something like this
cd /run/user/1000/gvfs/mtp:host=%5Busb%3A001%2C015%5D
(but changes)

olooks like this
mtp://[usb:001,010]/Phone/OSX

mtp:host=%5Busb%3A001%2C015%5D



Do ls hardware then scroll to usb section it may look like this on one of them.
sudo lshw

              *-usb:0
                   description: Generic USB device
                   product: SAMSUNG_Android
                   vendor: SAMSUNG
                   physical id: 1
                   bus info: usb@1:1
                   version: 4.00
                   serial: 9889db344b4436374d
                   capabilities: usb-2.10
                   configuration: driver=usbfs maxpower=64mA speed=480Mbit/s


very useful
sudo apt-get install mtpfs
mtp-detect



if open in nautilus
lsof -c nautilus


Try these commands

sudo fdisk -l
sudo cat /etc/fstab

