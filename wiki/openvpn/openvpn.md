
# OpenVpn | Network Manager | nmcli

A **hands-free OpenVPN client** is a powerful capability enabling you to script connection import, run, stop and delete. As a **DevOps Engineer** you can script releases and even run them within **Docker** containers for **ultimate readiness, robustness and repeatability.

**nmcli** stands for **Network Manager Command Line Interface** and its man (manual) page documentation can be found below.

![openvpn](/media/openvpn-logo-pan.png "openvpn connections logo")

#### Visit the [nmcli official command documentation](https://developer.gnome.org/NetworkManager/stable/nmcli.html)

## The .ovpn file | Prerequisite

To add an openvpn connection you'll need an OVPN file typically gained from the OpenVPN user setup gui followed by a download. You can also export it or better still import it from your **credentials safe**.

## Install Network Manager

Installing network manager on Ubuntu 16.04, 17.10 and 18.04 couldn't be easier.

```bash
sudo apt-get install --assume-yes network-manager-openvpn-gnome openvpn-systemd-resolved
```

We've used apt-get to install the **network manager** tooling which integrates seamlessly with **OpenVPN**.

## Import Ovpn File | Configure Connection | Delete Connection

So now we create an OpenVPN network connection by importing from an **ovpn** file.

The name of the ovpn file (less the extension) becomes the name of the connection `<<name>>`. Note the **parameter path to the ovpn file** in the connection import command.

```bash
sudo nmcli connection import type openvpn file <<name>>.ovpn  # import connection
nmcli connection modify <<name>> ipv4.never-default true      # only if necessary
nmcli connection modify <<name>> +vpn.data username=<<user>>  # put vpn username
sudo nmcli connection reload <<name>>                         # reload the config
nmcli connection modify <<name>> +vpn.data password-flags=0   # can read password
sudo service network-manager restart                          # restart manager
nmcli con down id <<name>>                                    # tear connection down
nmcli connection delete <<name>>                              # delete connection
```

Note that we've issued the **nmcli connection delete command** to remove the created and imported VPN connection.

## OpenVPN Passwords | Hands Free Configuration

These are the **automation steps for hands free password** configuration.

- use your credentials manager (like DevOps Safe) to write one line into your short-lived credentials directory
- the line format is **<<name>>.psk:secret12345**
- provide password file path in **up** command with switch **passwd-file**

```bash
nmcli connection up <<name>> passwd-file /path/to/file
```

You could try and fool network manager by running round to its backend and insert the password into **/etc/NetworkManager/system-connections/<<name>>** but that **requires sudo** which complicates matters. Furthermore you'd have to restart Network Manager can destabilize this key workstation subsystem.

## nmcli openvpn | start and stop vpn connections

Use the network manager command line interface (nmcli) tool to connect up and tear down VPN (and other) network connections.

### nmcli connect commands

In keeping with '''docker up''', **terraform up** and '''vagrant up''' traditions, the **nmcli connection up** is the **meat** in the vpn connection sandwich.

```bash
nmcli con                                               # list my network connections
nmcli connection up <<name>> passwd-file /path/to/file  # bring up a given connection
nmcli con down id <<name>>                              # tear down the connection
```

When you start and stop the VPN connections the command echoes the below.

```
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/10)
Connection '<<connection>>' successfully deactivated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/10)
```

## nmcli | to query network connections

We can find a lot of information using the nmcli command.

```bash
nmcli device                                    # list the known net devices
nmcli connection show <<name>>                  # show the connection attributes
nmcli connection show --active                  # shows the active connections
nmcli general status                            # status of the network manager
nmcli general permissions                       # what permissions do I have?
nmcli general logging level DEBUG domains IP4   # Change log level for IP4 domains
nmcli general logging level DEBUG domains ALL   # Change log level for all domains
```

This listing demonstrates the key connection properties.

<pre>
NAME                UUID                                  TYPE      DEVICE    
L39-Member          50a56bf1-06a7-4b5a-85a0-69b20f06e7ef  wifi      wlp4s0    
Wired connection 1  31221dc7-9a1d-3d98-b472-4cb55e53bbbd  ethernet  enp0s31f6 
</pre>

## nmcli | connection types

Note that we can use egrep to drill into various connection types.

```bash
nmcli connection show <<name>> | egrep -i 'IP4|IPV6|ipv4'
```

## Ping the OpenVPN Server

We can call out to the server using ping.

```bash
nmcli connection show <<name>> | egrep -i 'IP4'
## Now look at the ADDRESS server - can you ping it?
ping -c 4 xxx.xx.xxx.x
```


## OpenVPN and NetworkManager

The NetworkManager OpenVpn client puts your **plaintext VPN password** in a file at **/etc/NetworkManager/system-connections/<<name>>**.

The ideal for an OpenVpn client is to

- install it and **run it via the command line**
- run it inside an immutable docker container
- inject certs, keys and passwords in securely
- employ profiles to select the correct VPN


## OpenVpn Resources

<img id="left40" src="/media/openvpn-logo-square.png" title="OpenVPN, Network Manager and nmcli" />

- **[[OpenVPN Troubleshooting Commands|openvpn troubleshoot]]**
- **[[Maximum Concurrent Connections Exceeded Error|openvpn maximum concurrent connections exceeded]]**
- **[[OpenVpn on DevOps Wiki|openvpn]]**


### OpenVPN in Docker | Why It Makes Sense

Docker is vital if you use VPN to **release software** or **troubleshoot production issues at a moment's notice**. Your laptop is a pet (not a cow) and it will have good days and bad days. Docker seals away the VPN and is great for deploying release scripts - you could even use Kubernetes to execute them.

Make sure you don't bake VPN certs, keys and passwords into the image. Use Docker volumes or inject them in as environment variables with the Docker run command.

