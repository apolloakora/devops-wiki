
# Terraform | Elastic (Classic) Load Balancer | Application Load Balancer | Nginx | S3 | CloudFront

The application load balancer relegates ELB to the legacy heap due to its superior flexibility, ease of use and feattures.

With an application load balancer you can route

- **route based on path**
- route based on the host
- **proxy to URLs** (ELB can only go to EC2 instances)
- route to multiple services running on one instance
- **authenticate users**
- perform redirects
- **setup (site down)** fixed response pages

**Use the application load balancer even if you don't think you need the extra features.**

However both can be configured for SSL termination (via an ACM SSL certificate), multiple listeners, health checks and proxying in every sense of the word.

## nginx vs (alb) application load balancer vs cloudfront vs s3 buckets

Here are some guidelines on choosing your sentinel at the gates to the internet.

- **use nginx** for complex SSL/TLS support, e-mail delivery, mx records and complex request or path based routing
- **use S3 buckets** as static websites if you have a lot of content (media) to serve - you can front it with nginx or ALB
- **use CloudFront CDN (Content Distribution Network)** if you need to service different geographic regions and use content caching
- **use ALB** if your service availability is paramount and you have a heavy compute bias (REST API, Kubernetes, dynamic websites)

ALB's availability is second to none whereas EC2 instances running nginx (even using auto scaling groups) tend to become (single) points of failure.


## Terraform Application Load Balancer Example




## Terraform Elastic (Classic) Load Balancer Example

    resource "aws_elb" "load-balancer"
    {
        count = "0"

        # -- Pass in only one or the other
        # -- of subnets and availability zones
        # -- (never both).

        name             = "lb-${var.in_eco_stamp}"
        security_groups  = [ "${var.in_sgroup_ids}" ]
        subnets          = [ "${var.in_subnet_ids}" ]
        idle_timeout     = 400
        instances        = [ "i-9892745928749", "i-345634566758567" ]

        listener
        {
            instance_port     = 443
            instance_protocol = "https"
            lb_port           = 443
            lb_protocol       = "https"
        }


        listener
        {
            instance_port      = 443
            instance_protocol  = "https"
            lb_port            = 443
            lb_protocol        = "https"
            ssl_certificate_id = "xxxxxxxxxxxxx"
        }


        health_check
        {
            healthy_threshold   = 2
            unhealthy_threshold = 2
            timeout             = 3
            target              = "HTTPS:443/"
            interval            = 30
        }

        access_logs
        {
            bucket        = "pot.devopswiki.access.logs"
            bucket_prefix = "production"
            interval      = 60
        }

        tags
        {
            Name = "lb-${var.in_eco_stamp}"
            Group = "${var.in_eco_stamp}"
        }

    }



