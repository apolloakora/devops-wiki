

# Provision SSL Certificates from AWS Certificate Manager | Use Case

## The Simplest Pain-Free Way

Provisioning an SSL Certificate through AWS Certificate Manager is simple and pain free if you have purchased the domain through the AWS Route53 service and you are hosting the website or web service on the Amazon cloud platform typically employing CloudFront as a gatekeeper for incoming requests.

- no generating certificate signing requests
- no complicated adding of CName records to DNS
- no certificate and key handling - no storage
- no certificate installation into web servers like nginx and apache
- no renewal process - they just roll over indefinitely
- use as many wildcards ( www.example.com lab.example.com git.example.com ) as you want

## Not Automation Friendly

<pre>
It doesn't pay to automate neither the domain registration nor the SSL certificate provisioning process when using the AWS Certificate Manager. These use cases include AWS validation steps which can take an arbitrary amount of time making it unsuitable during an automated devops eco-system provisioning run.
</pre>


## Provision SSL Certs from AWS Certificate Manager | Pre-Conditions

Check that

- your domain name is sitting pretty in Route53
- your account has administrator access
- you know the sub-domains you want (you can add more later)
- you know the email domains if your certs will be used for mail exchange (MX)
- you limit the sub-domains to 10 or less
- you limit your active certificates count to under 100 a year

Sub-domains can also be called **ssl wildcards**. Plain your subdomains so

- www.devopswiki.co.uk | for the main website
- git.devopswiki.co.uk | for git repositories
- api.devopswiki.co.uk | for Rest API Microservices
- kubernetes.devopswiki.co.uk | for Kubernetes Cluster Management
- ci.devopswiki.co.uk | for continuous integration

## Provision SSL Certificates from ACM | Use Case Steps

- select AWS Certificate Manager from the main console menu.
- enter the root domain (eg devopswiki.co.uk)
- enter sub-domains
- continue and open up each domain and subdomain
- click on the using Route53 button
- continue and wait for verification

After a time the certificates will be ready as is shown in the screenshot.


## Install SSL Certificates

We need to configure the SSL certificates so that they are presented during website requests, REST API requests and and email exchanges.

We do this either by exporting the certificates and private keys, or by configuring one of these AWS services

- CloudFront - which manages incoming web requests
- ELB (Elastic Load Balancer) - for scaling resources in response to request volumes
- CloudFlare - Dns management service
- Elastic Beanstalk - for managing the deployment of Java and other apps

### NGinX | Configuring HTTPS/SSL Certificates

NGinX is the web server of choice if we don't use one of the above AWS services which to talk directly to the certificate manager (ACM). NGinX is usually used in a **reverse proxy pattern** setup. NGinX can also handle email for the domain.
