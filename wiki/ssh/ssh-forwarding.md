
# SSH Tunnel via a Bastion to Services in Private Networks | Howto

### Also see [ssh tunnelling](ssh-tunnelling) for a simple machine to machine tunnel.

Suppose that elasticsearch is in a private subnet in its own VPC (Virtual Private Cloud) and you need to post data to it and visit Kibana from your laptop (workstation).

**[The terraform *chatterbox module* for building a temporary ec2 bastion.](https://github.com/devops4me/terraform-aws-chatterbox)**

The **production** method to accessing AWS Kibana inside a private subnet in a VPC (virtual private cloud) is either through **VPN**, **Incognito** or linking a corporate network with **Direct Connect**. That said, an ssh tunnel is very useful at times especially when developing, troubleshooting or performance testing.

## Prerequisites

The prerequisites before we can access private services from our laptop is that

- a VPC with an internet gateway has been created
- an EC2 instance has been launched within the VPC
- another VPC with a private subnet has been created
- a service (like AWS ElasticSearch) has been created

Article [[creating EC2 instance in a VPC with internet gateway|create vpc igw ec2]] covers the first two prerequisites. Article [[creating AWS ElasticSearch in VPC|elasticsearch in aws vpc]] which includes creating and accepting a VPC peering connection, covers the rest of the prerequisites.


## Step 1 - Create lines in `.ssh/config`

Once your DevOps tool builds the VPC with the EC2 instance and peers it with the elasticsearch VPC (or the other way round) it should finally inject ssh tunnel config lines into your `~/.ssh/config` file.

You decide on both the **`ssh.name`** and **`ssh.port`** (as long as its between 2000 and 16000).

```
Host <<ssh.name>>
StrictHostKeyChecking no
HostName <<ec2.public.ip>>
User <<ec2.user>>
IdentitiesOnly yes
IdentityFile <<path.to.key.pem>>
LocalForward <<ssh.port>> <<es.host>>:443
```

To resolve the lines inserted into `~/.ssh/config` we must inject the

- **`<<ssh.name>>`** to use on the command line
- **`<<ssh.port>>`** to use in url `https://localhost:<<ssh.port>>`
- **`<<ec2.public.ip>>`** public IP of EC2 instance
- **`<<ec2.user>>`** usually ubuntu
- **`<<path.to.key.pem>>`** EC2 private keypath
- **`<<es.host>>`** hostname of elasticsearch domain

## Step 2 - Run the SSH tunnel command

To create the SSH tunnel execute this command

```bash
ssh <<ssh.name>> -N # Note command hangs
```

The command will appear to hang and do nothing. Now you can access the service.

## Step 3 - Use SSH Tunnel via Browser and Rest API

### Browser Access

For a secure service like Kibana (from elasticsearch) you visit **`https://localhost:<<ssh.port>>/_plugin/kibana`**, confirm the security exception and access your service's web user interface. For http services you proceed unhindered.

### Rest API Access | Using Curl

Notice the localhost url and the port (we've used 4200) for an elasticsearch service.
Don't forget the `-k` switch to make curl ignore security certificates.

```bash
curl -k -XPUT https://localhost:4200/movies-db/movie/6 -d '{"director": "Manu Chau", "genre": ["Comedy","Sci-Fi"], "year": 1996, "actor": ["Jack Nicholson","Pierce Lake","Sarah Jessica Parker"], "title": "Mars Attacks!"}' -H 'Content-Type: application/json'
```

The reply should resemble this.

```json
{
   "_index":"movies-db",
   "_type":"movie",
   "_id":"6",
   "_version":1,
   "result":"created",
   "_shards":{
      "total":2,
      "successful":1,
      "failed":0
   },
   "_seq_no":2,
   "_primary_term":1
}
```


## Addeddum - Use safe and terraform

safe can create the public/private keypair, launch terraform to create your host, and then setup your ssh config.

By convention

- **`@private.key`** is placed in the **``*~/.ssh* folder
- a public key is derived and the bastion host is configured with it
- the **ssh.name** key is for memorability (eg es.dev, kubernetes.lab, etcd.canary)
- the ssh.name is postfixed with the eco minute and second fields so 15:47 is 547 and 10:12 is 012
- the ssh.port is postfixed by **`7`** then minute/second fields so 15:47 is 7547 and 10:12 is 7012
- safe pushes the ssh config into **`~/.ssh/config`**
- kicks off the tunnel in the background using say **`ssh kubernetes.lab.547 -N`**
- you can type say **`ssh kubernetes.lab.547`** to log in directly (and unhindered by public key fingerprints)
- the bastion carries key players like certificates, the AWS Cli, kubectl, postgres, rabbitmqctl and so on
