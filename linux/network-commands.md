
# Linux Network Troubleshooting

Troubleshooting a linux server boils down to the shell after external logs, metrics and monitors have drawn a blank. These commands are the foundation of troubleshoting efforts after you SSH onto the shell.

Resources are the network/bandwidth, drive/disks, RAM/Memory and Process/CPU

| Basic Command         | Valuable Information Gleaned | Symptoms that Warrant this Action | Resource |
|:--------------------- |:---------------------------- |:--------------------------------- |:-------- |
| route -n         | to be done | to be done | network |
| ifconfig         | to be done | to be done | network |
| ip addr         | to be done | to be done | network |
| hostname -I         | to be done | to be done | network |



## Querying Running Services

```
service --status-all   # lists all services whether running or not
```


## View Process List by Memory Consumed

**`ps -eo pid,ppid,%mem,%cpu,cmd,start,time --sort=-%mem | head -20`**
**`watch ps -eo pid,ppid,%mem,%cpu,cmd,start,time --sort=-%mem | head -20`**

## Check network interfaces

- **`ip addr`**
- **`ip addr | grep UP`** - check all interfaces are up
- **`ip addr | grep DOWN`** - this list should be empty

## Bring Interfaces Up and Down

- **`sudo apt install ifupdown`**

## Checking Network through WhatsMyIp

- **`dig +short myip.opendns.com @resolver1.opendns.com`**


## Do NS Lookups

- **`nslookup opendns.com`**
- **`nslookup 192.168.0.1`**

## Ubuntu's Network Manager

- **`sudo apt install network-manager --assume-yes`**
- **`nmcli device status`** - lists all interfaces and their status

## ip - the trusted ip

- **`ip neighbor show`** - excellent command for seeing what you'll see

