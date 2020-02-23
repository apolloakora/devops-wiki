
# How Web Requests from Browsers to Servers Work?

So how to Web Requests from a browser to a server and back really work?

The request will go through many network interfaces each with its own MAC (Media Access Control) address.

## Use DNS to discover the Server Address

Goes through the local DNS server (see nslookup output) and may touch the
- Root DNS server from ISP
- TLD (top level domain) DNS server (eg .com .org or .es)
- authorative DNS server



### dig | domain name

dig is the defacto tool for troubleshooting and understanding DNS (name) servers.

```
nslookup www.devopswiki.co.uk
```


### nslookup | domain name

```
nslookup www.devopswiki.co.uk
```

### nslookup response

```
Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
www.devopswiki.co.uk	canonical name = elb-id-wiki-hub-18319-1842-943190955.eu-west-1.elb.amazonaws.com.
Name:	elb-id-wiki-hub-18319-1842-943190955.eu-west-1.elb.amazonaws.com
Address: 34.240.48.9
Name:	elb-id-wiki-hub-18319-1842-943190955.eu-west-1.elb.amazonaws.com
Address: 3.248.162.35
```


## Break up Url

The url has 3 parts to it.

1. the protocol **`http`** or **`https`**
1. the servername **`devopswiki.co.uk`**
1. the resource name and parameters

## Use DNS to discover the Server Address

