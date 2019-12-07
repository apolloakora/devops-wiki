
# What is my public IP address

### Why find out the public IP addresses as seen from the outside?

Finding out how external actors view your public IP address from a machine inside your local network is necessary when

- troubleshooting an external service that is configured to accept an IP address (or a range of IP addresses)

The following commands satisfy this requirement.

```
dig +short myip.opendns.com @resolver1.opendns.com
dig TXT +short o-o.myaddr.l.google.com @ns1.google.com
dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}'
```


## install dig

dig is not available as standard on the Amazon Linux, CentOS and RHEL platforms. You can install it with yum and this is how.

```
sudo yum install -y bind-utils
```

