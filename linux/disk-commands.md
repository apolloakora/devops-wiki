
# Linux Disk | Mount and Unmount Drives | Shred Drive

In order to perform the automated workstation build we need to have access to an auth provider. This could be key pass, vaults and/or other services but we need to authenticate with the auth provider to.

Using a buddy system whence two or three office members authenticate the provision of tokens on a USB drive that are valid for a specific time and fit for a given purpose.

First insert the USB key into the drive and then look for its ***Device ID*** with the fdisk command.

``` bash
sudo fdisk -l
sudo mkdir /media/usb_drive
sudo mount -o rw,users,umask=000 /dev/sdb1 /media/usb_drive
ls -lah /media/usb_drive
```

Note that the -o rw,users,umask=000 is to enable write permissions. If you want to mount a drive as read only you can safely
omit this section.

**Note that FAT32 drives do not support permissions so attempts to add write permissions through chmod and chown will prove futile.**

## Unmount USB Key | Unmount Flash Drive

When you are done using the USB key you can unmount it with the below command.

``` bash
ls -lah /media/usb_drive
sudo umount /media/usb_drive
ls -lah /media/usb_drive
```
Looking at the drive before unmounting list the files - and then nothing.

