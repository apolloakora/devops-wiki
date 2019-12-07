
# AWS S3 Bucket Permissions and Policies

AWS S3 buckets and Git are ultimately the only two ***long term content storage solutions*** for many businesses. Even database content is eventually backed up on S3.

So knowing how S3 Bucket permissions and policies work is a key advantage.

## When do I use a ***S3 Bucket Policy***

Ask who will be using this bucket. If it is

- the ***general public***
- users from certain ***IP Addresses*** or referrers
- lots of IAM user accounts (in many groups)

then a ***bucket policy*** is best. This policy grants read only access to everyone.

- note the line with ***Principal***
- note the only ***Action*** is ***s3:GetObject***
- and resource array could contain many buckets

```json
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::examplebucket/*"]
    }
  ]
}
```

The below snippet grants ***FULL ACCESS*** to requests coming from a particular IP address (or range).

- note the ***Action*** line grants every action from the list of S3 actions.
- note you can also block certain addresses with ***NotIpAdress***

```json
{
    "Action": "s3:*",
    "Resource": "arn:aws:s3:::examplebucket/*",
    "Condition":
    {
       "IpAddress": {"aws:SourceIp": "54.240.143.0/24"},
       "NotIpAddress": {"aws:SourceIp": "54.240.143.188/32"} 
    } 
}
```

## IAM Policy vs S3 Bucket Policy

An IAM policy will not contain



## S3 buckets have no ***folder structure***

S3 buckets do not have folder structures. So ***s3://docs-bucket/path/to/document.pdf*** means that a file named ***path/to/document.pdf*** exists within the *docs_bucket*.

This is important because your permissions can only apply to 3 resource types.

## The 3 S3 Bucket Resource Types

As S3 buckets have no folders there are only 3 resource types and the example policy demonstrates them. This policy allows a user to list/create/delete folders in one bucket.

```json
{
    "Version": "2012-10-17",
    "Statement":
    [
	{
	    "Effect": "Allow",
	    "Action":
	    [
		"s3:GetBucketLocation",
		"s3:ListAllMyBuckets"
	    ],
	    "Resource": "arn:aws:s3:::*"
	},
	{
	    "Effect": "Allow",
	    "Action": ["s3:ListBucket"],
	    "Resource": ["arn:aws:s3:::@[@[project|id]|s3.bucket.name]"]
	},
	{
	    "Effect": "Allow",
	    "Action":
	    [
		"s3:PutObject",
		"s3:PutObjectAcl",
		"s3:GetObject",
		"s3:GetObjectAcl",
		"s3:DeleteObject"
	    ],
	    "Resource": ["arn:aws:s3:::@[@[project|id]|s3.bucket.name]/*"]
	}
    ]
}
```

See the 3 ***Resource*** lines that identify each of these resource types

1. the set of ***all your S3 buckets***
2. the S3 bucket in question
3. the items inside the S3 bucket

See the [[aws s3 permissions]] page for a list of all permissions catagorized by the 3 resource types above.

