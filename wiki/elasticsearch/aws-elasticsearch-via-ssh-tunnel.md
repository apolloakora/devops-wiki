
# SSH Tunnel Access to AWS ElasticSearch Domain and Kibana | Howto

ElasticSearch is in a private subnet in its own VPC (Virtual Private Cloud) and you need to post data to it and visit Kibana from your laptop (workstation).

The **production** method to accessing AWS Kibana inside a private subnet in a VPC (virtual private cloud) is through **VPN**, **Incognito** or linking a corporate network with **Direct Connect**.

Sometimes during dev, testing and validation you'll want access ElasticSearch and Kibana from your machine using a SSH tunnel. This howto shows you how to.

## Prerequisites | Accessing ElasticSearch in an AWS VPC from a Workstation

The prerequisites before we can access elasticsearch from our laptop is that

- a VPC with an internet gateway has been created
- an EC2 instance has been launched within the VPC
- another VPC with a private subnet has been created
- an AWS ElasticSearch domain has been created within that
- a peering connection between the VPCs has been setup

Article [[creating EC2 instance in a VPC with internet gateway|create vpc igw ec2]] covers the first two prerequisites. Article [[creating AWS ElasticSearch in VPC|elasticsearch in aws vpc]] which includes creating and accepting a VPC peering connection, covers the rest of the prerequisites.


## Steps | Connect to AWS ElasticSearch via SSH Tunnel and Port Forwarding

Connection entails

- creating lines in `.ssh/config`
- running a `ssh <<ssh.name>> -N` command
- visiting url `https://localhost:4200/_plugin/kibana`


### Create lines in `.ssh/config`

Once your DevOps tool builds the VPC with the EC2 instance and peers it with the elasticsearch VPC (or the other way round) it should finally inject ssh tunnel config lines into your `~/.ssh/config` file.
Here is an example file.

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

- `<<ssh.name>>` to use on the command line
- `<<ssh.port>>` to use in url `https://localhost:<<ssh.port>>`
- `<<ec2.public.ip>>` public IP of EC2 instance
- `<<ec2.user>>` usually ubuntu
- `<<path.to.key.pem>>` EC2 private keypath
- `<<es.host>>` hostname of elasticsearch domain

### Run the SSH tunnel command

To create the SSH tunnel execute this command

```bash
ssh <<ssh.name>> -N # Note command hangs
```

The command will appear to hang and do nothing. Now you can access Kibana.

### Accessing Kibana

Visit the url `https://localhost:<<ssh.port>>/_plugin/kibana`, confirm the security exception and you are through to Kibana.

### Posting Data using Curl

Notice the localhost url and the port (we've used 4200).
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
