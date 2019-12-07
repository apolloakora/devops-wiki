
# Simple SSH Tunnel from Local to Remote

### Also see [ssh forwarding](ssh-forwarding) for a more involved 3 machine tunnel

A simple tunnel involves just two machines. Your local machine and a remote machine.

## Your Problem

You are able to access port 22 on the remote machine but you cannot access a service running on another port - usually port 80 for http but also 443 for https or say 2432 for a PostgreSQL database.

## What you need

Make sure you have

- the url (ip address) of the remote machine
- the port you want to tunnel to (you can tunnel to multiple ports from multiple terminals)
- a free port on your machine any like like 2333 or 2444 will do (between 2000 and 9990)
- the username for the ssh account on the remote machine
- either the password for the remote user account or a private key
- if private key the remote machine needs to have been plied with a public key
- the passphrase of the private key if this has been set - **[you can remote the passphrase](ssh-remove-passphrase)**
- the private key must be locked down with chmod 600 permissiones

## The Steps

**`ssh -L local_port:local_address:remote_port username@remote_address -i ~/path/to/private-key.pem`**

This is an example using **port 2345** locally to access **port 80** (web) on the remote machine with **username apollo** and **IP address 51.52.199.23** with a key in the **`~/.ssh/machine-private-key.pem`** key.

**`ssh -L 2345:localhost:80 apollo@51.52.199.23 -i ~/.ssh/machine-private-key.pem`**





## Easy SSH Tunnel Launching

Launching the usual SSH tunnel command is long and dreary and it hogs a command line so you can end up with 5 frozen terminals.

Solve both these issues by using the **`~/.ssh/config`** file and kicking off the tunnel with a shorter command or script.

```
Host my-jenkins
HostName 51.52.53.54
User jenkins
Port 22
IdentityFile  ~/.ssh/jenkins-private-key.pem 
LocalForward 2345 localhost:8080
ServerAliveInterval 30
ServerAliveCountMax 3
```

Now you can issue the command **`ssh -N my-jenkins &`** to kick off the tunnel and return to the command prompt.
Keep a **log of the process ID** so that you can do a **`kill <<process-id>>`** should you want to terminate the tunnel.

You can also run other tunnels from a script.

```
ssh -N my-jenkins &
ssh -N my-kibana &
ssh -N my-nexus &
ssh -N my-gitlab &
```

If the tunnel port is already in use the command will fail with a message like below.

```
apollo@trafalgar:~/.ssh$ bind: Address already in use
channel_setup_fwd_listener_tcpip: cannot listen to port: 2346
Could not request local forwarding.
```


## Tunneling from a script

If you need to create more than a couple of unnels it pays to do so from a script you can just call. It also pays to pipe the output to a log from which you can retrieve the process IDs just in case we need to reference them.

Call the script with **`$ ./tunnel.sh >> tunnel-output.log`**

### Tunnel Script | tunnel.sh

```
#!/bin/bash

# ++ +++ +++++++ # ++++++++ +++++++ # ++++++ +++++++++ # ++++++++++ +++++++ ++ #
# ++ --- ------- # -------- ------- # ------ --------- # ---------- ------- ++ #
# ++                                                                        ++ #
# ++  Set up SSH tunnels to the places that you want to go to.              ++ #
# ++                                                                        ++ #
# ++ --- ------- # -------- ------- # ------ --------- # ---------- ------- ++ #
# ++ +++ +++++++ # ++++++++ +++++++ # ++++++ +++++++++ # ++++++++++ +++++++ ++ #


echo "" ; echo "" ;
echo "### ################################################# ###"
echo "### Tunnels created on $(date)."
echo "### ################################################# ###"
echo ""

ssh -N my-jenkins &
ssh -N my-kibana &
ssh -N my-nexus &
ssh -N my-gitlab &

echo ""
echo "### Tunnel creation has completed on $(date)."
echo "### =================================================== ###"
echo ""
```

## Keeeping an SSH Tunnel Alive | autossh

How can we **keep SSH tunnels open** in a reliable manner on a Linux (Ubuntu 16.04, 18.04, 20.04 and up)? Let's use **autossh** to solve this problem.

```
sudo apt install --assume-yes autossh
```

- **[use init.d to reconnect ssh on bootup](https://erik.torgesta.com/2013/12/creating-a-persistent-ssh-tunnel-in-ubuntu/)**
- **[use systemd to reconnect ssh on bootup](https://askubuntu.com/questions/947841/start-autossh-on-system-startup)**
- **[excellent autossh blog](https://erik.torgesta.com/2013/12/creating-a-persistent-ssh-tunnel-in-ubuntu/)**

