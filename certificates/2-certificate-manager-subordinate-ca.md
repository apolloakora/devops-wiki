
# Step 2 | Create AWS Certificate Manager Subordinate CA

## Why can't we create a Root CA in AWS CM

The root CA should not directly issue certificates and have its private key here there and everywhere.

In production your root CA should be created on an offline computer with WIFI and network interfaces removed.

So in AWS your private certificate authority is subordinate to your offline root certificate authority. The Root CA will sign the subordinate's CSR to give it permission to issue certificates on the Root CA's behalf.


## How to Create a Subordinate CA in Certificate Manager

**[This AWS document has the screenshots and steps for creating a private certificate authority](https://aws.amazon.com/blogs/aws/aws-certificate-manager-launches-private-certificate-authority/)**.


Try to get this right as you can't update the fields of a subordinate CA in Certificate Manager. If you mess up then delete the CA and set the actual deletion time to 7 days. You have a limit of 10 CAs but you can raise a ticket to have that increased.

In the AWS Console go to certificate manager and select the **Private CAs** menu option.

Reference your **[planned subject fields table in Step 1](1-certificate-subject-fields)**.

- click on Create CA
- opt for a subordinate certificate authority
- enter the 6 fields as discussed in step 1
- opt for the default algorithm with a 2048 bit key
- skip over the S3 bucket revocation
- create the private certificate authority
- opt to Import the CA Certificate

## Download the CSR (Certificate Signing Request)

```
/path/to/cm-subordinate-csr.pem
```

In the background certificate manager has created a **private key for your certificate authority** and using that key it has generated a certificate signing request file in pem format.

Download the certificate signing request named **`cm-subordinate-csr.pem`** to a path of your choice.

You are now ready to create your root CA and sign the CSR you have just downloaded.
