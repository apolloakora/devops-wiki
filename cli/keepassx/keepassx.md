
# KeePassX | Password Safe for Linux

KeePassX shares the KeePass database format allowing you to use your passwords on both Linux and Windows.

## How to Install KeePassX on Ubuntu

Ensure that at least keepassx version 2.0.2 has been installed.

``` bash
sudo apt-get install --assume-yes keepassx
keepassx --version
sudo apt-get install libcanberra-gtk3-module
```

If not, you should install keepassx directly from the development repositories.

## KeePassX | Where do I keep the Password Database?

Anywhere you can keep files, you can keep the KeePassX database. A DevOps Engineer can choose a wide variety of storage engines including Git, S3 Buckets, DropBox, Google Drive and removable media such as external drives and USB keys.

A Git repository on a USB key is a powerful option. If you forget your **most recent master password** you can rewind time and retrieve of your passwords.

Coupled with secondary backup storage on drives at home or in the office - you get a measure of "disaster recovery" should you lose your keys (or experience drive failure).

## Weak | 256-bit Master Password is Weak

**A 256 bit key can be cracked by many agencies in a matter of hours.** The solution is to encrypt your database with a 4096 bit SSH key. Keep the key somewhere else (even online) and protect access to that with a strong (approx) 32 character master password.

If your password database falls into the wrong hands, you can rest assured that the most powerful computers will need to work on it for weeks, perhaps even months. This is assuming the attackers have the password database - and not the 4096 bit SSH key.


## KeePassX Features

Aside from flexibility with storage engines, KeePass and KeePassX have a small number of well defined features to help you manage passwords. These include

- **cross platform** - the same password database can be used in Linux, Windows and Mac
- the ability to set **password expiration**
- **saving binary and text files** in conjunction with your passwords and sensitive information
- icons that act as an aide memoire
- duplication of the password database
- categorization of passwords and sensitive data
- use of the two strongest encryption algorithms (AES and Twofish)
- the **ability to search** within categories or across the entire password database
- access via an SSH key, locked down by a password
- automatic generation of secure passwords
- quality indicators for chosen passwords

## KeePassX is OpenSource

Open source security software tends to win out over time in comparison to closed source efforts. More eyes across the globe looking at potential issues and sharing vulnerabilities and solutions as and when they arise, pays dividends.

In closed source, vulnerabilities are jumped on quickly and the solutions themselves can eventually lead to more serious security holes.


## The Problem with KeePass and KeePassX

KeePass was written for windows and has **never embraced the command line** - and neither has its Linux port (KeePassX).

For most users this is no bother - for **DevOps Engineers** who want to automate everything under the sun, this could be a red line.

A bash and python command line interface (kpcli) do exist but aren't robust enough and they may introduce vulnerabilities.

## Competing Password Management Solutions

If you use KeePass(X), use the UI - if you want command line and scripting you should examine

 - HashiCorp's Vault (from the makers of Vagrant, Terraform and Packer)
 - CredStash (Python Utility backed up by AWS KMS and DynamoDB)
 - Ansible Vault (not open source - available with paid Ansible Tower)
 - LastPass - excellent command line, scripting and browser integration for all platforms (but no local passwords option)
 - the Unix "pass" utility - outdated cryptographically and command line only - but love the way it organises using filesystem folders (no fancy database - just a good old diretory hierarchy).

