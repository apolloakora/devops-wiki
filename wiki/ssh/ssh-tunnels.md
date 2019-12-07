

# Securely Connect to Linux Instances Running in a Private Amazon VPC

In this post, I’ll look at how to use SSH agent forwarding to allow administrators to securely connect to Linux instances in private Amazon VPC subnets. Using this configuration improves security because you don’t have to expose the management ports of your Linux instances to the Internet or to other subnets in your VPC.SSH and bastion servers

By default, Linux instances in EC2 use SSH key files for authentication instead of SSH usernames and passwords. Using key files can reduce the chance of somebody trying to guess the password to gain access to the instance. But using key pairs with a bastion host can present a challenge—connecting to instances in the private subnets requires a private key, but you should never store private keys on the bastion.

One solution is to use SSH agent forwarding (ssh-agent) on the client. This allows an administrator to connect from the bastion to another instance without storing the private key on the bastion. That’s the approach I’ll discuss in this post.

## Configuring ssh-agent

The first step in using SSH agent forwarding with EC2 instances is to configure a bastion in your VPC. We suggest that the instance you use for your bastion be purpose-built and that you use it only as a bastion and not for anything else. The bastion should also be set up with a security group that’s configured to listen only on the SSH port (TCP/22). For additional security, you can harden the instance further. It’s beyond the scope of this post to discuss hardening in detail, but doing so involves tasks like enabling SELinux, using a remote syslog server for logs, and configuring host-based intrusion detection. For more in-depth information, see OS Hardening Principles on the etutorials.org site.

Always remember the following when configuring your bastion:

Never place your SSH private keys on the bastion instance. Instead, use SSH agent forwarding to connect first to the bastion and from there to other instances in private subnets. This lets you keep your SSH private key just on your computer.
Configure the security group on the bastion to allow SSH connections (TCP/22) only from known and trusted IP addresses.
Always have more than one bastion. You should have a bastion in each availability zone (AZ) where your instances are. If your deployment takes advantage of a VPC VPN, also have a bastion on premises.

## Configure Linux instances in your VPC to accept SSH connections only from bastion instances.

    ssh-add -K myPrivateKey.pem
    Enter passphrase for myPrivateKey.pem:
    Passphrase stored in keychain: myPrivateKey.pem
    Identity added: myPrivateKey.pem (myPrivateKey.pem)

Adding the key to the agent lets you use SSH to connect to an instance without having to use the –i <keyfile> option when you connect. If you want to verify the keys available to ssh-agent, use the ssh-add command with the -L option. The agent displays the keys it has stored, as shown in the following example:

    ssh-add –L
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDHEXAMPLErl25NOrbhgIGQzyO+TYyqbbYEueiELcXtOQHgEFpMAb1Nb8SSnlxMxiCXwTKd5/lVnmgcbDwBpe7ayQ6idzjHfvoxPsFrI3QSJVQgyNcx0RylX9IjcvJOyw== myPrivateKey.pem

After the key is added to your keychain, you can connect to the bastion instance with SSH using the –A option. This option enables SSH agent forwarding and lets the local SSH agent respond to a public-key challenge when you use SSH to connect from the bastion to a target instance in your VPC.

For example, to connect to an instance in a private subnet, enter the following command to enable SSH agent forwarding using the bastion instance:

    ssh –A user@<bastion-IP-address or DNS-entry>

When you first connect to the instance, you should verify that the RSA key fingerprint that the bastion presents matches what is displayed in the instance’s console output. (For instructions on how to check the fingerprint, se the EC2 documentation).

After you’re connected to the bastion instance, use SSH to connect to a specific instance using a command like this:

    ssh user@<instance-IP-address or DNS-entry>

Note that ssh-agent does not know which key it should use for a given SSH connection. Therefore, ssh-agent will sequentially try all the keys that are loaded in the agent. Because instances terminate the connection after five failed connection attempts, make sure that the agent has five or fewer keys. Because each administrator should have only a single key, this is rarely a problem for most deployments. For details about how to manage the keys in ssh-agent, use the man ssh-agent command.
