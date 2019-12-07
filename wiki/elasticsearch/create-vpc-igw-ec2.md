<!--
parents = vpc
siblings = terraform, ec2, igw
class = howto
-->

# How to Create a VPC with an Internet Gateway

Beginners instantiate EC2 instances within a default VPC in which AWS has already setup an internet gateway. Here we create a new VPC, place an internet gateway within it and create an EC2 instance with a security group allowing us to SSH into it only from our own (automatically acquired) IP address.




```
resource "aws_vpc" "tfb" {

    cidr_block           = "${var.cidr}"
    enable_dns_hostnames = "${var.enable_dns_hostnames}"
    enable_dns_support   = "${var.enable_dns_support}"

    tags {
        Name = "${var.name}"
    }

}

resource "aws_internet_gateway" "tfb" {
me/apollo/Desktop/`' '/home/apollo/Desktop/`' 
    vpc_id = "${aws_vpc.tfb.id}"

    tags {
        Name = "${var.name}-igw"
    }

}

resource "aws_route" "internet_access" {

    route_table_id         = "${aws_vpc.tfb.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.tfb.id}"

}

resource "aws_subnet" "public" {

    vpc_id     = "${aws_vpc.tfb.id}"
    cidr_block = "${var.public_subnet}"

    tags {
        Name = "${var.name}-public"
    }
}
```
