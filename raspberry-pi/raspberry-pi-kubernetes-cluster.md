
# How to build a Raspberry Pi Kubernetes Cluster

This tutorial gives step-by-step instructions on building a Kubernetes cluster with 4 or 8 Raspberry Pis. It includes amazon links to all the hardware you'll need.

Why do you need a Raspberry Pi cluster. Clouds are expensive

## 1. Equipment List

1. a **[52pi Raspberry Pi Rack Case with 4 Slots](https://www.amazon.co.uk/gp/product/B07J9VMNBL/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1)** - **[or 8 slots](https://www.amazon.co.uk/gp/product/B085ZZV66P/ref=ox_sc_act_title_1?smid=A187Y4UVM6ZA0X&psc=1)**
1. **[Raspberry Pi 4 Model B with 4GB of RAM](https://www.amazon.co.uk/gp/product/B07TC2BK1X/ref=ppx_yo_dt_b_asin_title_o03_s01?ie=UTF8&psc=1)** (either x4 or x8)
1. **[128 GB SanDisk Extreme Pro SD Card](https://www.amazon.co.uk/SanDisk-Extreme-SDXC-Memory-Class/dp/B07H9DVLBB/ref=sr_1_3_mod_primary_new?crid=3UXMS1ANDWP88&dchild=1&keywords=sandisk%2Bextreme%2Bpro&qid=1613854314&sbo=RZvfv%2F%2FHxDF%2BO5021pAnSA%3D%3D&sprefix=sandisk%2Caps%2C175&sr=8-3&th=1)** (either x4 or x8)
1. **[Micro HDMI to HDMI Cable](https://www.amazon.co.uk/gp/product/B08DY45G2D/ref=ox_sc_act_title_1?smid=A1ED6JEOF71PSI&psc=1)** - two recommended
1. **[NetGear 8-Port Gigabit Ethernet Switch](https://www.amazon.co.uk/gp/product/B017LWQIZA/ref=ox_sc_act_title_4?smid=A3P5ROKL5A1OLE&psc=1)**

For the Official USB-C Power Supply for Raspberry Pi 4 you'll need to get 4 or 8 of the

1. **[UK Power Supply](https://www.amazon.co.uk/gp/product/B07VKF1CK8/ref=ox_sc_act_title_1?smid=A2717MKXZVZ1ZW&psc=1)**
1. **[EU Power Supply](https://www.amazon.co.uk/gp/product/B07TZ89BT7/ref=ppx_yo_dt_b_asin_title_o03_s00?ie=UTF8&psc=1)**

You will also need

1. a Laptop with a SD Card slot
1. many short high speed ethernet cables to connect your Pis to the Ethernet switch
1. an ethernet cable to connect the switch to your ISP's hub


## 2. Install Ubuntu Server on the SD Card

Use this **[Ubuntu tutoriall to write Ubuntu Server on the SD card](https://ubuntu.com/tutorials/how-to-sdcard-ubuntu-server-raspberry-pi#1-overview)**.

- take the SD card out - put it in the bigger case and slot it in
- download RPI imager from Raspberry Pi
- select the lastest **64 bit Ubuntu Server Operating System**
- select the SD card list and image it
- now place the little SD card into a Raspberry Pi and repeat

## 3. Build the Raspberry Pi Rack

This **[official YouTube video](https://www.youtube.com/watch?v=Fq2NmbZIl9c&t=364s)** takes you throught the steps to build the Raspberry Pi rack.


