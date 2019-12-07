# Automating your Ubuntu Workstation Install

Formatting your drive and re-creating your Ubuntu workstation periodically (weekly) is an advantageous behaviour. Two important lean principles are

- if it hurts, do it more often
- (and) bring pain forward

So building your workstation weekly is a valuable practise.

***Leave it and the task looms larger and larger and gets more and more daunting as time goes by.***

Do it frequently and you ***absorb small shocks*** as you go along and gain much valued feedback on your behaviour in the past week. Now the rebuild is ***neither painful nor daunting*** as it's just one week's worth of creation activity to assimilate.

## Sync Down Publicly Available S3 Documentation

We want to have the books and documentation pertinent to our ***environment***, ***tools***, ***systems*** and ***practices*** readily available from publicly available registered S3 buckets.

Let's install the AWS tools and sync them down.

```bash
sudo apt-get update && sudo apt-get --assume-yes upgrade
sudo apt-get install --assume-yes awscli
aws --version
```



## Access S3 Bucket

Name is ***devops.books***


This policy created.
***policy.read-write.s3-bucket.devops.books***

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
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
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::@[@[project|id]|s3.bucket.name]/*"]
    }
  ]}

```

## Test AWS S3 Bucket User

Run the iam.users eco-system

Commands

Check that it can list the names of all buckets - that is a pre-requisite to the one-bucket read-write usage.
Test that the ONLY bucket it can list is devops.books
aws s3 ls s3://wiija.documents

An error occurred (AccessDenied) when calling the ListObjects operation: Access Denied

aws s3 ls s3://devops.books
aws s3 cp /media/apollo/6464-31A4/BitbucketServer_0410.pdf s3://devops.books/bitbucket.server.manual.pdf
upload: ../../media/apollo/6464-31A4/BitbucketServer_0410.pdf to s3://devops.books/bitbucket.server.manual.pdf

aws s3 ls s3://devops.books
2017-11-30 18:45:53   10894058 bitbucket.server.manual.pdf


<!--
@todo - Move Pandoc setup to Wiki Site Generator which reads from one repo and writes to another.
-->
