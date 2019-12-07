
# Terraform Loops and Conditional | Control Flow

${var.create_eip == true ? 1 : 0}

module "frontend" {
  source = "/modules/frontend-app"
  box_name = "web-01"
  ami = "ami-25615740"
  instance_type = "t2.micro"
  create_eip = true
}

Based on HCL semantics, setting the create_eip to true would result in the ternary operation ${var.create_eip == true ? 1 : 0} resolving to value of 1. This means a value of 1 would be passed on to the count parameter of the aws_eip resource. This would create one eip resource.

# frontend-app module
variable "create_eip" {
  description = "Create an EIP if set to True"
}

resource "aws_eip" "web-eip" {
  count = "${var.create_eip == true ? 1 : 0}"
  instance = "${aws_instance.example.id}"
}

If-Else Statement Create an if-else statement in a similar manner. Take a careful look at the following if-eip, else-eip example. We will use two tenary operations to achieve if-else.

module "frontend" {
  source = "/modules/frontend-app"
  box_name = "web-01"
  ami = "ami-25615740"
  instance_type = "t2.micro"
  create_first_eip = true
}

# frontend-app module
variable "create_first_eip" {
  description = "Create the first eip if set to true, otherwise create the second eip if set to false"
}

resource "aws_eip" "if-eip" {
  count = "${var.create_first_eip == true ? 1 : 0}"
  instance = "${aws_instance.example.id}"
}

resource "aws_eip" "else-eip" {
  count = "${var.create_first_eip == false ? 1 : 0}"
  instance = "${aws_instance.example.id}"
}


