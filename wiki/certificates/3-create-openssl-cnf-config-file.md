
# Step 3 | openssl.cnf | configure root certificate authority

The **openssl.cnf** file drives the configuration of your Root CA. You need to

- set the base directory of your root CA
- ensure the 5 subject fields in policy_strict are set to match
- ensure the commonName field is set to supplied
- comment out the email address field in 3 places

## Removing the Email Address Field

#### CertificateMismatchException The certificate version must be greater than or equal to 3

Remember that AWS Certificate Manager does not have an email address field. If you leave the default email address field then your Root CA's subject will contain it and the certificate import step will fail with the above **CertificateMismatchException**.

The openssl.cnf below comments out three occurences of the email field in the policy_strict and req_distinguished_name sections.


## Set Default Values for the 5 Certificate Subject Fields

Remember in Step 1 we planned out the 6 subject fields.

| # | Subject Field     | ID | Subordinate CA | Root CA        |
| - |:----------------- |:--:|:-------------- |: ------------- |
| 1 | Country Code      | C  | GB             |  GB            |
| 2 | State (Province)  | ST | England        |  England       |
| 3 | Locality          | L  | London         |  London        |
| 4 | Organization      | O  | DevOps4m3 Ltd  |  DevOps4m3 Ltd |
| 5 | Organization Unit | OU | Engineering    |  Engineering   |
| 6 | Common Name       | CN | devops4m3.lab  |  devops4m3.ltd |

It makes sense to enter the values of the first 5 subject fields into the defaults. This allows you to hit enter 5 times in the Root CA creation command (in Step 4).

```
countryName_default            = GB
stateOrProvinceName_default    = England
localityName_default           = London
0.organizationName_default     = DevOps4m3 Ltd
organizationalUnitName_default = Engineering
```

## openssl.cnf

This is the full openssl.cnf file that you can use as long as you change the default directory and 5 subject fields to suit your needs.


```conf
# ======================================================= #
# OpenSSL [Root] Certificate Authority Configuration File #
# Designed to Sign AWS Certificate Manager Subordinate CA #
# ======================================================= #

[ ca ]
default_ca = CA_default

[ CA_default ]
## ###################################### ##
## Set path to the Root CA base directory ##
## ###################################### ##

dir               = /root/ca

## ###################################### ##

certs             = $dir/certs
crl_dir           = $dir/crl
new_certs_dir     = $dir/newcerts
database          = $dir/index.txt
serial            = $dir/serial
RANDFILE          = $dir/private/.rand

# The root key and root certificate.
private_key       = $dir/private/ca.key.pem
certificate       = $dir/certs/ca.cert.pem

# For certificate revocation lists.
crlnumber         = $dir/crlnumber
crl               = $dir/crl/ca.crl.pem
crl_extensions    = crl_ext
default_crl_days  = 30

# SHA-1 is deprecated, so use SHA-2 instead.
default_md        = sha256

name_opt          = ca_default
cert_opt          = ca_default
default_days      = 375
preserve          = no
policy            = policy_strict

[ policy_strict ]
# The root CA should only sign intermediate certificates that match.
# See the POLICY FORMAT section of `man ca`.
countryName             = match
stateOrProvinceName     = match
localityName            = match
organizationName        = match
organizationalUnitName  = match
commonName              = supplied
## ##################################
## Commented Out Email Field
## emailAddress = optional
## ##################################

[ req ]
# Options for the `req` tool (`man req`).
default_bits        = 2048
distinguished_name  = req_distinguished_name
string_mask         = utf8only

# SHA-1 is deprecated, so use SHA-2 instead.
default_md          = sha256

# Extension to add when the -x509 option is used.
x509_extensions     = v3_ca

[ req_distinguished_name ]
# See <https://en.wikipedia.org/wiki/Certificate_signing_request>.
countryName                     = Country Name (2 letter code)
stateOrProvinceName             = State or Province Name
localityName                    = Locality Name
0.organizationName              = Organization Name
organizationalUnitName          = Organizational Unit Name
commonName                      = Common Name
## ##################################
## Commented Out Email Field
## emailAddress = Email Address
## ##################################

# Optionally, specify some defaults.
countryName_default            = GB
stateOrProvinceName_default    = England
localityName_default           = London
0.organizationName_default     = DevOps4m3 Ltd
organizationalUnitName_default = Engineering
## ##################################
## Commented Out Email Field
## emailAddress_default =
## ##################################

[ v3_ca ]
# Extensions for a typical CA (`man x509v3_config`).
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign

[ v3_intermediate_ca ]
# Extensions for a typical intermediate CA (`man x509v3_config`).
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true, pathlen:0
keyUsage = critical, digitalSignature, cRLSign, keyCertSign

[ usr_cert ]
# Extensions for client certificates (`man x509v3_config`).
basicConstraints = CA:FALSE
nsCertType = client, email
nsComment = "OpenSSL Generated Client Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, emailProtection

[ server_cert ]
# Extensions for server certificates (`man x509v3_config`).
basicConstraints = CA:FALSE
nsCertType = server
nsComment = "OpenSSL Generated Server Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer:always
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth

[ crl_ext ]
# Extension for CRLs (`man x509v3_config`).
authorityKeyIdentifier=keyid:always

[ ocsp ]
# Extension for OCSP signing certificates (`man ocsp`).
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, digitalSignature
extendedKeyUsage = critical, OCSPSigning
```
