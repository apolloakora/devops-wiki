
# Terraform AWS Data Sources | Region | Zones | Account ID

### Avoid Hardcoding your AWS Account ID, Region and other sensitive information.

Most terraformers hardcode their AWS account ID, region and availability zones. There is no need to check these into git (source control), nor put them in configuration files.

'''**Hackers get a headstart if you declare your account ID and other locators.**'''

This hardcoding makes your software brittle, breaking it if you deploy to another AWS region.

| **Description** | **Data Source** | **Type** | **Example Text** | **Exported Attributes** | **Notes** |
|:--------------- |:--------------- |:-------- |:----------------------- |:----------------------- |
AWS Account Id (digits) | **aws_caller_identity** | String | 1234567890 | account_id | **${data.aws_caller_identity.with.account_id}**
AWS Region Id | **aws_region** | String | eu-west-2 | name, endpoint, description | Description states Location Paris or Location Dublin


## Terraform | Declaring a Data Source

To use the above data sources define the

## Terraform | Using data source Attributes with Interpolation

Before you can use the data inside a resource you must first **declare the data source** in any **.tf** file in the folder.

     data "aws_caller_identity" "with" {}
     ${data.aws_caller_identity.with.account_id}

     data "aws_region" "with" {}

## Summary | Terraform Data Sources

These data sources like the **AWS account ID** absolves us of the need to hardcode, **even in configuration files**. Why give hackers a head start?

Go ahead and make your Terraform software is less brittle and more portable.

## AWS Region

This datasource gives us the AWS region we are currently operating in for example **eu-west-2** or **us-east-1**.

     

## AWS Availability Zones

```hcl
data "aws_availability_zones" "indexed" {}
```

This datasource provides the list of availability zones in the current region. It has only one attribute which is names.

Here are some useful interpolation examples.

     ${data.aws_availability_zones.indexed.names[0]}      # name of the 1st availability zone
     ${data.data.aws_availability_zones.indexed.*.names}  # name of current zone in loop
     ${data.aws_availability_zones.indexed.all.names}     # names of all availability zones

