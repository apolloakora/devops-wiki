
### CertificateMismatchException The certificate version must be greater than or equal to 3

# Step 1 | Avoid Certificate Subject Mismatch Exception

Days can turn to weeks when troubleshooting certificate subject field exceptions thrown by the AWS Certificate Manager. The planning you do now circumvents a lot of unnecessary troubleshooting later.

```
Subject: C = GB, ST = England, L = London, O = DevOps Wiki, OU = Engineering, CN = devopswiki.cloud
```

## Certificate Subject Field Lessons

The 3 hardest learnt lessons the AWS documentation **does not mention** are that

1. **5 of the 6 subject fields must perfectly match** in three (3) places
2. the 6th **common name field must differ** between certificate manager and the root CA
3. the **email address field must be deleted** from the root CA

The root CA certificate will by default contain the email address field which certificate manager currently does not have. Even an empty value in the root CA's email field is deemed as a mismatch by the overly sensitive (underly documented) Certificate Manager.

Step 3 details how one deletes the email field from the Root CA's certificate.

## Plan the 6 Certificate Subject Fields

It pays to be prepared before setting up the subordinate certificate authority in Certificate Manager and the root certificate authority (on a PC).

| # | Subject Field     | ID | Subordinate CA | Root CA        |
| - |:----------------- |:--:|:-------------- |: ------------- |
| 1 | Country Code      | C  | GB             |  GB            |
| 2 | State (Province)  | ST | England        |  England       |
| 3 | Locality          | L  | London         |  London        |
| 4 | Organization      | O  | DevOps4m3 Ltd  |  DevOps4m3 Ltd |
| 5 | Organization Unit | OU | Engineering    |  Engineering   |
| 6 | Common Name       | CN | devops4m3.lab  |  devops4m3.ltd |


In AWS certificate manager you are creating the Subordinate CA so use the values you decide for the 3rd column.

When **configuring openssl.cnf** in order to create the Root CA **we will delete the email address field** and insert the values in the final column.

## The Comman Name Field

The **`failed to update database`** error occurs when the common name in the AWS subordinate certificate authority (in AWS CM) is the same as the common name of your Root Certificate Authority.

```
failed to update database
TXT_DB error number 2
```

This error happens when signing the subordinate's CSR (certificate signing request).
