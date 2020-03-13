
# network cat | ncat | nc | openssl

``` bash
sudo apt-get install --assume-yes netcat nmap telnet-ssl
```

## netcat | debug incoming client connection

On one shell set netcat to listen (l) on port 80. (Nothing happens).

    $ sudo netcat -l 80

On another shell use wget to ask for something on port 80.

    $ wget http://localhost

Suddenly netcat shows this.

    GET / HTTP/1.1
    User-Agent: Wget/1.19.4 (linux-gnu)
    Accept: */*
    Accept-Encoding: identity
    Host: localhost
    Connection: Keep-Alive

And wget sits around waiting for a response. It prints this.

    --2018-10-22 12:21:04--  http://localhost/
    Resolving localhost (localhost)... 127.0.0.1
    Connecting to localhost (localhost)|127.0.0.1|:80... connected.
    HTTP request sent, awaiting response...

## netcat | understand server services

    $ netcat google.com 80
    HEAD/HTTP/1.1
    (Ctrl-D)

After the netcat command type HEAD/HTTP/1.1 and you should get some kind of response. You should not be able to determine "what" is on the other end. You should not be told it is nginx - even better something obfuscator-like like starwars is sometimes issued.


## using openssl to talk to servers

    $ openssl s_client -connect imap.gmail.com:993


