
# Load Balancer Architecture

Yes load balancers are a law unto themselves but they play a kingly role in modern clustered infrastructure. Load balancers implement redundancy, scaling, routing, ssl termination and most importantly - a separation of concerns.

## The AWS Application Load Balancer

The AWS **application load balancer** module allows us to add one or more **front-end listeners** and one or more **back-end target groups** which can be ec2 instances, private IP addresses, auto-scaling groups or even other load balancers.

Traffic can be routed based on the **front-end** host **(aka host based routing)**, the request URI or the content. It can also be routed based on the **back-end load**, health or a strategy such as round robin delivery.

## External (Public Subnets) | Internal (Private Subnets)

For external load balancers with services in private subnets you use the vpc network module to create **twin public and private subnets** in each availability zone (usually 6). Give the load balancer the public subnets (in the same order) and create services in the private subnets.

Internal load balancers are not allowed to sit in public subnets and external load balancers are not allowed to sit in private subnets (but the services can and do).


---


## Architectural Advice | Load Balancers

Like we've said - load balancers are a law unto themselves and as such devops and infrastructure architects need to be aware of the architectural patterns surrounding load balancers. Also some tactical advice for engineers while considering how to use load balancers in the cloud.


## The Reverse Proxy Pattern | SSL Termination

This load balancer can implement the **reverse proxy pattern** by terminating SSL which is useful when backend services either cannot will not or should not work with SSL and/or manage SSL certificates within applications and containers.

As such the ID of the **ssl certificate** in AWS's certificate manager is typically provided to the load balancer's listener. These certificates are free and are automatically renewed which is highly attractive in contrast with the manual and costly nature of dealing with certificate authorities.


---


## Goodbye nginx

If you use nginx **only for SSL termination and/or reverse proxying** you should consider replacing it with an **application load balancer**. (Note that this also applies to the likes of Apache2 and WeBrick(Ruby).

A load balancer will perform better, is cheaper, simpler, more secure and inherently super scaleable. They scale to higher throughputs and loads without any performance degradation and they take the headaches of maintenance, upgrades, security and deployment off your shoulders.

AWS load balancers **can write access logs into an S3 bucket** further making the case to migrate away from traditional web servers.

That said, nginx is ideal for more complex workloads like url rewriting, email routing, caching and authentication.


---


## Serverless Infrastructure Pattern

The move to a **serverless infrastructure** is an undeniable upwards trend and **replacing traditional webservers with load balancers** achieves just that. Serverless comes into play when you use

- EKS (elastic kubernetes service)
- the managed AWS elasticsearch service
- RDS (MySQL and/or Postgres)  in the AWS cloud
- AWS Lambda
- cloud services like email (SES), DNS (Route53) and storage (S3)

Migrating towards load balancers and away from web servers is a step towards the serverless paradigm.


---


## Port Mapping

Load balancers can achieve port mapping between front-end listeners and back-end targets.

An example is the **[etcd3 cluster](https://github.com/devops4me/terraform-aws-etcd3-cluster/blob/master/etcd3.cluster-main.tf)** that maps the **back-end etcd port 2379** to the **front-end listener port 80**.

    module load-balancer
    {
        source               = "github.com/devops4me/terraform-aws-load-balancer"
        in_vpc_id            = "${ module.vpc-network.out_vpc_id }"
        in_subnet_ids        = "${ module.vpc-network.out_subnet_ids }"
        in_security_group_id = "${ module.security-group.out_security_group_id }"
        in_ip_addresses      = "${ aws_instance.node.*.private_ip }"
        in_front_end         = [ "web"  ]
        in_back_end          = [ "etcd" ]
        in_ecosystem         = "${ local.ecosystem_id }"
    }

The *in_front_end** defintion **web** is saying that the ubiquitous port 80 should be mapped to **etcd port 2379** as signaled by **in_back_end**.


---


## Goodbye VPC Peering

VPC peering allows services in the private subnets of different VPCs to talk to each other.

VPC peering encourages the hardcoding of one (or two) VPC IDs and a number of subnet IDs. It also adds complexity due to the routing and subnet associations that must be made.

**Consider using internal load balancers instead of VPC peering.** Services in private subnets of one VPC can talk to their peers in private subnets of another VPC through a load balancer without configuring VPC peering.

## Goodbye Bastion Hosts

Often proxying machines called bastion hosts are setup in a public subnet simply to allow connectivity to services in sister private subnets. IP tables and port forwarding are typically used to effect the connectivity.

Consider replacing bastion hosts with a load balancer. An externally accessible load balancer can route to services in private subnets thus negating the need for clumsy EC2 instances that risk becoming single points of failure in your architecture.


---


## Layer 7 Load Balancer vs Layer 4 Load Balancer

The AWS application load balancer is a (network) layer 7 load balancer which opens up incoming packets. Its ability to look into the request data means it can

- terminate HTTPS (SSL) traffic (when given a certificate)
- route traffic based on the request path and/or content
- route traffic based on the host including sticky sessions

A layer 4 **network load balancer** does not open up the message thus making it faster, but the trade-off is it does not have the capabilities of a layer 7 load balancer.


---


## Load Balancer Access Logs | 5 minutes | 60 minutes | none

We could write load balancer access logs to an S3 bucket every 5 minutes, 60 minutes or indeed never.

### Calculate Access Logs File Size

If the load balancer receives 5,000 requests per seconds how many file lines would result?

        5,000 x 60 x 60
        5,000 x 3,600
        5,000 x 3,600
        3,600,000 x 5
        18,000,000
        18 million lines

Now approximate the byte size of each line and then multiply out to determine roughly how big the file would be if produced

- every **5 minutes**
- every **hour**


---


## Important Advice | Public or Private Subnets

Use **public subnet ids** even when the **back-end targets** are in **private subnets** if you want a **public facing load-balancer front-end**. From the browser the load-balancer will just hang if you have used private subnets because you can't connect to a service in private subnets from the outside world.

The **vpc-network** module will provide the correct infrastructure to ensure services in private subnets can connect, via a NAT gateway and routes, to the internet.

If you desire an internal load balancer then use private subnet IDs. Your load balancer will be available through a VPN or bastion host, and it will be **accessible to services in any VPCs for the same account** without the need for a peering connection.


---


## Load Balancer Gotchas | Common Errors

### 1. Subnets in the same availability zone

Load balancers will error saying that traffic will not be routed to two or more subnets in the same availability zone if that is what has been provided.


## 2. 504 Gateway Time-out | Security Group

A **504 Gateway Time-out** error from your browser means that a **security group is blocking your application load-balancer** from initiating a connection using a given protocol on a given port.

Fix it by allowing **all-traffic** through then narrow the gap until you discover the missing security group rule.

---

