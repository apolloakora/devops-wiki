

# Installing Golang | Go

The downloads page is at https://golang.org/dl/

Go there to discover the version for your machine architecture.

For version 1.10.3 on amd64 the url looks like this.

<pre>
https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
</pre>

## Download the Go archive into /usr/local

Go expects to be inside '/usr/local' typically the binary lives in '/usr/local/go/bin'
The plan is to download the archive and unpack it into /usr/local

```bash
apt-get install --assume-yes wget
wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.10.3.linux-amd64.tar.gz
ls -lah /usr/local/go
export PATH=$PATH:/usr/local/go/bin
go env
```
When you run `go env` the output should provide sensible values for the key protagonists.

<pre>
GOARCH="amd64"
GOCACHE="/root/.cache/go-build"
GOHOSTARCH="amd64"
GOHOSTOS="linux"
GOOS="linux"
GOPATH="/root/go"
GOROOT="/usr/local/go"
GCCGO="gccgo"
CC="gcc"
</pre>



