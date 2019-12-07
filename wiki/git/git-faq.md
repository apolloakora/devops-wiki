
# Git | Frequently Asked Questions

## Git Certificates Error | server certificate verification failed

After certificates work changing the `/etc/ssl/certs` folder and/or the `/etc/ssl/certs/ca-certificates.crt` file you can get git failures such as the below.

```
fatal: unable to access 'https://.... .git/': server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
```

If certificates work makes a Git call fail you can bypass it for the specific shell session only by adding the GIT_SSL_NO_VERIFY environment variable set to 1.

``` bash
export GIT_SSL_NO_VERIFY=1
```





