
# Cloud Init | AWS

Cloud Init is enacted through a yaml configuration file typically called cloud-config.yaml that must begin with the line **#cloud-config**

### [The Cloud Init Documentation](https://cloudinit.readthedocs.io/en/latest/index.html)

**[[_TOC_]]**

## How to View Cloud Init Logs

    head 10 /var/log/cloud-init-output.log

Setup SSH keys and remember to open port 22 with an AWS security group. When you login you can view all cloud-init command logs piped to **stdout** and **stderr** from **`/var/log/cloud-init-output.log`**.

The logs will begin with the network configuration of the machine through the ethernet and loopback interfaces.

    ci-info: ++++++++++++++++++++++++++++++++++++++Net device info++++++++++++++++++++++++++++++++++++++
    ci-info: +--------+------+----------------------------+---------------+--------+-------------------+
    ci-info: | Device |  Up  |          Address           |      Mask     | Scope  |     Hw-Address    |
    ci-info: +--------+------+----------------------------+---------------+--------+-------------------+
    ci-info: |  eth0  | True |        10.197.5.255        | 255.255.240.0 | global | 06:49:04:84:28:fa |
    ci-info: |  eth0  | True | fe80::449:4ff:fe84:28fa/64 |       .       |  link  | 06:49:04:84:28:fa |
    ci-info: |   lo   | True |         127.0.0.1          |   255.0.0.0   |  host  |         .         |
    ci-info: |   lo   | True |          ::1/128           |       .       |  host  |         .         |
    ci-info: +--------+------+----------------------------+---------------+--------+-------------------+

