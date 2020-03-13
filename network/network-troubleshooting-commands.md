
# Linux Network Troubleshooting Commands

There is a rich tapestry of Linux commands that give you insight on networks that link machines, data centres, clouds, intranets, extranets and the entire internet.

## telnet

**`telnet`** allows us to connect (send a request) to a http web server and examine the response.

```
telnet google.com 80
GET / HTTP/1.0
# then hit RETURN RETURN
```

## netstat | lsof | programs binding to ports using protocols

Use netstat **with sudo** to discover the processes binding to ports on a linux system. If you omit sudo no PID/Program name binding to the port will be 

``` bash
sudo netstat -lntp
sudo netstat -lnp | grep ':22'
```

Here is the result table for an AWS EC2 server running nginx on port 443 and 80, a ssh service on port 22 and some AWS services on the nine thousand ports.

<pre>
Active Internet connections (only servers)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:24224           0.0.0.0:*               LISTEN      10304/ruby          
tcp        0      0 127.0.0.1:24230         0.0.0.0:*               LISTEN      10304/ruby          
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      936/systemd-resolve 
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1177/sshd           
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN      26398/cupsd         
tcp        0      0 0.0.0.0:8888            0.0.0.0:*               LISTEN      10297/ruby          
tcp        0      0 127.0.0.1:6010          0.0.0.0:*               LISTEN      24214/sshd: apollo@ 
tcp6       0      0 :::22                   :::*                    LISTEN      1177/sshd           
tcp6       0      0 ::1:631                 :::*                    LISTEN      26398/cupsd         
tcp6       0      0 ::1:6010                :::*                    LISTEN      24214/sshd: apollo@ 
</pre>

The grep command hones in to the port you are interested in.

<pre>
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1177/sshd           
tcp6       0      0 :::22                   :::*                    LISTEN      1177/sshd           
</pre>


## Examine Traffic Through a Port

These commands look at a port and tell you what is going through it.

```bash
sudo tcpdump -i any tcp port 443
sudo tcpdump -i any tcp port 443 -vv
```

## lsof | list open files

Linux views ports, database connections and files themselvs as files - so when a process binds to a port it is listed as an open file - and that is where **lsof** comes in. It pays to idempotently install **lsof** as you cannot assume its presence.

``` bash
sudo apt-get install --assume-yes lsof   # install list open files command tool
sudo lsof -i
sudo lsof -i :8888
sudo lsof -i | wc -l                     # count the number of open network ports
sudo lsof | wc -l                            # count the number of open files (can be over 100,000)
```

### IPv4 vs IPv6

**lsof** tells you whether the protocol is IPv4 or IPv6 - netstat makes an attempt in the **Proto** (protocol) column.

<pre>
COMMAND     PID            USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
systemd-r   936 systemd-resolve   12u  IPv4  24706      0t0  UDP localhost:domain 
systemd-r   936 systemd-resolve   13u  IPv4  24707      0t0  TCP localhost:domain (LISTEN)
avahi-dae  1066           avahi   12u  IPv4  26400      0t0  UDP *:mdns 
avahi-dae  1066           avahi   13u  IPv6  26401      0t0  UDP *:mdns 
avahi-dae  1066           avahi   14u  IPv4  26402      0t0  UDP *:52632 
avahi-dae  1066           avahi   15u  IPv6  26403      0t0  UDP *:46708 
sshd       1177            root    3u  IPv4 699782      0t0  TCP *:ssh (LISTEN)
sshd       1177            root    4u  IPv6 699784      0t0  TCP *:ssh (LISTEN)
fluentd   10297        td-agent   15u  IPv4  56723      0t0  TCP *:8888 (LISTEN)
ruby      10304        td-agent   10u  IPv4  55979      0t0  TCP localhost:24230 (LISTEN)
ruby      10304        td-agent   14u  IPv4  55198      0t0  TCP *:24224 (LISTEN)
ruby      10304        td-agent   15u  IPv4  56723      0t0  TCP *:8888 (LISTEN)
ruby      10304        td-agent   16u  IPv4  55199      0t0  UDP *:24224 
dhclient  22989            root    6u  IPv4 692015      0t0  UDP *:bootpc 
dhclient  23305            root    6u  IPv4 697572      0t0  UDP *:bootpc 
sshd      24071            root    3u  IPv4 702431      0t0  TCP thinkpad:ssh->192.168.0.10:57704 (ESTABLISHED)
sshd      24084            root    3u  IPv4 702456      0t0  TCP thinkpad:ssh->192.168.0.10:57716 (ESTABLISHED)
sshd      24214          apollo    3u  IPv4 702431      0t0  TCP thinkpad:ssh->192.168.0.10:57704 (ESTABLISHED)
sshd      24214          apollo    9u  IPv6 704374      0t0  TCP ip6-localhost:6010 (LISTEN)
sshd      24214          apollo   10u  IPv4 704375      0t0  TCP localhost:6010 (LISTEN)
sshd      24214          apollo   15u  IPv4 706185      0t0  TCP localhost:6010->localhost:39330 (ESTABLISHED)
sshd      24263          apollo    3u  IPv4 702456      0t0  TCP thinkpad:ssh->192.168.0.10:57716 (ESTABLISHED)
emacs     24350          apollo    5u  IPv4 706829      0t0  TCP localhost:39330->localhost:6010 (ESTABLISHED)
cupsd     26398            root    6u  IPv6 714059      0t0  TCP ip6-localhost:ipp (LISTEN)
cupsd     26398            root    7u  IPv4 714060      0t0  TCP localhost:ipp (LISTEN)
cups-brow 26399            root    7u  IPv4 714068      0t0  UDP *:ipp 
</pre>

