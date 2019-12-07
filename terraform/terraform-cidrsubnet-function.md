
# Terraform's CidrSubnet Function

The cidrsubnet function is extremely useful but poorly understood and not helped by its pithy official documentation.

    cidrsubnet( 10.42.0.0/20, 4, count.index )

The 3 parameters are

- the VPC CIDr denoting the total number of addresses **2<sup>32-20</sup>** (4,096)
- the 2nd parameter as a power of 2 is the number of subnets available
- the loop index runs from 0 to one less than the number of subnets

## Cidr | Total Number of Addresses in VPC

The number after the slash denotes the total number of addresses. It runs from 1 to 32.

The total number of addresses is two to the power of 32 take away the number after the slash.

| number | total addresses | formula           |
|:------:|:--------------- |:----------------- |
|  /16   |   65,536        | 2^(32-16) = 2^16  |
|  /18   |   16,384        | 2^(32-18) = 2^14  |
|  /20   |    4,096        | 2^(32-20) = 2^12  |
|  /22   |    1,024        | 2^(32-22) = 2^10  |
|  /24   |      256        | 2^(32-24) = 2^8   |
|  /26   |       64        | 2^(32-26) = 2^6   |
|  /28   |       16        | 2^(32-28) = 2^4   |
|  /30   |        4        | 2^(32-30) = 2^2   |

## terraform cidrsubnet | the (maximum) number of subnets

Two to the power of the second parameter is the (maximum) number of subnets available in your VPC. We say maximum because you do not have to use all of them.

Rule = the number after the slash in the first parameter plus the number in the second parameter cannot exceed 32.

### The Number of Addresses in Each Subnet

The second parameter also denotes the number of addresses in each subnet. Its simple division so more subnets means less addresses within a subnet and vice versa.

    2<sup>32 - (1st param number + 2nd parameter)</sup> = the number of addresses in each subnet
    

## cidrsubnet | Dividing VPC addresses into Subnet Blocks

| VPC Cidr  | 2nd Param  | number of addresses per subnet                          | number of subnets           | number of VPC addresses              |
|:---------:|:----------:|:------------------------------------------------------- |:--------------------------- |:------------------------------------ |
|  /16      |   6        | 2<sup>32-(16+6)</sup> = 2<sup>10</sup> = 1024 addresses | 2<sup>6</sup> = 64 subnets  | 2<sup>32-16</sup> = 65,536 addresses |
|  /16      |   4        | 2<sup>32-(16+4)</sup> = 2<sup>12</sup> = 4096 addresses | 2<sup>4</sup> = 16 subnets  | 2<sup>32-16</sup> = 65,536 addresses |
|:---------:|:----------:|:------------------------------------------------------- |:--------------------------- |:------------------------------------ |
|  /20      |   8        | 2<sup>32-(20+8)</sup> = 2<sup>4</sup>  = 16 addresses   | 2<sup>8</sup> = 256 subnets | 2<sup>32-20</sup> = 4,096 addresses  |
|  /20      |   2        | 2<sup>32-(20+2)</sup> = 2<sup>10</sup> = 1024 addresses | 2<sup>2</sup> = 4 subnets   | 2<sup>32-20</sup> = 4,096 addresses  |


Check this formula holds true for every row above.

   addresses per subnet * number of subnets = total available VPC addresses

## terraform cidrsubnet | count.index

The loop index starts at zero and can run up to one less than the number of subnets ( two to the power of the second parameter ).

Note that it doesn't have to eat up all the available subnets. The first row in the table above allows a maximum of 64 subnets - however your loop index can run from 0 to 5 leaving 58 subnets available for use.

Often when continuing on from an earlier provisioning run, the below is common for the final index.

      (number of subnets used + count.index)


## cidrsubnet | The Returned Subnet Cidr

The point of all this is to return a subnet CIDr at the position denoted by the loop index. A loop index of 3 returns the CIDr block for the 4th subnet.

> cidrsubnet("100.121.0.0/20", 8,64)
100.121.4.0/28
> cidrsubnet("100.121.0.0/20", 8,128)
100.121.8.0/28
> cidrsubnet("100.121.0.0/20", 5,4)
100.121.2.0/25
> cidrsubnet("100.121.0.0/20", 5,10)
100.121.5.0/25
> cidrsubnet("100.121.0.0/16", 12,2)
100.121.0.32/28


$ ipcalc 100.121.0.0/20 /25
Address:   100.121.0.0          01100100.01111001.0000 0000.00000000
Netmask:   255.255.240.0 = 20   11111111.11111111.1111 0000.00000000
Wildcard:  0.0.15.255           00000000.00000000.0000 1111.11111111
=>
Network:   100.121.0.0/20       01100100.01111001.0000 0000.00000000
HostMin:   100.121.0.1          01100100.01111001.0000 0000.00000001
HostMax:   100.121.15.254       01100100.01111001.0000 1111.11111110
Broadcast: 100.121.15.255       01100100.01111001.0000 1111.11111111
Hosts/Net: 4094                  Class A

Subnets after transition from /20 to /25

Netmask:   255.255.255.128 = 25 11111111.11111111.11111111.1 0000000
Wildcard:  0.0.0.127            00000000.00000000.00000000.0 1111111

 1.
Network:   100.121.0.0/25       01100100.01111001.00000000.0 0000000
HostMin:   100.121.0.1          01100100.01111001.00000000.0 0000001
HostMax:   100.121.0.126        01100100.01111001.00000000.0 1111110
Broadcast: 100.121.0.127        01100100.01111001.00000000.0 1111111
Hosts/Net: 126                   Class A

 2.
Network:   100.121.0.128/25     01100100.01111001.00000000.1 0000000
HostMin:   100.121.0.129        01100100.01111001.00000000.1 0000001
HostMax:   100.121.0.254        01100100.01111001.00000000.1 1111110
Broadcast: 100.121.0.255        01100100.01111001.00000000.1 1111111
Hosts/Net: 126                   Class A

 3.
Network:   100.121.1.0/25       01100100.01111001.00000001.0 0000000
HostMin:   100.121.1.1          01100100.01111001.00000001.0 0000001
HostMax:   100.121.1.126        01100100.01111001.00000001.0 1111110
Broadcast: 100.121.1.127        01100100.01111001.00000001.0 1111111
Hosts/Net: 126                   Class A

... <snip> ...

 31.
Network:   100.121.15.0/25      01100100.01111001.00001111.0 0000000
HostMin:   100.121.15.1         01100100.01111001.00001111.0 0000001
HostMax:   100.121.15.126       01100100.01111001.00001111.0 1111110
Broadcast: 100.121.15.127       01100100.01111001.00001111.0 1111111
Hosts/Net: 126                   Class A

 32.
Network:   100.121.15.128/25    01100100.01111001.00001111.1 0000000
HostMin:   100.121.15.129       01100100.01111001.00001111.1 0000001
HostMax:   100.121.15.254       01100100.01111001.00001111.1 1111110
Broadcast: 100.121.15.255       01100100.01111001.00001111.1 1111111
Hosts/Net: 126                   Class A


Subnets:   32
Hosts:     4032
So, the netnum would be the subnet number exposed there, minus 1 because of indexing differences. (Note in the output from the web-based CGI ipcalc the subnet numbers are not displayed.)

$ terraform console
> cidrsubnet("100.121.0.0/20", 5, 30)
100.121.15.0/25


 cidr_block = "${cidrsubnet("100.121.0.0/20", 8, count.index )}"
assuming count = 3 would give us the subnets:

100.121.0.0/28
100.121.0.16/28
100.121.0.32/28
