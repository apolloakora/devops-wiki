# How to troubleshoot etcd3 ignition cluster | Using SSH

To login via SSH and view the error logs is priceless so a SSH configuration is important to troubleshoot effectively. To do this you

- **[create a ssh public/private keypair](/ssh/ssh)**
- use Terraform to add the public key for server access
- ensure that the AWS security group allows SSH
- temporarily put the ec2 machines in a public subnet
- output the public ip addresses of the nodes
- login using SSH and your private key
- execute the troubleshooting commands (and view logs)


[[_TOC_]]

### Using Terraform to add the public key

Add the below snippet into the [main terraform etcd3 cluster creation file](https://github.com/devops4me/terraform-aws-etcd3-cluster/blob/master/etcd3.cluster-main.tf) and **replace with your public key**.

    resource aws_key_pair troubleshoot
    {
        key_name = "etcd3-cluster-keypair"
        public_key = "ssh-rsa AAAAB3Nasdfasdfasdf/asdfasdfasdfdadfafdadsf/asdfasdfasdfasdfasdfasdfaasdfads"
    }

Put this line into the aws_instance node creation resource.

    resource aws_instance server
    {
        ...
        key_name               = "${ aws_key_pair.troubleshoot.id }"
        ...
    }

### Add a SSH Security Group Rule

Ensure that the security group module has an **in_ingress rule** named **ssh**.

    module security-group
    {
        source         = "github.com/devops4me/terraform-aws-security-group"
        in_ingress     = [ "ssh", "http", "https", "etcd-client", "etcd-server", "etcd-listen" ]
        ...
    }

### Use Public Subnets to House the Nodes | Temporarily

Check that you are **(temporarily) using public subnets** (easy to SSH to without needing a bastion host) to house the etcd3 nodes. Note that the **[vpc-subnets module](https://github.com/devops4me/terraform-aws-vpc-network)** will automatically create an internet gateway and routes from the subnet out when it notices that you want public subnets.

    module vpc-subnets
    {
        source                 = "github.com/devops4me/terraform-aws-vpc-subnets"
        in_num_private_subnets = 0
        in_num_public_subnets  = 3
        ...
    }


## Output the Node Public IP Addresses

To output the public IP addresses of the nodes add this line to the terraform code.

    output public_ip_addresses{ value  = "${ aws_instance.node.*.public_ip }" }

When terraform apply completes it will print out (in green) - the node public IP addresses which you'll need to SSH in (to troubleshoot).


## Login to one (some) of the nodes

Ensure the private key is locked down with 0600 permissions.

    ssh core@<<public-ip-address>> -i <</path/to/private-key.pem>>

Say yes and you are into the CoreOS ec2 node.


## Execute Troubleshooting Commands

The important commands for troubleshooting are as follows.

    $ journalctl
    $ journalctl -u etcd-member.service
    $ journalctl --identifier=ignition --all
    $ etcdctl cluster-health
    $ etcdctl member list
    $ etcdctl --endpoints --debug cluster-health
    $ printenv
    $ cat /etc/systemd/system/etcd3.service
    $ systemctl status etcd-member
    $ systemctl cat etcd-member.service
    $ systemctl status etcd-member.service
    $ systemctl --type=service
    $ systemctl list-units --type=service # list the active services on the system
    $ systemctl                           # list every unit and its status
    $ systemd-delta --type=extended       # which systemd unit files have been overriden


In the journalctl logs find the discovery url and put it in a browser.

    https://discovery.etcd.io/<<hexadecimal-token>>

The load balancer's health checks depend on the below URL. The load balancer will use private IP addresses but you use the public ones.

    $ curl -L http://<<node-public-ip-address>>:2379/health


## Set etcd key-value pairs

If everything appears to be working you can set key-value pairs on any cluster node command line or use the REST API through node public IP addresses or ideally through the load balancer's DNS name.

    $ etcdctl set morning-greeting "Good Morning"
    $ etcdctl set evening-greeting "Good Evening"
    $ etcdctl get morning-greeting
    $ etcdctl get evening-greeting



### [systemd unit files know-how](https://www.freedesktop.org/software/systemd/man/systemd.unit.html)

### [etcd versions in quay.io coreos/etcd repository](https://quay.io/repository/coreos/etcd?tab=tags)

### CoreOS Wrappers for etcd flannel kubelet and locksmith (https://github.com/coreos/coreos-overlay/tree/master/app-admin)
