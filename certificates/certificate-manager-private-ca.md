
### Use a dockerized private certificate authority to sign and trust an AWS Certificate Manager subordinate CA which can then issue, renew, revoke and audit SSL certificates. 

# AWS Certificate Manager | Private CA (Certificate Authority)

To issue, renew, revoke and audit certificates is simple when you use AWS Certificate Manager and your own private certficate authority especially when the majority of your infrastructure resides in the AWS cloud.

With Certificate Manager you bypass the **painful periodic process of renewing certificates** and **certificate usage reports** detailing the who, when and from where are now within easy reach.

## Dockerized Root CA Creation and CSR Signing

You don't want to (and shouldn't) create a Root CA on your laptop. The dependencies on OpenSSL versions, Linux versions and the likelihood that you'll want to run multiple CAs all point towards a classic Docker use case.

In **[Step 4](4-dockerized-root-ca-use-cases)** we encounter the Dockerfile and the docker run command which

- reads your openssl.cnf file
- creates a root certificate authority and self-signed cert
- reads the CSR from AWS Certificate Manager
- signs the CSR with the Root CA's cert
- outputs a signed cert which is imported (with Root cert) into Certificate Manager


## Steps | The road to AWS CM and a Dockerized Root CA Management

### How to use a private Certificate Authority in AWS Certificate Manager

This step by step guide enables you to

- 1. **[configure certificate subject fields to sidestep subject mismatch exceptions](1-certificate-subject-fields)**
- 2. **[create a subordinate certificate authority in certificate manager](2-certificate-manager-subordinate-ca)**
- 3. **[configure an openssl.cnf file to create the Root Certificate Authority](3-create-openssl-cnf-config-file)**
- 4. **[use docker to create a root CA and sign the subordinate CA's CSR](4-dockerized-root-ca-use-cases)**
- 5. import the subordinate CA's signed certificate and certificate chain
- 6. create a Route53 hosted zone and private domain name
- 7. get the subordinate CA to issue an SSL certificate for your private domain name
- 8. configure a load balancer to serve the SSL certificate issued and held in CM
- 9. configure client operating systems and browsers to trust the certificate


## Summary | AWS Certificate Manager | Private Certificate Authority

There's a lot going on!

An ***offline root CA** is trusting a cloud based **subordinate CA** in **Certificate Manager** to issue SSL certificates for **private hosted zones** and domain names in **Route53**.


## Deep Dive | SSL Certificate Players

Route53 DNS directs client requests to a load balancer that has been configured to collect the issued certificate from Certicate Manager and present it on demand to the client that originates the request. The client's trust cache has a certificate with a common ancestry chain to the one presented by the load balancer and hence is happy to connect and talk to the services behind it.
