
# How to Mount /var/lib/docker on a Separate Volume

Servers running dockerized services eat through disk space on **`/var/lib/docker`** and it pays for overall system health to mount this crucial folder onto an external filesystem sporting at least one terrabyte (1TB) of disk space.

Upon accessing the machine these are the steps to mounting /var/lib/docker onto the 1TB volume. This must be done before installing docker.

### Initialize the system

```
sudo apt-get update && sudo apt-get --assume-yes upgrade
sudo apt install --assume-yes emacs
git clone http://gitlab/infrastructure/app-deployment.git
dmesg | grep SCSI
```

### Partition the Disk

To partition the disk we use **`sudo fdisk /dev/sdc`**

As and when prompted

- **`n`** to add a new partition
- **`p`** to make it a primary partition
- accept the default three times
- **`w`** to write the new partition



### Mount /var/lib/docker to the partition

The mkfs command writes the ext4 file system to the partition.

```
sudo mkfs -t ext4 /dev/sdc1
sudo mkdir -p /var/lib/docker
sudo mount /dev/sdc1 /var/lib/docker
df -h
```

The df command should now show /var/lib/docker mounted onto /dev/sdc1


### Changing /etc/fstab

When the machine restarts we need it to automatically re-mount the /var/lib/docker directory. Enter **`/etc/fstab`**

- **`sudo fdisk -l`**  # to see which device the big volume is on = for ecample /etc/sdc1
- **`sudo -i blkid`**  # to see for what the UUID is (for say /etc/sdc1)

Now we can put the UUID like you see in the last line of this example into **`/etc/fstab`** and take care **not** to transfer the double quotes.

```
A# CLOUD_IMG: This file was created/modified by the Cloud Image build process
LABEL=cloudimg-rootfs	/	 ext4	defaults,discard	0 0
LABEL=UEFI	/boot/efi	vfat	defaults,discard	0 0
UUID=cbcb3ec8-1666-4efc-8c3c-40c7cd2a646b  /var/lib/docker   ext4   defaults,nofail   1   2
```

Once done reboot the machine with **`sudo shutdown -r now`** and then use **`df -h`** to check that /var/lib/docker was mounted correctly.
