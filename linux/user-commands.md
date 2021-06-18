
# linux (ubuntu) users

## Create Linux User If Necessary

These are high quality user creation commands. Use if required.

<div style="font-size: 2.0em;">
<strong>
```bash
sudo adduser --home /var/opt/&lt;&lt;usrname&gt;&gt; --shell /bin/bash --gecos 'New User' &lt;&lt;usrname&gt;&gt;
sudo install -d -m 755 -o &lt;&lt;usrname&gt;&gt; -g &lt;&lt;usrname&gt;&gt; /var/opt/&lt;&lt;usrname&gt;&gt;
```
</strong>
</div>

The above simply create the user and there home directory within ***/var/opt***

## Give User Sudo Priveleges

We modify the user and then assume root rather than just using sudo - otherwise a permission denied error for changing ***/etc/sudoers*** will ensue.

```bash
sudo su root
cd; pwd;
echo $SUDO_USER
sudo usermod -a -G sudo $USER
sudo echo "$SUDO_USER ALL=NOPASSWD: ALL" >> /etc/sudoers
```

Now you need to pull up a new terminal.
