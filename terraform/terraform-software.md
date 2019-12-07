
# Excellent Terraform Software

<pre>
#---------------------------------------------------
# Create AWS ALB
#---------------------------------------------------
resource "aws_lb" "alb" {
    #name_prefix        = "${var.name_prefix}-"
    name                = "${lower(var.name)}-alb-${lower(var.environment)}"
    security_groups     = ["${var.security_groups}"]
    subnets             = ["${var.subnets}"]
    internal            = "${var.lb_internal}"

    enable_deletion_protection  = "${var.enable_deletion_protection}"
    load_balancer_type          = "${var.load_balancer_type}"
    idle_timeout                = "${var.idle_timeout}"
    ip_address_type             = "${var.ip_address_type}"

    access_logs         = ["${var.access_logs}"]

    timeouts {
        create  = "${var.timeouts_create}"
        update  = "${var.timeouts_update}"
        delete  = "${var.timeouts_delete}"
    }

    lifecycle {
        create_before_destroy = true
    }

    tags {
        Name            = "${lower(var.name)}-alb-${lower(var.environment)}"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }
}
#---------------------------------------------------
# Create AWS LB target group
#---------------------------------------------------
resource "aws_lb_target_group" "alb_target_group" {
    name                 = "${lower(var.name)}-alb-tg-${lower(var.environment)}"
    port                 = "${var.backend_port}"
    protocol             = "${upper(var.backend_protocol)}"
    vpc_id               = "${var.vpc_id}"
    target_type          = "${var.target_type}"
    deregistration_delay = "${var.deregistration_delay}"

    tags {
        Name            = "${lower(var.name)}-alb-tg-${lower(var.environment)}"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }

    health_check {
        interval            = "${var.health_check_interval}"
        path                = "${var.health_check_path}"
        port                = "${var.health_check_port}"
        healthy_threshold   = "${var.health_check_healthy_threshold}"
        unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
        timeout             = "${var.health_check_timeout}"
        protocol            = "${var.backend_protocol}"
        matcher             = "${var.health_check_matcher}"
    }
    stickiness {
        type            = "lb_cookie"
        cookie_duration = "${var.cookie_duration}"
        enabled         = "${var.cookie_duration != 1 ? true : false}"
    }
}
#---------------------------------------------------
# Create AWS LB listeners
#---------------------------------------------------

resource "aws_lb_listener" "frontend_http" {
    count               = "${trimspace(element(split(",", var.alb_protocols), 1)) == "HTTP" || trimspace(element(split(",", var.alb_protocols), 2)) == "HTTP" ? 1 : 0}"

    load_balancer_arn   = "${aws_lb.alb.arn}"
    port                = "80"
    protocol            = "HTTP"

    "default_action" {
        target_group_arn    = "${aws_lb_target_group.alb_target_group.arn}"
        type                = "forward"
    }

    depends_on = ["aws_lb.alb","aws_lb_target_group.alb_target_group"]
}

resource "aws_lb_listener" "frontend_https" {
    count               = "${trimspace(element(split(",", var.alb_protocols), 1)) == "HTTPS" || trimspace(element(split(",", var.alb_protocols), 2)) == "HTTPS" ? 1 : 0}"

    load_balancer_arn   = "${aws_lb.alb.arn}"
    port                = 443
    protocol            = "HTTPS"
    certificate_arn     = "${var.certificate_arn}"
    ssl_policy          = "ELBSecurityPolicy-2016-08"
    default_action {
        target_group_arn    = "${aws_lb_target_group.alb_target_group.arn}"
        type                = "forward"
    }

    depends_on = ["aws_lb.alb","aws_lb_target_group.alb_target_group"]
}
#---------------------------------------------------
# Create AWS LB target group attachment
#---------------------------------------------------
resource "aws_lb_target_group_attachment" "alb_target_group_attachment" {
    #count               = "${length(var.target_ids)}"

    #availability_zone   = "all"
    target_group_arn    = "${aws_lb_target_group.alb_target_group.arn}"
    target_id           = "${element(var.target_ids, 0)}"
    #target_id           = "${element(var.target_ids, count.index)}"
    #target_id           = "${var.target_ids[count.index]}"
    port                = "${var.backend_port}"

    depends_on = ["aws_lb.alb","aws_lb_target_group.alb_target_group"]
}




#-----------------------------------------------------------
# Global or/and default variables
#-----------------------------------------------------------
variable "name" {
  description = "Name to be used on all resources as prefix"
  default     = "TEST-ALB"
}

variable "region" {
  description = "The region where to deploy this code (e.g. us-east-1)."
  default     = "us-east-1"
}

variable "environment" {
    description = "Environment for service"
    default     = "STAGE"
}

variable "orchestration" {
    description = "Type of orchestration"
    default     = "Terraform"
}

variable "createdby" {
    description = "Created by"
    default     = "Vitaliy Natarov"
}

variable "security_groups" {
    description = "A list of security group IDs to assign to the ELB. Only valid if creating an ELB within a VPC"
    type        = "list"
}

variable "subnets" {
    description = "A list of subnet IDs to attach to the ELB"
    type        = "list"
    default     = []
}

variable "lb_internal" {
    description = "If true, ALB will be an internal ALB"
    default     = false
}

variable "name_prefix" {
    description = "Creates a unique name beginning with the specified prefix. Conflicts with name"
    default     = "alb"
}

variable "enable_deletion_protection" {
    description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
    default     = false
}

# Access logs
variable "access_logs" {
    description = "An access logs block. Uploads access logs to S3 bucket. Can be used just for network LB!"
    type        = "list"
    default     = []
}

variable "load_balancer_type" {
    description = "The type of load balancer to create. Possible values are application or network. The default value is application."
    default     = "application"
}

variable "idle_timeout" {
    description = "The time in seconds that the connection is allowed to be idle. Default: 60."
    default     = "60"
}

variable "ip_address_type" {
    description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack"
    default     = "ipv4"
}

variable "timeouts_create" {
    description = "Used for Creating LB. Default = 10mins"
    default     = "10m"
}

variable "timeouts_update" {
    description = "Used for LB modifications. Default = 10mins"
    default     = "10m"
}

variable "timeouts_delete" {
    description = "Used for LB destroying LB. Default = 10mins"
    default     = "10m"
}

variable "vpc_id" {
    description = "Set VPC ID for ?LB"
}

variable "alb_protocols" {
    description = "A comma delimited list of the protocols the ALB accepts. e.g.: HTTPS"
    default     = "HTTP,HTTPS"
}

variable "target_type" {
    description = "The type of target that you must specify when registering targets with this target group. The possible values are instance (targets are specified by instance ID) or ip (targets are specified by IP address). The default is instance. Note that you can't specify targets for a target group using both instance IDs and IP addresses. If the target type is ip, specify IP addresses from the subnets of the virtual private cloud (VPC) for the target group, the RFC 1918 range (10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16), and the RFC 6598 range (100.64.0.0/10). You can't specify publicly routable IP addresses"
    default     = "instance"
}

variable "deregistration_delay" {
    description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds."
    default     = "300"
}

variable "backend_port" {
    description = "The port the service on the EC2 instances listen on."
    default     = 80
}

variable "backend_protocol" {
    description = "The protocol the backend service speaks. Options: HTTP, HTTPS, TCP, SSL (secure tcp)."
    default     = "HTTP"
}

variable "target_ids" {
    description = "The ID of the target. This is the Instance ID for an instance, or the container ID for an ECS container. If the target type is ip, specify an IP address."
    type        = "list"
    #default     = []
}

variable "certificate_arn" {
    description = "The ARN of the SSL Certificate. e.g. 'arn:aws:iam::XXXXXXXXXXX:server-certificate/ProdServerCert'"
    default     = ""
}

variable "health_check_healthy_threshold" {
    description = "Number of consecutive positive health checks before a backend instance is considered healthy."
    default     = 3
}

variable "health_check_interval" {
    description = "Interval in seconds on which the health check against backend hosts is tried."
    default     = 10
}

variable "health_check_path" {
    description = "The URL the ELB should use for health checks. e.g. /health"
    default     = "/"
}

variable "health_check_port" {
    description = "The port used by the health check if different from the traffic-port."
    default     = "traffic-port"
}

variable "health_check_timeout" {
    description = "Seconds to leave a health check waiting before terminating it and calling the check unhealthy."
    default     = 5
}

variable "health_check_unhealthy_threshold" {
    description = "Number of consecutive positive health checks before a backend instance is considered unhealthy."
    default     = 3
}

variable "health_check_matcher" {
    description = "The HTTP codes that are a success when checking TG health."
    default     = "200-299"
}

variable "cookie_duration" {
    description = "If load balancer connection stickiness is desired, set this to the duration in seconds that cookie should be valid (e.g. 300). Otherwise, if no stickiness is desired, leave the default."
    default     = 1
}


output "lb_name" {
    description = ""
    value       = "${aws_lb.alb.name}"
}

output "lb_arn" {
    description = "ARN of the lb itself. Useful for debug output, for example when attaching a WAF."
    value       = "${aws_lb.alb.arn}"
}

output "lb_arn_suffix" {
    description = "ARN suffix of our lb - can be used with CloudWatch"
    value       = "${aws_lb.alb.arn_suffix}"
}

output "lb_dns_name" {
    description = "The DNS name of the lb presumably to be used with a friendlier CNAME."
    value       = "${aws_lb.alb.dns_name}"
}

output "lb_id" {
    description = "The ID of the lb we created."
    value       = "${aws_lb.alb.id}"
}

output "lb_zone_id" {
    description = "The zone_id of the lb to assist with creating DNS records."
    value       = "${aws_lb.alb.zone_id}"
}

output "lb_listener_https_arn" {
    description = "The ARN of the HTTPS lb Listener we created."
    value       = "${element(concat(aws_lb_listener.frontend_https.*.arn, list("")), 0)}"
}

output "lb_listener_http_arn" {
    description = "The ARN of the HTTP lb Listener we created."
    value       = "${element(concat(aws_lb_listener.frontend_http.*.arn, list("")), 0)}"
}

output "lb_listener_https_id" {
    description = "The ID of the lb Listener we created."
    value       = "${element(concat(aws_lb_listener.frontend_https.*.id, list("")), 0)}"
}

output "lb_listener_http_id" {
    description = "The ID of the lb Listener we created."
    value       = "${element(concat(aws_lb_listener.frontend_http.*.id, list("")), 0)}"
}

output "target_group_arn" {
    description = "ARN of the target group. Useful for passing to your Auto Scaling group module."
    value       = "${aws_lb_target_group.alb_target_group.arn}"
}


#
# MAINTAINER Vitaliy Natarov "vitaliy.natarov@yahoo.com"
#
terraform {
  required_version = "> 0.9.0"
}
provider "aws" {
    region                  = "us-east-1"
    shared_credentials_file = "${pathexpand("~/.aws/credentials")}"
    profile                 = "default"
}
module "iam" {
    source                          = "../../modules/iam"
    name                            = "My-Security"
    region                          = "us-east-1"
    environment                     = "PROD"

    aws_iam_role-principals         = [
        "ec2.amazonaws.com",
    ]
    aws_iam_policy-actions           = [
        "cloudwatch:GetMetricStatistics",
        "logs:DescribeLogStreams",
        "logs:GetLogEvents",
        "elasticache:Describe*",
        "rds:Describe*",
        "rds:ListTagsForResource",
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs",
        "ec2:Owner",
    ]
}
module "vpc" {
    source                              = "../../modules/vpc"
    name                                = "My"
    environment                         = "PROD"
    # VPC
    instance_tenancy                    = "default"
    enable_dns_support                  = "true"
    enable_dns_hostnames                = "true"
    assign_generated_ipv6_cidr_block    = "false"
    enable_classiclink                  = "false"
    vpc_cidr                            = "172.31.0.0/16"
    private_subnet_cidrs                = ["172.31.32.0/20", "172.31.48.0/20"]
    public_subnet_cidrs                 = ["172.31.80.0/20"]
    availability_zones                  = ["us-east-1a", "us-east-1e"]
    enable_all_egress_ports             = "true"
    allowed_ports                       = ["8080", "3306", "443", "80"]

    map_public_ip_on_launch             = "true"

    #Internet-GateWay
    enable_internet_gateway             = "true"
    #NAT
    enable_nat_gateway                  = "false"
    single_nat_gateway                  = "true"
    #VPN
    enable_vpn_gateway                  = "false"
    #DHCP
    enable_dhcp_options                 = "false"
    # EIP
    enable_eip                          = "false"
}

module "ec2" {
    source                              = "../../modules/ec2"
    name                                = "TEST-Machine"
    region                              = "us-east-1"
    environment                         = "PROD"
    number_of_instances                 = 1
    ec2_instance_type                   = "t2.micro"
    enable_associate_public_ip_address  = "true"
    disk_size                           = "8"
    tenancy                             = "${module.vpc.instance_tenancy}"
    iam_instance_profile                = "${module.iam.instance_profile_id}"
    subnet_id                           = "${element(module.vpc.vpc-publicsubnet-ids, 0)}"
    #subnet_id                           = "${element(module.vpc.vpc-privatesubnet-ids, 0)}"
    #subnet_id                           = ["${element(module.vpc.vpc-privatesubnet-ids)}"]
    vpc_security_group_ids              = ["${module.vpc.security_group_id}"]

    monitoring                          = "true"
}
#module "kms" {
#    source               = "../../modules/kms"
#    name                 = "TEST-KMS"
#    environment          = "PROD"
#
#    aws_account_id       = "XXXXXXXXXXXXXXXXX"
#}
#module "s3" {
#    source                              = "../../modules/s3"
#    name                                = "My-backet"
#    environment                         = "PROD"
#
#    #
#    s3_acl          = "log-delivery-write"  #"private"
#    force_destroy   = "true"
#    # Allow public web-site (Static website hosting)
#    website         = [
#    {
#        index_document = "index.html"
#        error_document = "error.html"
#        #redirect_all_requests_to = "https://s3-website.linux-notes.org"
#    },
#    ]
#    # Use cors rules
#    cors_rule       = [
#    {
#        allowed_headers = ["*"]
#        allowed_methods = ["PUT", "POST"]
#        allowed_origins = ["https://s3-website.linux-notes.org"]
#        expose_headers  = ["ETag"]
#        max_age_seconds = 3000
#    },
#    ]
#
#    kms_master_key_id = "arn:aws:kms:${module.kms.region}:${module.kms.aws_account_id}:key/${module.kms.kms_key_id}"
#}
module "alb" {
    source                  = "../../modules/alb"
    name                    = "App-Load-Balancer"
    region                  = "us-east-1"
    environment             = "PROD"

    load_balancer_type          = "application"
    security_groups             = ["${module.vpc.security_group_id}", "${module.vpc.default_security_group_id}"]
    subnets                     = ["${module.vpc.vpc-privatesubnet-ids}"]
    vpc_id                      = "${module.vpc.vpc_id}"
    enable_deletion_protection  = false

    backend_protocol    = "HTTP"
    alb_protocols       = "HTTP"

    target_ids          = ["${module.ec2.instance_ids}"]

    #access_logs = [
    #    {
    #        enabled         = true
    #        bucket          = "${module.s3.bucket_name}"
    #        prefix          = "log"
    #    },
    #]

}

</pre>