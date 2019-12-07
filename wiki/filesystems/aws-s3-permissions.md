
# AWS S3 Permissions List

To better understand S3 bucket resources note that there are 3 S3 Bucket ***Resource*** types.

1. the set of ***all your S3 buckets***
2. the S3 bucket in question
3. the items inside the S3 bucket

## Permissions for the 3 S3 Bucket Resources

S3 bucket policies contain permissions targetted at either the ***all bucket*** level, the ***one bucket*** and the ***one bucket contents level***.

### All Bucket Permissions

- s3:CreateBucket
- s3:DeleteBucket
- s3:ListBucket
- s3:ListBucketVersions
- s3:ListAllMyBuckets
- s3:ListBucketMultipartUploads

### Permmisions for Items Inside an S3 Bucket

- s3:AbortMultipartUpload
- s3:DeleteObject
- s3:DeleteObjectTagging
- s3:DeleteObjectVersion
- s3:DeleteObjectVersionTagging
- s3:GetObject
- s3:GetObjectAcl
- s3:GetObjectTagging
- s3:GetObjectTorrent
- s3:GetObjectVersion
- s3:GetObjectVersionAcl
- s3:GetObjectVersionTagging
- s3:GetObjectVersionTorrent
- s3:ListMultipartUploadParts
- s3:PutObject
- s3:PutObjectAcl
- s3:PutObjectTagging
- s3:PutObjectVersionAcl
- s3:PutObjectVersionTagging
- s3:RestoreObject

### Permmisions for a Given S3 Bucket

- s3:DeleteBucketPolicy
- s3:DeleteBucketWebsite
- s3:DeleteReplicationConfiguration
- s3:GetAccelerateConfiguration
- s3:GetAnalyticsConfiguration
- s3:GetBucketAcl
- s3:GetBucketCORS
- s3:GetBucketLocation
- s3:GetBucketLogging
- s3:GetBucketNotification
- s3:GetBucketPolicy
- s3:GetBucketRequestPayment
- s3:GetBucketTagging
- s3:GetBucketVersioning
- s3:GetBucketWebsite
- s3:GetEncryptionConfiguration
- s3:GetInventoryConfiguration
- s3:GetLifecycleConfiguration
- s3:GetMetricsConfiguration
- s3:GetReplicationConfiguration
- s3:PutAccelerateConfiguration
- s3:PutAnalyticsConfiguration
- s3:PutBucketAcl
- s3:PutBucketCORS
- s3:PutBucketLogging
- s3:PutBucketNotification
- s3:PutBucketPolicy
- s3:PutBucketRequestPayment
- s3:PutBucketTagging
- s3:PutBucketVersioning
- s3:PutBucketWebsite
- s3:PutEncryptionConfiguration
- s3:PutInventoryConfiguration
- s3:PutLifecycleConfiguration
- s3:PutMetricsConfiguration
- s3:PutReplicationConfiguration


## Learn about AWS S3 Policies

Visit [[aws s3 policy]]

AWS S3 buckets and Git are ultimately the only two ***long term content storage solutions*** for many businesses. Even database content is eventually backed up on S3. So knowing how S3 Bucket permissions and policies work is a key advantage.
