

# How to Configure a Raspberry Pi

Visit [machine setup] for general Linux setup commands. This document concentrates on specific anomalies presented by the Raspberry Pi.

You can install a **headless rasberry pi** (server) or one with graphical user interface (client).

## SSH Setup from Raspberry Pi SD Card

For a headless rasberry pi, use another machine to put a file named ssh on the boot partition of the SD card. On bootup SSH is enabled and the file deleted.

If raspbian is loaded onto a blank SD card, the boot partition is the smaller of the two.

## Setup SSH Client and Server

We need **ssh** to connect to and from the rasberry pi in a secure manner.

```
sudo systemctl enable ssh
mkdir -p ~/.ssh
```