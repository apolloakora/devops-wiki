
# Terraform | Access IDs of Resources we have not created

Sometimes we need to access (and work with) a resource that we have not created. Often we need to reference the ID of the resource such as

- the **default VPC** for the AWS region
- the **default subnet** in a VPC's availability zone
- the **default security group** in a VPC
- the **default route table** in a VPC

## How to retreive the ID of the default VPC 

    data aws_vpc default
    {
        default = true
    }

Now we can issue a call to access the **ID of the default VPC**.

    ${ data.aws_vpc.default.id }


data "aws_subnet" "default" {
  vpc_id            = "${data.aws_vpc.default.id}"
  default_for_az    = true
  availability_zone = "${var.availability_zone}"
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.vpc.id}"
}


Of course you can enhance it further to put it in a module which takes `use_default` boolean and manipulate the logic between creating a new VPC or reuse a default one.
Something like:

resource "aws_vpc" "new_vpc" {
  count      = "${var.use_default == "true" ? 0 : 1}"
  cidr_block = "${var.vpc_cidr_block}"
}

data "aws_vpc" "vpc" {
  id = "${var.use_default == "true" ? data.aws_vpc.default.id : join(" ", aws_vpc.new_vpc.*.id)}"
}

resource "aws_subnet" "new_subnet" {
  count             = "${var.use_default == "true" ? 0 : 1}"
  cidr_block        = "${cidrsubnet(aws_vpc.new_vpc.cidr_block, 4, count.index + 1)}"
  vpc_id            = "${aws_vpc.new_vpc.id}"
  availability_zone = "${var.availability_zone}"
}

data "aws_subnet" "subnet" {
  id = "${var.use_default == "true" ? data.aws_subnet.default.id : join(" ", aws_subnet.new_subnet.*.id)}"
}


output "vpc_id" {
  value = "${data.aws_vpc.vpc.id}"
}

output "subnet_id" {
  value = "${data.aws_subnet.subnet.id}"
}

output "subnet_cidr_block" {
  value = "${data.aws_subnet.subnet.cidr_block}"
}

output "vpc_cidr_block" {
  value = "${data.aws_vpc.vpc.cidr_block}"
}

