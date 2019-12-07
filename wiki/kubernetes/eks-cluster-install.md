
# How to Create an EKS (Elastic Kubernetes Cluster) using Terraform


- Decide on your region and availability zones.
- Change the aws_ami filter search string depending on the region
- Go to IAM and add the below policy JSON to the user

Ensure that 

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

