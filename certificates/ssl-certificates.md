
# HTTPS and SSL Certificates



## SSL Certificate Install on Linux

Each line in the `/etc/ca-certificates.conf` file is a pathname of a CA certificate under `/usr/share/ca-certificates` (with a .crt extension) which should be

- installed (and implicitly trusted)
- ignored (uninstalled if previously trusted)

Lines beginning with an exclamation mark **!** tell the reconfiguration scripts to stop trusting the certificate and remove it from /etc/ssl/certs if it was previously trusted.

The actual certificates listed (without a prefix) in `/etc/ca-certificates.conf` must exist under `/usr/share/ca-certificates` with the extension of `.crt`

update-ca-certificates also generates `certificates.crt` which is a **concatenated single-file list** of certificates. At the end it also invokes certain scripts with lists of certificates tagged with (+) for additions and (-) for removals.



## How to add a Root Certificate from a CA (Certification Authority)

To add a new root certification authority you

- copy the CA's certificate (.crt) file to a path under **/usr/share/ca-certificates**
- update the certificates store with `sudo update-ca-certificates`

To remove a current certification authority you

- delete the CA's certificate (.crt) file from a path under **/usr/share/ca-certificates**
- update the certificates store with `sudo update-ca-certificates`



## All Certificates Uninstalled Issue

If **all SSL certificates are uninstalled** then suddenly all commands like git clone, git push, curl, wget, rclone, gem install, ssh and more fail complaining about pretty much the same problem - **certificate not trusted as root certificate not found**.

**Google Chrome** and **Mozilla Firefox** may continue to work perfectly because they source their root certificates from internal databases and not /etc/ssl/certs.

``` bash
ls -lah /usr/share/ca-certificates/mozilla/  # list the host of trusted by derault certs
cat /etc/ca-certificates.conf
# Now remove apostrophes (take care)
sudo update-ca-certificates
```

If most lines in `/etc/ca-certificates.conf` begin with an apostrophe you have a problem. They have all been uninstalled. Remove the apostrophes then run `sudo update-ca-certificates`. *****Take care that you are not reinstating a certificate that is not to be trusted.*****

A **successful response** still may put out some errors like the below.

```
Updating certificates in /etc/ssl/certs...
W: /usr/share/ca-certificates/mozilla/Comodo_Trusted_Services_root.crt not found, but listed in /etc/ca-certificates.conf.
W: /usr/share/ca-certificates/mozilla/DST_ACES_CA_X6.crt not found, but listed in /etc/ca-certificates.conf.
W: /usr/share/ca-certificates/mozilla/GeoTrust_Global_CA_2.crt not found, but listed in /etc/ca-certificates.conf.
rehash: skipping duplicate certificate in Amazon_Root_CA_4.crt
rehash: skipping duplicate certificate in Starfield_Class_2_CA.crt
rehash: skipping duplicate certificate in DigiCert_Assured_ID_Root_G2.pem
```

Check them, but more importantly your commands like git clone, wget, curl and gem install that access remote services all start working as normal.



## SSL Certificate Debug Commands

Use these commands to debug SSL certificate (and certificate authority) issues.

``` bash
curl -v --capath /etc/ssl/certs https://www.eco-platform.co.uk
openssl s_client -host www.onevanilla.com -port 443 -CApath /etc/ssl/certs
ls -lah /etc/ssl/certs
```



## OpenSSL Certificate Commands

This command shows us the certicate, its bit depth, its authority chain, ciphers, digests, key dates, issuers, public key fingerprints and more.

To exit type `QUIT` then `Enter` and you are back at the command line.

``` bash
openssl s_client -host www.onevanilla.com -port 443 -CApath /etc/ssl/certs
```



## Curl Certificate Commands

This example says **SSL certificate problem: unable to get local issuer certificate** which tells us that their is a GoDaddy certificate problem within the `/etc/ssl/certs` folder.

``` bash
curl -v --capath /etc/ssl/certs https://www.eco-platform.co.uk
```

<pre>
* Rebuilt URL to: https://www.eco-platform.co.uk/
*   Trying 52.49.242.174...
* TCP_NODELAY set
* Connected to www.eco-platform.co.uk (52.49.242.174) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: /etc/ssl/certs
* TLSv1.2 (OUT), TLS handshake, Client hello (1):
* TLSv1.2 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (OUT), TLS alert, Server hello (2):
* SSL certificate problem: unable to get local issuer certificate
* stopped the pause stream!
* Closing connection 0
curl: (60) SSL certificate problem: unable to get local issuer certificate
More details here: https://curl.haxx.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
</pre>


This out below can also be experienced.

```
* Rebuilt URL to: https://www.eco-platform.co.uk/
*   Trying 52.49.242.174...
* TCP_NODELAY set
* Connected to www.eco-platform.co.uk (52.49.242.174) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* error setting certificate verify locations:
  CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: /etc/ssl/certs
* Closing connection 0
curl: (77) error setting certificate verify locations:
  CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: /etc/ssl/certs
```

At times a simple `sudo update-ca-certificates` may crack it.
Then the correct output to the command will look like the below.

```
* Rebuilt URL to: https://www.eco-platform.co.uk/
*   Trying 52.49.242.174...
* TCP_NODELAY set
* Connected to www.eco-platform.co.uk (52.49.242.174) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: /etc/ssl/certs
* TLSv1.2 (OUT), TLS handshake, Client hello (1):
* TLSv1.2 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Client hello (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES256-GCM-SHA384
* ALPN, server accepted to use h2
* Server certificate:
*  subject: CN=eco-platform.co.uk
*  start date: Mar 27 13:19:26 2018 GMT
*  expire date: Jun 25 13:19:26 2018 GMT
*  subjectAltName: host "www.eco-platform.co.uk" matched cert's "www.eco-platform.co.uk"
*  issuer: C=US; O=Let's Encrypt; CN=Let's Encrypt Authority X3
*  SSL certificate verify ok.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x5646920c68e0)
> GET / HTTP/2
> Host: www.eco-platform.co.uk
> User-Agent: curl/7.58.0
> Accept: */*
> 
* Connection state changed (MAX_CONCURRENT_STREAMS updated)!
< HTTP/2 302 
< server: nginx
< date: Wed, 30 May 2018 15:00:26 GMT
< content-type: text/html; charset=utf-8
< content-length: 110
< location: https://www.eco-platform.co.uk/users/sign_in
< cache-control: no-cache
< x-content-type-options: nosniff
< x-frame-options: DENY
< x-request-id: eebf6487-87aa-40c2-8a1a-96f10933e67f
< x-runtime: 0.052322
< x-ua-compatible: IE=edge
< x-xss-protection: 1; mode=block
< strict-transport-security: max-age=31536000
< 
* Connection #0 to host www.eco-platform.co.uk left intact
```
