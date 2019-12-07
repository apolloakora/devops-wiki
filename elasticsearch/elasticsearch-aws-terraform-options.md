
## resource | aws_elasticsearch_domain

This is the terraform SCHEMA that maps to the AWS ElasticSearch cluster service infrastructure.


- access_policies
- advanced_options
- domain_name (required) ~> must start with a lowercase alphabet and be at least 3 and no more than 28 characters long. Valid characters are a-z (lowercase letters), 0-9, and - (hyphen).", k))
- arn                    (computed)
- domain_id              (computed)
- endpoint               (computed)
- kibana_endpoint        (computed)

- ebs_options.ebs_enabled (required) boolean
- ebs_options.iops        (optional)  integer ~> makes sense only when EBS storage is provisioned (whatever that means)
- ebs_options.volume size (optional)  integer
- ebs_options.volume_type (optional and computed) string

- encrypt_at_rest (optional and computed) list
- encrypt_at_rest.enabled (required) boolean
- encrypt_at_rest.kms_key_id (optional) string

- cluster_config (optional and computed) list
- cluster_config.dedicated_master_count (optional)  integer
- cluster_config.dedicated_master_enabled (optional) boolean
- cluster_config.dedicated_master_type (optional) string
- cluster_config.instance_count integer
- cluster_config.instance_type string Default is m3.medium.elasticsearch
- cluster_config.zone_awareness_enabled boolean

- snapshot_options (list)
- snapshot_options.automated_snapshot_start_hour (required) integer

- vpc_options (list)
- vpc_options.availability_zones set of strings
- vpc_options.security_group_ids set of strings
- vpc_options.subnet_ids set of strings
- vpc_options.vpc_id string


- log_publishing_options (set)
- log_publishing_options.log_type   (weird string in slice)
- log_publishing_options.cloudwatch_log_group_arn string (required)
- log_publishing_options.enabled boolean

- elasticsearch_version string (default is 1.5)

- cognito_options (list) with enabled, user_pool_id, identity_pool_id and role_arn

## ElasticSearch EC2 Instance Types | Support Encryption at Rest

Here are the list of instance types available.

- m4.large.elasticsearch
- m4.xlarge.elasticsearch
- m4.2xlarge.elasticsearch
- m4.4xlarge.elasticsearch
- m4.10xlarge.elasticsearch
- c4.large.elasticsearch
- c4.xlarge.elasticsearch
- c4.2xlarge.elasticsearch
- c4.4xlarge.elasticsearch
- c4.8xlarge.elasticsearch
- r4.large.elasticsearch
- r4.xlarge.elasticsearch
- r4.2xlarge.elasticsearch
- r4.4xlarge.elasticsearch
- r4.8xlarge.elasticsearch
- r4.16xlarge.elasticsearch
- i2.xlarge.elasticsearch
- i2.2xlarge.elasticsearch


## resource | aws_elasticsearch_domain_import

