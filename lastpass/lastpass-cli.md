
# LastPass Cli | lpass | How to Install LastPass CLI

<!-- facts

[page]
authority =

[https://lastpass.github.io/lastpass-cli/lpass.1.html#_agent]
authority = lpass, lastpass cli examples

[https://github.com/lastpass/lastpass-cli]
title = How to Install LastPass CLI on all Platforms

-->

## Intro | LastPass API

The LastPass API is not solely accessible via the web browser (gui) - many LastPass features including getting and setting credentials are accessible via LastPass Cli (a command line interface) and soon - a REST (representational state transfer) API.

## lpass | LastPass Cli

Using the **lpass** command, we can invoke lastpass behaviour on many platforms. First we need to install it.

## Install LastPass Cli | Ubuntu 1804 | Ubuntu 1604

On Ubuntu we install the **lpass** supporting packages and finally the lastpass-cli itself.

``` bash
sudo apt-get install --assume-yes \
    asciidoc             \
    build-essential      \
    cmake                \
    libcurl4-openssl-dev \
    libxml2              \
    libssl-dev           \
    libxml2-dev          \
    openssl              \
    pkg-config           \
    pinentry-curses      \
    xclip                \
    xsltproc             \
    ;
sudo apt-get install --assume-yes lastpass-cli;
sudo make install-doc;
sudo apt-get upgrade --assume-yes lastpass-cli;
lpass;
lpass --version;
```

The `lpass` command provides the usage list.
But take note of the version

> LastPass CLI v0.7.0


## LastPass Login | LastPass Username | LastPass Master Password

You must have setup a LastPass account (the free one will do) and have two bits of information
1. the username (usually email address)
1. the (lastpass) master password

> $ lpass login abc123@gmail.com
> Success: Logged in as abc123@gmail.com

Now you've logged in and are ready to interact with lastpass.


## LastPass Login Error | Peer certificate cannot be authenticated with given CA certificates.

If a login with any email accout like so

<pre>
$ lpass login abc123@gmail.com
</pre>

produces the below error

>> Error: Peer certificate cannot be authenticated with given CA certificates.

then you need to either upgrade the lastpasss cli from say v0.7.0 to (say) 1.0.0

To upgrade lastpass on Ubuntu you download the ".deb" package like **lastpass-cli_1.0.0-1.2_amd64.deb** and run dpkg as below.

``` bash
sudo dpkg -i Downloads/lastpass-cli_1.0.0-1.2_amd64.deb
lpass --version
```

The following logs illustrate that the new lastpass cli package 1.0.0 is being configured.

> (Reading database ... 438799 files and directories currently installed.)
> Preparing to unpack .../lastpass-cli_1.0.0-1.2_amd64.deb ...
> Unpacking lastpass-cli (1.0.0-1.2) over (0.7.0-1) ...
> Setting up lastpass-cli (1.0.0-1.2) ...
> Processing triggers for man-db (2.7.5-1) ...

Now check the version again and it should be 1.0.0.
Also the login now produces a request for the master password.


## LastPass Man Pages

The LastPass man(manual) pages documentation is excellent. It contains all command switches and is laden with helpful examples.

>> man lpass

On Linux systems `man lpass` will open up the manual with the primary login, logout, show, ls, edit, generate, rm, sync, export and share subcommands. You can drill down into a man page for each command.

