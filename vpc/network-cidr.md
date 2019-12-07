
# Understanding Subnets and CIDR Addressing

Knowing how CIDR (classless inter-domain routing), subnet and IP address allocation works is vital for creating AWS cloud networks especially using Terraform's **subnet_max** and **cidrsubnet** function. You can refer to these terraform modules that

- **[create a VPC subnets gateways and routes](https://github.com/devops4me/terraform-aws-vpc-network)**
- **[create subnets within an existing VPC](https://github.com/devops4me/terraform-aws-sub-network)**


## in_subnets_max | in_vpc_cidr

**How many addresses will each subnet contain** and **how many subnets can be carved out of the VPC's IP address pool**? These questions are answered by the vpc_cidr and the subnets_max variable.

The VPC Cidr default is 16 giving 65,536 total addresses and the subnets max default is 4 so **16 subnets** can be carved out with each subnet ready to issue 4,096 addresses.

Clearly the addresses per subnet multiplied by the number of subnets cannot exceed the available VPC address pool. To keep your powder dry, ensure **in_vpc_cidr plus in_subnets_max does not exceed 31**.

## number of subnets constraint

It is unlikely **in_num_private_subnets + in_num_public_subnets** will exceed the maximum number of subnets that can be carved out of the VPC. Usually it is a lot less but be prudent and ensure that **in_num_private_subnets + in_num_public_subnets < 2<sup>in_subnets_max</sup>**


## subnet cidr blocks | cidrsubnet function

You do not need to specify each subnet's CIDR block because they are calculated by passing the VPC Cidr (in_vpc_cidr), the Subnets Max (in_subnets_max) and the present subnet's index (count.index) into Terraform's **cidrsubnet function**.

The behaviour of Terraform's **cidrsubnet function** is involved but slightly outside the scope of this VPC/Subnet module document. Read **[Understanding the Terraform Cidr Subnet Function](http://www.devopswiki.co.uk/terraform/terraform-cidrsubnet-function)** for a fuller coverage of cidrsubnet's behaviour.


---


## in_subnets_max | variable

This variable defines the maximum number of subnets that can be carved out of your VPC (you do not need to use them all). It then combines with the VPC Cidr to define the number of **addresses available in each subnet's** pool.

### 2<sup>32 - (in_vpc_cidr + in_subnets_max)</sup> = number of subnet addresses

A **vpc_cidr of 21 (eg 10.42.0.0/21)** and **subnets_max of 5** gives a pool of **2<sup>32-(21+5)</sup> = 64 addresses** in each subnet. (Note it is actually 2 less). We can carve out **2<sup>5</sup> = 32 subnets** as in_subnets_max is 5.

### Dividing VPC Addresses into Subnet Blocks

| vpc cidr  | subnets max | number of addresses per subnet                          | max subnets                 | vpc addresses total                  |
|:---------:|:-----------:|:------------------------------------------------------- |:--------------------------- |:------------------------------------ |
|  /16      |   6         | 2<sup>32-(16+6)</sup> = 2<sup>10</sup> = 1024 addresses | 2<sup>6</sup> = 64 subnets  | 2<sup>32-16</sup> = 65,536 addresses |
|  /16      |   4         | 2<sup>32-(16+4)</sup> = 2<sup>12</sup> = 4096 addresses | 2<sup>4</sup> = 16 subnets  | 2<sup>32-16</sup> = 65,536 addresses |
|  /20      |   8         | 2<sup>32-(20+8)</sup> = 2<sup>4</sup>  = 16 addresses   | 2<sup>8</sup> = 256 subnets | 2<sup>32-20</sup> = 4,096 addresses  |
|  /20      |   2         | 2<sup>32-(20+2)</sup> = 2<sup>10</sup> = 1024 addresses | 2<sup>2</sup> = 4 subnets   | 2<sup>32-20</sup> = 4,096 addresses  |

Check the below formula holds true for every row in the above table.

<pre><code>addresses per subnet * number of subnets = total available VPC addresses</code></pre>

