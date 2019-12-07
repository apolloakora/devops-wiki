
# SSH | SCP


## Using the ED25519 Algorithm to Create a Public/Private Keypair

From here on in the ED25519 algorithm trumps ECDSA, RSA and DSA for both security and performance during signing and crypt activities.

    $ ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_$(date +%Y-%m-%d) -C "Ed25519 KeyPair made 4 X Y and Z"

Fine tune the timing stamp) - and use safe to produce the key rather than doing it manually because the key never gets exposed - not even for a second.

### An ED25519 Private Key Example 

```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACB3DAr5Q3I6NakYHnlJvEuHwLXtPkLzHFq8HaKJgIIeogAAALCeg9/AnoPf
wAAAAAtzc2gtZWQyNTUxOQAAACB3DAr5Q3I6NakYHnlJvEuHwLXtPkLzHFq8HaKJgIIeog
AAAECJj8q6NsrX7d5GCuuzEzV95G7fcK/U3kgyCFxT3kXKCXcMCvlDcjo1qRgeeUm8S4fA
te0+QvMcWrwdoomAgh6iAAAAKGVkMjU1MTkgdGVzdGluZyBsb2dpbiBrZXkgZm9yIHggeS
BhbmQgei4BAgMEBQ==
-----END OPENSSH PRIVATE KEY-----
```


### An ED25519 Public Key Example 

    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHcMCvlDcjo1qRgeeUm8S4fAte0+QvMcWrwdoomAgh6i Ed25519 KeyPair made 4 X Y and Z

---

## Display SSH Keys with id_ Names

    $ for key in ~/.ssh/id_*; do ssh-keygen -l -f "${key}"; done | uniq

---

## SSH | Create a 4096 bit Public/Private keypair

Do not forget to lock down the private key.

``` bash
ssh-keygen -t rsa -b 4096 -C "Key Purpose Description"
chmod 400 ~/.ssh/id_rsa
```


---


## SSH | Convert RSA Key to PEM

Some apps prefer their private keys in a .pem format and this command does the conversion.

``` bash
openssl rsa -in ~/.ssh/id_rsa -outform pem > the-private-key.pem
chmod 600 the-private-key.pem
```

---


## How to Remove the Passphrase from a Private Key

The preconditions are that

- the private key is in PEM format
- the key has chmod 600 permissions

#### `ssh-keygen -p [-P old_passphrase] [-N new_passphrase] [-f keyfile]`


#### `ssh-keygen -p -P "my_secret_passphrase" -N "" -f /path/to/private-key.pem`

The reply should be **Your identification has been saved with the new passphrase.**


---


## SSH | Login into a Shell Using SSH

The multi v's will raise the verbosity to help with troubleshooting.

``` bash
ssh -vvv username@hostname -i .ssh/id_rsa
```

---

## SSH | Permissions Best Practise

SSH servers and clients can be rather opionionated about permissions of ssh objects. So before connecting check on both the server and client, that the workstation

- **~./ssh** folder permissions should be 700
- **~/.ssh/authorized_keys** file permissions should be 600
- **~/.ssh/config** permissions should be 600
- `~/.ssh/id_*` permissions should be 600

---

## SSH | Install Client and Server

``` bash
sudo apt-get install --assume-yes openssh-client openssh-server
```

---

## SSH | Connect with Ruby

You can use scripting languages like Ruby or Python to connect via ssh and then copy, download files and run commands.

### Ruby Program that Connects via SSH

Set the path to the private key, the hostname and username and then run the script.

``` ruby
#!/usr/bin/ruby

require 'net/ssh'

the_key_file = '/path/to/private-key.pem'
the_hostname = "example.com"
the_username = "joebloggs"
key_array = the_keyfile.nil? ? [] : [ the_keyfile ]

Net::SSH.start( the_hostname, the_username, :keys => key_array ) do |executor|
  executor.exec "ls"
  executor.loop
end
```

---

## SSH | Setup Up PasswordLess Login

For passwordless login you must

- create a public/private keypair without a passphrase
- add the public key (line) into the `~/.ssh/authorized_keys` file (create if necessary)


---

## SSH | Recreate public key from private key

To recreate the public key go to the private key's folder and execute these commands.

    chmod 600 <<private-key.pem>>
    ssh-keygen -y -f <<private-key.pem>> > <<public-key.pub>>


---

## How to Convert SSH Keys from PPK to PEM Formats

**Windows loves PPK, Linux prefers PEM** - it's that simple. If you want to convert a private key from PPK to pem, this is how you do it.

```bash
sudo apt-get install --assume-yes putty-tools
puttygen <<private-key-name>>.ppk -O private-openssh -o <<private-key-name>>.pem
ssh devopswiki.co.uk -i <<private-key-name>>.pem
```

**Note that we did not lock down the converted key?**

```
chmod 600 <<private-key-name>>.pem
```

That is because the puttygen does this for us (as standard).

On Linux, private PEM key permissions must be locked down otherwise SSH won't touch it.
