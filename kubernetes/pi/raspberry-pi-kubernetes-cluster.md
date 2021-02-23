
# How to build a Raspberry Pi Kubernetes Cluster

This tutorial gives step-by-step instructions on building a Kubernetes cluster with 4 or 8 Raspberry Pis. It includes amazon links to all the hardware you'll need.

Why do you need a Raspberry Pi cluster. Clouds are expensive


## 1. Equipment List

1. a **[52pi Raspberry Pi Rack Case with 4 Slots](https://www.amazon.co.uk/gp/product/B07J9VMNBL/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1)** - **[or 8 slots](https://www.amazon.co.uk/gp/product/B085ZZV66P/ref=ox_sc_act_title_1?smid=A187Y4UVM6ZA0X&psc=1)**
1. **[Raspberry Pi 4 Model B with 4GB of RAM](https://www.amazon.co.uk/gp/product/B07TC2BK1X/ref=ppx_yo_dt_b_asin_title_o03_s01?ie=UTF8&psc=1)** (either x4 or x8)
1. **[128 GB SanDisk Extreme Pro SD Card](https://www.amazon.co.uk/SanDisk-Extreme-microSDXC-Adapter-Performance/dp/B07G3H5RBT/ref=sr_1_3?crid=4MJLDBM9IVLL&dchild=1&keywords=extreme+pro+micro+sd&qid=1614018535&sprefix=extreme+pro+mi%2Caps%2C168&sr=8-3)** (either x4 or x8)
1. **[Micro HDMI to HDMI Cable](https://www.amazon.co.uk/gp/product/B08DY45G2D/ref=ox_sc_act_title_1?smid=A1ED6JEOF71PSI&psc=1)** - two recommended
1. **[NetGear 8-Port Gigabit Ethernet Switch](https://www.amazon.co.uk/gp/product/B017LWQIZA/ref=ox_sc_act_title_4?smid=A3P5ROKL5A1OLE&psc=1)**
1. **[short 0.5m ethernet cable](https://www.amazon.co.uk/gp/product/B07YTXCTY5/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1)** from Pi to Ethernet Switch (either x2 or x3)
1. **[medium to long ethernet cable](https://www.amazon.co.uk/gp/product/B0843SBMDD/ref=ppx_yo_dt_b_asin_title_o04_s00?ie=UTF8&psc=1)**  to connect the Ethernet Hub to your ISP's Hub

For the Official USB-C Power Supply for Raspberry Pi 4 you'll need to get 4 or 8 of the

1. **[UK Power Supply](https://www.amazon.co.uk/gp/product/B07VKF1CK8/ref=ox_sc_act_title_1?smid=A2717MKXZVZ1ZW&psc=1)**
1. **[EU Power Supply](https://www.amazon.co.uk/gp/product/B07TZ89BT7/ref=ppx_yo_dt_b_asin_title_o03_s00?ie=UTF8&psc=1)**

You will also need a **Laptop with a SD Card** slot.


## 2. Install Ubuntu Server on the SD Card

Use this **[Ubuntu tutoriall to write Ubuntu Server on the SD card](https://ubuntu.com/tutorials/how-to-sdcard-ubuntu-server-raspberry-pi#1-overview)**.

- take the SD card out - put it in the bigger case and slot it in
- download RPI imager from Raspberry Pi
- select the lastest **64 bit Ubuntu Server Operating System**
- select the SD card list and image it
- now place the little SD card into a Raspberry Pi and repeat


## 3. Build the Raspberry Pi Rack

This **[official YouTube video](https://www.youtube.com/watch?v=Fq2NmbZIl9c&t=364s)** takes you throught the steps to build the Raspberry Pi rack.


## 4. Connect the Raspberry Pi

With the SD card in the first Raspberry Pi it is time to wire it up. The steps are

1. connect the micro HDMI to a monitor
1. connect the a keyboard to the USB slot
1. put a short ethernet cable between Pi and Ethernet Hub
1. connect Ethernet Hub to ISP's Hub (only once)
1. connect Pi to power supply


## 5. Initial Raspberry Pi Ubuntu Configuration

When the Pi comes on login with username - **`ubuntu`** and password - **`ubuntu`** then change the password. Then proceed to

1. **`sudo apt update`** - update the list of package repositories
1. **`sudo dpkg --configure -a`** - get the package manager ready
1. **`sudo apt upgrade --asssume-yes`** - upgrade the system packages
1. check SSH server is running - **`sudo systemctl status ssh`**
1. **`ip a`** - record the IP address of this pi

## 6. SSH in to Finish Initial Raspberry Pi Configuration

Go to the terminal of your Linux/Mac laptop and ssh in like this.

**`ssh ubuntu@<IP-Address>`**

Enter your password and you are in. Complete the configuration with these steps.

## 7. Set Passwordless Sudo

After these commands you won't need to type the password every time you run a command with sudo. To achieve this we modify the user and then assume root rather than just using sudo.

```bash
sudo usermod -a -G sudo $USER
sudo su root
cd; pwd;
echo $SUDO_USER
sudo echo "$SUDO_USER ALL=NOPASSWD: ALL" >> /etc/sudoers
```

Now you need to exit and then pull up a new terminal.

## 8. Change Raspberry Pi Hostname

A network with 8 machines called **`ubuntu`** is disconcerting! Set the hostname to uniquely identify the rack and the machine in the rack (1 is the top, 4 (or 8) is the botom).

- **`pi-r1d1`** - is the hostname of the top machine in rack one
- **`pi-r2d8`** - the eighth (bottom) machine in the second rack

1. **`sudo apt install emacs --assume-yes`** - install emacs editor
1. **`hostnamectl`** - report the current hostname and machine ID
1. **`sudo hostnamectl set-hostname pi-r1d4`** - change the hostname
1. **`sudo emacs /etc/hosts`** - edit the `/etc/hosts` file
1. add this **`127.0.0.1 pi-r1d4`** as the second line
1. **`sudo emacs /etc/cloud/cloud.cfg`** - edit the cloud config
1. `preserve_hostname: true` - change flag from false to true
1. **`sudo shutdown -r now`** - reboot the raspberry pi

Now on your laptop add a mapping in **`/etc/hosts`** linking the pi's IP address and its new hostname. This method doesn't scale - if you run more than 5 or 6 machines you should consider setting up a dedicated DNS server on one of your Raspberry Pis.

Test connectivity with **`ping pi-r1d4`**

## 9. Setup SSH Public/Private Keypair

**Ansible** the configuration management tool will be used to setup our Kubernetes cluster. Ansible requires a private key and needs our Raspberry Pi machines to have the corresponding authorized public key.

Use **`ssh-keygen`** or **`safe keygen`** to produce your keypair.

1. **`ssh ubuntu@pi-r1d4`** - ssh in with password
1. **`echo "<public key text>" >> ~/.ssh/authorized_keys`** - add public key
1. **`cat ~/.ssh/authorized_keys`** - assert public key in authorized_keys
1. **`exit`** - exit the ssh session

Finally we place the private key equivalent inside the .ssh folder and connect **securely without a password**.

1. **`safe write private.key --folder=~/.ssh`** - write the private key into **`~/.ssh`**
1. **`ssh ubuntu@pi-r1d4 -i ~/.ssh/services.cluster.pi-r1d4.pem`** - ssh in securely
