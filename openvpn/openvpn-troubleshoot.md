
# OpenVpn Client/Server Troubleshooting

OpenVpn and networking go hand in glove so many of the network troubleshooting tactics apply just as well for openvpn client or server troubleshooting.

## Cannot Access Internet with OpenVPN Connection

If the VPN server is configured with an internet gateway you will be able to access the internet through your VPN connection (a great way to be German (eu-central-1), Irish (eu-west-1) or whoever).

If the VPN server does not allow this (more secure), your net access will simply stop while the VPN is on.

You can address this issue in two ways.

1. add **redirect-gateway autolocal** to the **.ovpn file**
2. in **openvpn up** use the **--redirect-gateway autolocal** switch
3. before **nmcli up** run the below **connection modify** command.

### IPV4 Never Default | Connection Modify

```bash
nmcli connection modify <<connection-name>> ipv4.never-default true   # use the VPN only for VPN addresses
nmcli connection modify <<connection-name>> ipv4.never-default false  # use the VPN for all internet traffic
```

## OpenVpn Logs

<strong>
<blockquote>
IMPORTANT - if internet access is disturbed when using the VPN connection try switching off the wired and (perhaps the) wireless connections first. Script them to **go down before** the VPN is switched on and to **come back up after** the VPN is switched off.
</blockquote>
</strong>

### Tail Connection Related Logs

Before you issue network related commands it always pays to tail the relevant system logs - check with dummy runs and then order /var/log by date to see what changed.

```bash
cd /var/log                               # go to logs directory
sudo tail -F syslog auth.log kern.log     # Tail important log destinations
```

If /var/log/openvpn is empty the syslogs are the next best thing.

A good **/var/log troubleshooting tactic** is to

- run the VPN
- go to **/var/log** and order by time - [s] in the emacs (dired) directory editor
- note the changed files since running the VPN (in step 1)
- execute the below tail commands
- run the VPN again and look

```bash
cd /var/log/
tail -F syslog auth.log kern.log
```

The above assumes that syslog, auth.log and kern.log changed since the VPN started.

## OpenVpn Route | tun0 | tun1

```bash
route      # print out the routing table
ifconfig   # ifconfig confirms the routes
```

The routing table lists the gateways that IP packets are routed through.

Look for **tun0** or **tun1** interface. Also below shows a specific route for trafic to **ec2-42-118-127**. The tun1 route tells us that addresses in the **174.37.142.0 range** are now considered to be on our local LAN.

<pre>
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         _gateway        0.0.0.0         UG    100    0        0 enp0s31f6
ec2-42-118-127- _gateway        255.255.255.255 UGH   100    0        0 enp0s31f6
link-local      0.0.0.0         255.255.0.0     U     1000   0        0 enp0s31f6
174.37.142.0    0.0.0.0         255.255.248.0   U     50     0        0 tun1
192.168.0.0     0.0.0.0         255.255.255.0   U     100    0        0 enp0s31f6
_gateway        0.0.0.0         255.255.255.255 UH    100    0        0 enp0s31f6
</pre>

## find vpn related files

This command finds files with **vpn** in (either) their path (or name) in which the text **staging** occurs.

```bash
sudo find . -path "*vpn*" -type f -exec grep -i "staging" {} +
```

## OpenVpn Troubleshooting Commands

![openvpn](/media/openvpn-logo-pan.png "openvpn connections logo")

When OpenVpn fails to connect - these commands get you back on track.

```bash
ifconfig                        # look at the network interfaces
sudo netstat -lntp              # which services occupy the ports
service openvpn status          # status of the openvpn service
service --status-all            # which services are (or have been) running
find . -name *.md -path "*vpn*" # look for vpn (markdown) documentation
```

## Is openvpn server at 1194 reachable?

To check if the openvpn server is reachable at port 1194 find its IP address. It will be in the ovpn.conf file.

```bash
echo "abcd" | netcat -u -v -w2 xx.xx.xx.xx 1194  #
echo $?
```

We want the **openvpn connection** to succeed. And the command should return 0, not 1.

```
Connection to xx.xx.xx.xx 1194 port [udp/openvpn] succeeded!
0
```

If not we know we have a problem reaching the VPN server itself.

## Is TLS Certificate Okay?

You can check the status of the tls-auth certificate file.

```bash
openvpn --test-crypto --secret /etc/openvpn/xxxx.tls-auth.pem 
```

It should print out quite a few line like the below ending with a statement of success.

```
Fri Jul 13 03:43:41 2018 library versions: OpenSSL 1.1.0g  2 Nov 2017, LZO 2.08
Fri Jul 13 03:43:41 2018 OpenVPN 2.4.4 x86_64-pc-linux-gnu [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on Feb 10 2018
Fri Jul 13 03:43:41 2018 WARNING: INSECURE cipher with block size less than 128 bit (64 bit).  This allows attacks like SWEET32.  Mitigate by using a --cipher with a larger block size (e.g. AES-256-CBC).
Fri Jul 13 03:43:41 2018 OpenVPN crypto self-test mode SUCCEEDED.
```

## Start OpenVPN Service | Learn about service

This very basic command attempts to open a tunnel. It gives warnings about plain text and man in the middle but the important part is that it validates whether a server is listening at the other end.

```bash
sudo openvpn \
--dev tun \
--proto tcp-client \
--remote 52.58.168.166;
```


--proto tcp-client \


```bash
sudo openvpn \
--dev tun \
--secret auth-private-key.pem \
--remote xx.xx.xx.xx \
--verb 7;
```




## Run openvpn from command line | openvpn in docker

openvpn can be run using the network manager desktop gui or the command line.

pgrep -l vpn


### openvpn docker container

Using docker to run an openvpn client is priceless as your laptop evolves but you need to

- release software to production systems
- troubleshoot at a moments notice (day or night)
- do experimental things on your workstation

The docker openvpn client strategy is map the certificates and keys to your workstation with the docker run command. 