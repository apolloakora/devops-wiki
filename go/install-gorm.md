
# Install Gorm Goose

To install gorm goose we need

1. golang installed - see [[install go]]
1. gcc installed
1. gorm installed from github

The key gorm library is **github.com/jinzhu/gorm** but Altoros (1 contributor) has one feature needed. If  you do not need it go with jinzhu.

```bash
apt-get install --assume-yes gcc
go get github.com/Altoros/gorm-goose/cmd/gorm-goose
```


## go.uuid | using the satori go.uuid package

You can go get the golang uuid package from **github.com/satori**.

```bash
go get -v github.com/satori/go.uuid
git -C $GOPATH/src/github.com/satori/go.uuid checkout v1.2.0
```

## multiple-value uuid.NewV4() in single-value context | go,uuid error

This error is an API breaking change introduced by the **github.com/satori/go.uuid** package.

The workaround is to roll to a working version and this is achieved by going to the golang root folder (containing the src directory) and running a checkout for the (working) version 1.2.0.

```bash
cd /root/go                                          # go to the go root containing the src folder
git -C src/github.com/satori/go.uuid checkout v1.2.0 # checkout version 1.2.0 before API breaking change
```

Git should report the below.
<strong>
<pre>
HEAD is now at f58768c... Add support for setting variant bits other than RFC4122.
</pre>
</strong>

