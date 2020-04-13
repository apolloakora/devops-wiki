
# Working with GPG Keys

First install the GPG key from **[GNU PG](https://www.gnupg.org/download/)**. For the MAC remember to go to

- **`System Preferences`** and then
- **`Security and Privacy`** and
- Allow Apps downloaded from wherever

Verify with

```
gpg --list-secret-keys --keyid-format LONG    # list the keys
```

### Install the GPG Suite

Go to **[the GPG Tool Suite](https://gpgtools.org/)** and download then install the tools.
Open GPG KeyChain to see the keychain.

You can export your GPG key (and include the secret key inside it).



## Create a New GPG Key

```
gpg --full-generate-key   # create new gpg key
```

## Working with GPG Keys

You can now list the keys and the armor command will print the public key. You can then add this public key to websites or send to others.


```
gpg --list-secret-keys --keyid-format LONG    # list the keys
gpg --armor --export <key-identifier>         # print the public key of a gpg key to paste into websites
echo "test" | gpg2 --clearsign                # check that GPG is working
brew install pinentry                         # program will organize gpg key git usage
gpg2 -K --keyid-format                        # list the GPG keys available
git config --global core.pager cat            # we do not like the less output
git config --list                             # list the current set of git configs
git config --global gpg.program gpg2          # make sure git uses gpg2
git config --global user.signingkey <KEY_ID>  # Use the public key ID from the gpg2 -K command
git commit -S -am "checking gpg signing"      # sign a commit with your gpg key
gpgconf --kill gpg-agent                      # if necessary kill running gpg agents
git config --global commit.gpgsign true       # always sign every commit
```
