
# AWS ElasticSearch in a VPC with Terraform

How to create an AWS ElasticSearch cluster (es domain) within a private subnet in a VPC (as opposed to a public endpoint) with Terraform is the subject of this text.

![elasticsearch logo](/media/elasticsearch-logo-panoramic.png "elasticsearch elastic.co logo")

Access to the ElasticSearch cluster will be via the

- **https VPC endpoint** with **VPC peering** to post (REST) JSON data
- **https Kibana Url** with a **VPN connection** to visualize the data 

We will use VPC peering to connect the ElasticSearch VPC with another VPC containing EC2 machines that will post data to cluster. Both services live inside non-overlapping private subnets.


## Prerequisites for ES Domain in Private Subnet in VPC

Terraform must be installed and the IAM user programmatic credentials must be present within the environment variables or in aws config file. We will also need

- an IAM user with the permissions listed below
- a created VPC that will be peer connected to the ES domain VPC
- the non overlapping subnet CIDR block within the twin peered VPC
- the twin VPC owner (yours truly) at hand to accept the VPC peering request
- the AWS account ID, region and availability zone

<img id="right30" src="/media/aws-cloud-square-logo.png" title="AWS Cloud Platform As A Service (PAAS)" />


## ElasticSearch and AWS Resources List

The infrastructure that will be created and managed by Terraform is

- a VPC for housing the new elasticsearch domain
- a subnet CIDR block from which the domains private IP address will be plucked
- a security group for the VPC allowing incoming port 443 (SSL) and anywhere egress
- an elasticsearch domain itself along with its onfiguuration including access policy
- a Route53 recordset against a zone for DNS access to the elasticsearch cluster
- a VPC peering connection request with the twin VPC's subnet as the destination
- a route with subnet CIDR destination and target as the **pcx** peering connection


## AWS Twin VPC Activities

The VPC hoping to access the new ElasticSearch domain needs a little work after the ElasticSearch cluster is created and the VPC connection peering request issued. We need to

- accept the VPC peering request
- add a route to the **just created VPC** with subnet destination and **pcx** peering connection target
- initiate a **validation salvo** of data posted to ElasticSearch

![terraform logo](/media/terraform-logo-rectangle.png "terraform infrastructure provisioning logo")


## ElasticSearch Access Policy

We opt to allow AWS resources within peered VPC subnets to access the elasticsearch cluster.

<pre>
**Allow associated security groups within your VPC full access to the domain.**
</pre>

This can be achieved with the below JSON access policy embedded as a Here document within Terraform.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:eu-west-1:12345678901234:domain/elastic-stack-19115-1402/*"
    }
  ]
}
```

This policy is a superset of the ( **Do not require signing request with IAM credential** ) policy.