
# Errors Creating an EKS Cluster


## data.aws_ami.eks_worker | Your query returned no results

**module.eks_workers.data.aws_ami.eks_worker: 1 error(s) occurred:**

**module.eks_workers.data.aws_ami.eks_worker: data.aws_ami.eks_worker: Your query returned no results. Please change your search criteria and try again.**

The problem is AWS have named the UK and Frankfurt (europe) AMI's differently so we need to change the search filter.

### aws_ami filter for Europe (eu-west and eu-central)

``` json
data "aws_ami" "eks_worker"
{
    count = "${var.enabled == "true" && var.use_custom_image_id == "false" ? 1 : 0}"

    most_recent = true
    name_regex  = "${var.eks_worker_ami_name_regex}"

    filter
    {
        name   = "name"
        values = ["amazon-eks-*"]
    }

    most_recent = true
    owners      = ["602401143452"] # Amazon
}
```


### aws_ami filter for the US (eg us-east-1)

``` json
data "aws_ami" "eks_worker"
{
    count = "${var.enabled == "true" && var.use_custom_image_id == "false" ? 1 : 0}"

    most_recent = true
    name_regex  = "${var.eks_worker_ami_name_regex}"

    filter
    {
        name   = "name"
        values = ["${var.eks_worker_ami_name_filter}"]
    }

    most_recent = true
    owners      = ["602401143452"] # Amazon
}
```




##  AccessDeniedException | eks:CreateCluster

**aws_eks_cluster.default: error creating EKS Cluster (eg-testing-eks-cluster): AccessDeniedException: User: arn:aws:iam::123456789:user/es.curator is not authorized to perform: eks:CreateCluster on resource: arn:aws:eks:eu-west-1:123456789:cluster/eg-testing-eks-cluster**

### Solution | Create IAM Policy

The solution is to go to IAM and create a new policy using the below JSON statement. Name the policy, say access@eks.cluster and then go to the user and attach the policy directly to the user.

``` json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        }
    ]
}
```
