
# GNU PG | GNU Privacy Guard | Git Crypt | Git Secrets

## How to Create a New GNU PG Key

    $ gpg --full-generate-key
    $ <enter>              # what kind of key
    $ <enter>              # what key size
    $ 0 or 1y              # forever or 1 year
    $ y                    # confirm its correct
    $ Joe Bloggs           # Your Real Name
    $ joebloggs@gmail.com  # Email Address
    $ Company Tech Secrets # Comment
    $ Enter Password       # <password123>

**Use safe to produce a key because the functionality is extremely shaky - it fails for so many reasons.**

## GNU PG Key Creation Failures

    gpg: agent_genkey failed: No such file or directory
    Key generation failed: No such file or directory

The main failure reason is a duplicate key and it usually fails if a **~/.gnupg directory already exists** or has **incorrect permissions**.

## Create GNU PG Folder | Set Permissions

The safest way if you don't care about past keys is to rename the ~/.gnupg folder and then recreate it with these commands.


    $ mkdir -p ~/.gnupg/private-keys-v1.d
    $ chmod 700 ~/.gnupg/private-keys-v1.d
    $ gpg --full-generate-key


This output is good news and it means that your key has been created successfully.

    gpg: key DAAF3A16C3D82491 marked as ultimately trusted
    gpg: revocation certificate stored as '/home/apollo/.gnupg/openpgp-revocs.d/69F2732119D92AE686DA8E1CDAAF3A16C3D82491.rev'
    public and secret key created and signed.

## Export GNU PG Public Key

Often to join a Git repository say using git-crypt and GNU PG to protect its secrets - you will need to **export your public key to a file then slack it** to the system administrator.

    $ gpg --export -a "Joe Bloggs" > bloggs.gpg.public.key

Then send the contents of file **bloggs.gpg.public.key** to the administrator.


## GNU PG Commands

    $ gpg --list-keys
    $ gpg --delete-secret-key "Joe Bloggs"
    $
    $
    $
    $



