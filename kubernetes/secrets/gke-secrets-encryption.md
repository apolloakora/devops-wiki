
# How to Encrypt Kubernetes Secrets | Google Kubernetes Engine

Kubernetes (GKE) writes secrets in plain text so to deliver **defence in depth** we must encrypt the application layer secrets held in GKE's etcd directory service.

Specifically the Kubernetes secrets are encrypted with a local AES-256-CBC key which is in turn encrypted by a key managed by Google's KMS service.



## Check the Secrets Encryption Status

This command checks whether application layer secrets are encrypted. **Change the project ID as appropriate**. Specify your zone and project identifier.

```
gcloud container clusters describe rm-k8s-cluster \
  --zone europe-west2 \
  --format 'value(databaseEncryption)' \
  --project <GOOGLE-PROJECT-ID>
```

The response will either be **`state=DECRYPTED`** or **`state=ENCRYPTED`** prefixed by the encryption configuration.





## How to Rotate the KMS Key and the Key Encryption Key

You can rotate the KMS key simply by creating a new version of the key within the KMS service. *Note that the KMS service need not necessarily reside in the same project as the cluster so here we specify the ID of the KMS (key) project*.

```
gcloud kms keys versions create
   --location <KEY_LOCATION>    \
   --keyring <KMS-KEYRING-NAME> \
   --key <KMS-KEY-ID>           \
   --primary                    \
   --project <GOOGLE-KEY-PROJECT-ID>
```

Then we make Kubernetes re-encrypt every secret by touching them all.

**`kubectl get secrets --all-namespaces -o json | kubectl replace -f -`**

Finally delete the previous key version to avoid paying for it.






## Application-layer Secrets Encryption

- [https://cloud.google.com/kubernetes-engine/docs/how-to/encrypting-secrets#gcloud_1]


What happens when you create a Secret
When you create a new Secret, here's what happens:

The Kubernetes API server generates a unique DEK for the Secret by using a random number generator.

The Kubernetes API server uses the DEK locally to encrypt the Secret.

The KMS plugin sends the DEK to Cloud KMS for encryption. The KMS plugin uses your project's GKE service account to authenticate to Cloud KMS.

Cloud KMS encrypts the DEK, and sends it back to the KMS plugin.

The Kubernetes API server saves the encrypted Secret and the encrypted DEK. The plaintext DEK is not saved to disk.

When a client requests a Secret from the Kubernetes API server, the process described above is reversed.

What happens when you destroy a Key
Warning: Destroying a key is NOT reversible - any data encrypted with the destroyed version will be unrecoverable.
When you destroy a key in Cloud KMS used to encrypt a Secret in GKE, that Secret is no longer available. Unless using a Service Account Token Volume Projection, Service Accounts used by GKE also use Secrets, and if a key is destroyed these become unavailable. The inability to access these means that the cluster will fail to start.

Prior to destroying a key, it is recommended that you verify if it is being used by your cluster. You can also create an alerting policy for key destruction in Cloud KMS.

Before you begin
To do the exercises in this topic, you need two Google Cloud projects.

Key project: This is where you create a key encryption key.

Cluster project: This is where you create a cluster that enables Application-layer Secrets Encryption.

Note: You can use the same project for your key project and cluster project. But the recommended practice is to use separate projects.
In your key project, ensure that you have enabled the Cloud KMS API.

Enable Cloud KMS API

In your key project, the user who creates the key ring and key needs the following Cloud IAM permissions:

cloudkms.keyRings.getIamPolicy
cloudkms.keyRings.setIamPolicy
These permissions (and many more) are granted to the pre-defined roles/cloudkms.admin Cloud Identity and Access Management role. You can learn more about granting permissions to manage keys in the Cloud KMS documentation.

In your cluster project, ensure that you have enabled the Google Kubernetes Engine API.

Enable Google Kubernetes Engine API

Ensure that you have installed the Cloud SDK.

Update gcloud to the latest version:

gcloud components update

Creating a Cloud KMS key
When you create key ring, specify a location that matches the location of your GKE cluster:

A zonal cluster should use a key ring from a superset location. For example, a cluster in the zone us-central1-a can only use a key in the region us-central1.

A regional cluster should use a key ring from the same location. For example, a cluster in the region asia-northeast1 should be protected with a key ring from region asia-northeast1.

The Cloud KMS global region is not supported for use with GKE.

You can use the Google Cloud Console or the gcloud command.

console
gcloud
In your key project, create a key ring:

gcloud kms keyrings create ring-name \
    --location location \
    --project key-project-id

where:

ring-name is a name that you choose for your key ring.
location is the region where you want to create the key ring.
key-project-id is your key project ID.
Create a key:

gcloud kms keys create key-name \
    --location location \
    --keyring ring-name \
    --purpose encryption \
    --project key-project-id

where:

key-name is a name that you choose for your key.
location is the region where you created your key ring.
ring-name is the name of your key ring.
key-project-id is your key project ID.
Grant permission to use the key
The GKE service account in your cluster project has this name:

service-cluster-project-number@container-engine-robot.iam.gserviceaccount.com

where cluster-project-number is your cluster project number.

To grant access to the service account, you can use the Google Cloud Console or the gcloud command.

console
gcloud
Grant your GKE service account the Cloud KMS CryptoKey Encrypter/Decrypter role:

gcloud kms keys add-iam-policy-binding key-name \
  --location location \
  --keyring ring-name \
  --member serviceAccount:service-account-name \
  --role roles/cloudkms.cryptoKeyEncrypterDecrypter \
  --project key-project-id

where:

key-name is the name of your key.
location is the region where you created your key ring.
ring-name is the name of your key ring.
service-account-name is the name of your GKE service account.
key-project-id is your key project ID.
Enabling Application-layer Secrets Encryption
On a new cluster
You can create a new cluster by using the Google Cloud Console or the gcloud tool.

console
gcloud
To create a cluster that supports Application-layer Secrets Encryption, specify a value for the --database-encryption-key parameter in your creation command.

gcloud container clusters create cluster-name \
  --cluster-version=latest \
  --zone zone \
  --database-encryption-key projects/key-project-id/locations/location/keyRings/ring-name/cryptoKeys/key-name \
  --project cluster-project-id

where:

cluster-name is a name that you choose for your cluster.
zone is the zone where you want to create the cluster.
key-project-id is your key project ID.
location is the location of your key ring.
ring-name is the name of your key ring.
key-name is the name of your key.
cluster-project-id is your cluster project ID.
On an existing cluster
You can update an existing cluster to use Application-layer Secrets Encryption, as long as one of the following statements is true:

Cluster version is greater than or equal to v1.11.9 and less than v1.12.0.
Cluster version is greater than or equal to v1.12.7.
You can use the Google Cloud Console or the gcloud command.

console
gcloud
To enable Application-layer Secrets Encryptions on an existing cluster, run the following command:

gcloud container clusters update cluster-name \
  --zone zone \
  --database-encryption-key projects/key-project-id/locations/location/keyRings/ring-name/cryptoKeys/key-name \
  --project cluster-project-id

where:

cluster-name is a name that you choose for your cluster.
zone is the zone where you want to create the cluster.
key-project-id is your key project ID.
location is the location of your key ring.
ring-name is the name of your key ring.
key-name is the name of your key.
cluster-project-id is your cluster project ID.
Updating a Cloud KMS key
console
gcloud
Update your existing cluster to use a new Cloud KMS key:

gcloud container clusters update cluster-name \
  --zone zone \
  --database-encryption-key projects/key-project-id/locations/location/keyRings/ring-name/cryptoKeys/key-name \
  --project cluster-project-id

where:

cluster-name is a name that you choose for your cluster.
zone is the zone where you want to create the cluster.
key-project-id is your key project ID.
location is the location of your key ring.
ring-name is the name of your key ring.
key-name is the name of your key.
cluster-project-id is your cluster project ID.




---



## Application-layer Secrets Encryption

- [https://cloud.google.com/kubernetes-engine/docs/how-to/encrypting-secrets]

This page explains how to encrypt Kubernetes Secrets at the application layer using a key you manage in Cloud Key Management Service (Cloud KMS). Since this feature relies on functionality from Cloud KMS, you should familiarize yourself with key rotation and envelope encryption.

Overview
By default, GKE encrypts customer content stored at rest, including Secrets. GKE handles and manages this default encryption for you without any additional action on your part.

Application-layer Secrets Encryption provides an additional layer of security for sensitive data, such as Secrets, stored in etcd. Using this functionality, you can use a key managed with Cloud KMS to encrypt data at the application layer. This protects against attackers who gain access to an offline copy of etcd.

To use Application-layer Secrets Encryption, you must first create a Cloud KMS key and give the GKE service account access to the key. The key must be in the same location as the cluster to decrease latency and to prevent cases where resources depend on services spread across multiple failure domains. Then, you can enable the feature on a new or existing cluster by specifying the key you would like to use.

Note: Cloud KMS usage is subject to a quota. GKE calls the Cloud KMS API every time it performs a cryptographic operation. Confirm that you have enough quota to enable application-layer secrets encryption for your application.
Envelope encryption
Kubernetes offers envelope encryption of Secrets with a KMS provider, meaning that a local key, commonly called a data encryption key (DEK), is used to encrypt the Secrets. The DEK itself is encrypted with another key called the key encryption key. The key encryption key is not stored by Kubernetes.

Envelope encryption has two main benefits:

The key encryption key can be rotated without requiring re-encryption of all the Secrets. This means that you can more easily follow the best practice of regular key rotation, without a significant impact on performance.

Secrets that are stored in Kubernetes can rely on an external root of trust. This means that you can use a central root of trust, for example a Hardware Security Module, for all your Secrets, and that an adversary accessing your containers off line isn't able to obtain your Secrets.

With Application-layer Secrets Encryption in GKE, your Secrets are encrypted locally, using the AES-CBC provider, with local DEKs, and the DEKs are encrypted with a key encryption key that you manage in Cloud KMS.

To learn more about envelope encryption, see Envelope encryption.

What happens when you create a Secret
When you create a new Secret, here's what happens:

The Kubernetes API server generates a unique DEK for the Secret by using a random number generator.

The Kubernetes API server uses the DEK locally to encrypt the Secret.

The KMS plugin sends the DEK to Cloud KMS for encryption. The KMS plugin uses your project's GKE service account to authenticate to Cloud KMS.

Cloud KMS encrypts the DEK, and sends it back to the KMS plugin.

The Kubernetes API server saves the encrypted Secret and the encrypted DEK. The plaintext DEK is not saved to disk.

When a client requests a Secret from the Kubernetes API server, the process described above is reversed.

What happens when you destroy a Key
Warning: Destroying a key is NOT reversible - any data encrypted with the destroyed version will be unrecoverable.
When you destroy a key in Cloud KMS used to encrypt a Secret in GKE, that Secret is no longer available. Unless using a Service Account Token Volume Projection, Service Accounts used by GKE also use Secrets, and if a key is destroyed these become unavailable. The inability to access these means that the cluster will fail to start.

Prior to destroying a key, it is recommended that you verify if it is being used by your cluster. You can also create an alerting policy for key destruction in Cloud KMS.

Before you begin
To do the exercises in this topic, you need two Google Cloud projects.

Key project: This is where you create a key encryption key.

Cluster project: This is where you create a cluster that enables Application-layer Secrets Encryption.

Note: You can use the same project for your key project and cluster project. But the recommended practice is to use separate projects.
In your key project, ensure that you have enabled the Cloud KMS API.

Enable Cloud KMS API

In your key project, the user who creates the key ring and key needs the following Cloud IAM permissions:

cloudkms.keyRings.getIamPolicy
cloudkms.keyRings.setIamPolicy
These permissions (and many more) are granted to the pre-defined roles/cloudkms.admin Cloud Identity and Access Management role. You can learn more about granting permissions to manage keys in the Cloud KMS documentation.

In your cluster project, ensure that you have enabled the Google Kubernetes Engine API.

Enable Google Kubernetes Engine API

Ensure that you have installed the Cloud SDK.

Update gcloud to the latest version:

gcloud components update

Creating a Cloud KMS key
When you create key ring, specify a location that matches the location of your GKE cluster:

A zonal cluster should use a key ring from a superset location. For example, a cluster in the zone us-central1-a can only use a key in the region us-central1.

A regional cluster should use a key ring from the same location. For example, a cluster in the region asia-northeast1 should be protected with a key ring from region asia-northeast1.

The Cloud KMS global region is not supported for use with GKE.

You can use the Google Cloud Console or the gcloud command.

console
gcloud
In your key project, create a key ring:

Go to the Cryptographic Keys page in the Cloud Console.

Go to the Cryptographic Keys page

Click Create key ring.

In the Key ring name field, enter the name for your key ring.

From the Location dropdown, select the location of your Kubernetes cluster. Your Create key ring page should look similar to:

Keyring creation screen in Google Cloud web UI

Click Create.

Next, create a key:

Go to the Cryptographic Keys page in the Cloud Console.

Go to the Cryptographic Keys page

Click the name of the key ring for which you will create a key.

Click Create key.

In the Key name field, enter the name for your key.

Accept the default values for Rotation period and Starting on, or set a key rotation period and starting time if you want to use different values.

[Optional] In the Labels field, click Add label if you want to add labels to your key.

Your Create key page should look similar to:

Key creation screen in Google Cloud web UI

Click Create.

Grant permission to use the key
The GKE service account in your cluster project has this name:

service-cluster-project-number@container-engine-robot.iam.gserviceaccount.com

where cluster-project-number is your cluster project number.

To grant access to the service account, you can use the Google Cloud Console or the gcloud command.

console
gcloud
Grant your GKE service account the Cloud KMS CryptoKey Encrypter/Decrypter role:

Open the Cloud Key Management Service Keys browser in the Google Cloud Console.
Open the Cloud KMS Keys browser
Click on the name of the key ring that contains the desired key.

Select the checkbox for the desired key.

The Permissions tab in the right window pane becomes available.

In the Add members dialog, specify the email address of the GKE service account you are granting access.

In the Select a role drop down, select Cloud KMS CryptoKey Encrypter/Decrypter.

Click Save.

Enabling Application-layer Secrets Encryption
On a new cluster
You can create a new cluster by using the Google Cloud Console or the gcloud tool.

console
gcloud
Visit the Google Kubernetes Engine menu in Cloud Console.

Visit the Google Kubernetes Engine menu

Click the Create cluster button.

Configure your cluster and node pools as desired.

From the navigation pane, under Cluster, click Security.

Select Enable Application-layer Secrets Encryption and choose the database encryption key you created in Creating a Cloud KMS key.

Continue configuring your cluster.

Click Create.

On an existing cluster
You can update an existing cluster to use Application-layer Secrets Encryption, as long as one of the following statements is true:

Cluster version is greater than or equal to v1.11.9 and less than v1.12.0.
Cluster version is greater than or equal to v1.12.7.
You can use the Google Cloud Console or the gcloud command.

console
gcloud
To update a cluster to support Application-layer Secrets Encryption:

Visit the Google Kubernetes Engine menu in Cloud Console.

Visit the Google Kubernetes Engine menu

Click the Edit icon for the cluster you want to modify. It looks like a pencil.

Enable Application-layer Secrets Encryption and choose the database encryption key you created in Creating a Cloud KMS key.

Click Save.

Updating a Cloud KMS key
console
gcloud
To update a cluster to use a new Cloud KMS key:

Visit the Google Kubernetes Engine menu in Cloud Console.

Visit the Google Kubernetes Engine menu

Click the Edit icon for the cluster you want to modify. It looks like a pencil.

Under Application-layer Secrets Encryption, select the new encryption key you want to use.

Click Save.

Disabling Applications-layer Secrets Encryption
You can use the Google Cloud Console or the gcloud command.

console
gcloud
Visit the Google Kubernetes Engine menu in Cloud Console.

Visit the Google Kubernetes Engine menu

Click the Edit icon for the cluster you want to modify. It looks like a pencil.

Disable Application-layer Secrets Encryption.

Click Save.

Verifying that Application-layer Secrets Encryption is enabled
You can check to see whether a cluster is using Application-layer Secrets Encryption using the Google Cloud Console or the gcloud command.

console
gcloud
Visit the Google Kubernetes Engine menu in Cloud Console.

Visit the Google Kubernetes Engine menu

Click the name of the cluster you want to modify. The cluster's Details page opens.

Verify that Application-layer Secrets Encryption is enabled, and that the correct key is listed.

Limitations
Key location
You must select a key in the same region as the cluster that it is being used in. For example, a zonal cluster in us-central1-a can only use a key in the region us-central1. For regional clusters, keys must be in the same location to decrease latency and to prevent cases where resources depend on services spread across multiple failure domains.

Note: The key does not need to be in the same project as the cluster. For more information about the supported locations for Cloud KMS, see Cloud Locations.
Key rotation
When you perform a key rotation, your existing secrets remain encrypted with the previous KEK. To ensure a newer KEK wraps a Secret, create a new Secret after key rotation.

For example, you create and store a Secret, Secret1. It is encrypted with DEK1, which itself is wrapped with KEKv1. Before KEKv1 rotates, you create another secret, Secret2. Secret2 gets its own key, DEK2. KEKv1 is used again to encrypt the DEK.

After the KEK rotates, we create another secret, Secret3, which gets encrypted with DEK3. DEK3 is in turn encrypted with KEKv2, the rotated KEK.

For instructions on how to manually rotate the KEKs that encrypt your Secrets, see Re-encrypting your secrets.

Re-encrypting your secrets
At this time, there is no way to force automatic re-encryption of your Secrets. If desired, you can manually rotate your KEK by creating a new key version:

gcloud kms keys versions create --location location \
   --keyring ring-name \
   --key key-name \
   --primary \
   --project key-project-id

Then force GKE to re-encrypt by touching every Secret:

kubectl get secrets --all-namespaces -o json | kubectl replace -f -

Note: The old key version will still exist, and incur costs. You may want to destroy the old key version if it is no longer in use.
EncryptionConfig
At this time, only keys from Cloud KMS are supported in GKE. You cannot use another Kubernetes KMS provider or another encryption provider.

What's next
Learn more about Secrets in Kubernetes.
Learn more about Secret management using Cloud KMS.
Learn how to harden your cluster.




---



## Using a KMS provider for data encryption

- [https://kubernetes.io/docs/tasks/administer-cluster/kms-provider/]

This page shows how to configure a Key Management Service (KMS) provider and plugin to enable secret data encryption.

Before you begin
You need to have a Kubernetes cluster, and the kubectl command-line tool must be configured to communicate with your cluster. If you do not already have a cluster, you can create one by using Minikube, or you can use one of these Kubernetes playgrounds:

Katacoda
Play with Kubernetes
To check the version, enter kubectl version.
Kubernetes version 1.10.0 or later is required

etcd v3 or later is required

FEATURE STATE: Kubernetes v1.12 [beta]
The KMS encryption provider uses an envelope encryption scheme to encrypt data in etcd. The data is encrypted using a data encryption key (DEK); a new DEK is generated for each encryption. The DEKs are encrypted with a key encryption key (KEK) that is stored and managed in a remote KMS. The KMS provider uses gRPC to communicate with a specific KMS plugin. The KMS plugin, which is implemented as a gRPC server and deployed on the same host(s) as the Kubernetes master(s), is responsible for all communication with the remote KMS.

Configuring the KMS provider
To configure a KMS provider on the API server, include a provider of type kms in the providers array in the encryption configuration file and set the following properties:

name: Display name of the KMS plugin.
endpoint: Listen address of the gRPC server (KMS plugin). The endpoint is a UNIX domain socket.
cachesize: Number of data encryption keys (DEKs) to be cached in the clear. When cached, DEKs can be used without another call to the KMS; whereas DEKs that are not cached require a call to the KMS to unwrap.
timeout: How long should kube-apiserver wait for kms-plugin to respond before returning an error (default is 3 seconds).
See Understanding the encryption at rest configuration.

Implementing a KMS plugin
To implement a KMS plugin, you can develop a new plugin gRPC server or enable a KMS plugin already provided by your cloud provider. You then integrate the plugin with the remote KMS and deploy it on the Kubernetes master.

Enabling the KMS supported by your cloud provider
Refer to your cloud provider for instructions on enabling the cloud provider-specific KMS plugin.

Developing a KMS plugin gRPC server
You can develop a KMS plugin gRPC server using a stub file available for Go. For other languages, you use a proto file to create a stub file that you can use to develop the gRPC server code.

Using Go: Use the functions and data structures in the stub file: service.pb.go to develop the gRPC server code

Using languages other than Go: Use the protoc compiler with the proto file: service.proto to generate a stub file for the specific language

Then use the functions and data structures in the stub file to develop the server code.

Notes:

kms plugin version: v1beta1
In response to procedure call Version, a compatible KMS plugin should return v1beta1 as VersionResponse.version

message version: v1beta1
All messages from KMS provider have the version field set to current version v1beta1

protocol: UNIX domain socket (unix)
The gRPC server should listen at UNIX domain socket

Integrating a KMS plugin with the remote KMS
The KMS plugin can communicate with the remote KMS using any protocol supported by the KMS. All configuration data, including authentication credentials the KMS plugin uses to communicate with the remote KMS, are stored and managed by the KMS plugin independently. The KMS plugin can encode the ciphertext with additional metadata that may be required before sending it to the KMS for decryption.

Deploying the KMS plugin
Ensure that the KMS plugin runs on the same host(s) as the Kubernetes master(s).

Encrypting your data with the KMS provider
To encrypt the data:

Create a new encryption configuration file using the appropriate properties for the kms provider:
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - kms:
        name: myKmsPlugin
        endpoint: unix:///tmp/socketfile.sock
        cachesize: 100
        timeout: 3s
    - identity: {}
Set the --encryption-provider-config flag on the kube-apiserver to point to the location of the configuration file.
Restart your API server.
Note: The alpha version of the encryption feature prior to 1.13 required a config file with kind: EncryptionConfig and apiVersion: v1, and used the --experimental-encryption-provider-config flag.

Verifying that the data is encrypted
Data is encrypted when written to etcd. After restarting your kube-apiserver, any newly created or updated secret should be encrypted when stored. To verify, you can use the etcdctl command line program to retrieve the contents of your secret.

Create a new secret called secret1 in the default namespace:
kubectl create secret generic secret1 -n default --from-literal=mykey=mydata
Using the etcdctl command line, read that secret out of etcd:
ETCDCTL_API=3 etcdctl get /kubernetes.io/secrets/default/secret1 [...] | hexdump -C
where [...] must be the additional arguments for connecting to the etcd server.

Verify the stored secret is prefixed with k8s:enc:kms:v1:, which indicates that the kms provider has encrypted the resulting data.

Verify that the secret is correctly decrypted when retrieved via the API:

kubectl describe secret secret1 -n default
should match mykey: mydata

Ensuring all secrets are encrypted
Because secrets are encrypted on write, performing an update on a secret encrypts that content.

The following command reads all secrets and then updates them to apply server side encryption. If an error occurs due to a conflicting write, retry the command. For larger clusters, you may wish to subdivide the secrets by namespace or script an update.

kubectl get secrets --all-namespaces -o json | kubectl replace -f -
Switching from a local encryption provider to the KMS provider
To switch from a local encryption provider to the kms provider and re-encrypt all of the secrets:

Add the kms provider as the first entry in the configuration file as shown in the following example.
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - kms:
        name : myKmsPlugin
        endpoint: unix:///tmp/socketfile.sock
        cachesize: 100
    - aescbc:
        keys:
        - name: key1
          secret: <BASE 64 ENCODED SECRET>
Restart all kube-apiserver processes.

Run the following command to force all secrets to be re-encrypted using the kms provider.

kubectl get secrets --all-namespaces -o json| kubectl replace -f -
Disabling encryption at rest
To disable encryption at rest:

Place the identity provider as the first entry in the configuration file:
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - identity: {}
    - kms:
        name : myKmsPlugin
        endpoint: unix:///tmp/socketfile.sock
        cachesize: 100
Restart all kube-apiserver processes.
Run the following command to force all secrets to be decrypted.
kubectl get secrets --all-namespaces -o json | kubectl replace -f -




---



## Using customer-managed encryption keys (CMEK)

- [https://cloud.google.com/kubernetes-engine/docs/how-to/using-cmek]

This product or feature is covered by the Pre-GA Offerings Terms of the Google Cloud Platform Terms of Service. Pre-GA products and features may have limited support, and changes to pre-GA products and features may not be compatible with other pre-GA versions. For more information, see the launch stage descriptions.

This page describes how to use Customer Managed Encryption Keys (CMEK) on Google Kubernetes Engine (GKE). If you need to control management of your keys, you can use Cloud Key Management Service and CMEK to protect attached Persistent Disks and custom boot disks in your GKE cluster.

Overview
By default, Google Cloud encrypts customer content at rest, and GKE manages encryption for you without any action on your part.

If you want to control and manage encryption key rotation yourself, you can use Customer Managed Encryption Keys (CMEK). These keys encrypt the data encryption keys that encrypt your data. For more information, see Key management.You can also encrypt secrets in your cluster using keys that you manage. See Application-layer secrets encryption for details.

In GKE, CMEK can protect data of two types of storage disks: node boot disks and attached disks.

Node boot disks
Node boot disks are part of your cluster's node pools. You can create a CMEK-encrypted node boot disk when you create clusters and node pools.
Attached disks
Attached disks are PersistentVolumes used by Pods for durable storage. CMEK-encrypted attached persistent disks are available in GKE as a dynamically provisioned PersistentVolume.
To learn more about storage disks, see Storage options. Control plane disks, used for GKE masters, cannot be protected with CMEK.

Before you begin
To do the exercises in this topic, you need two Google Cloud projects:

Key project: This is where you create an encryption key.

Cluster project: This is where you create a cluster that enables CMEK.

Note: You can use the same project for your key project and cluster project. But the recommended practice is to use separate projects.
In your key project, ensure that you have enabled the Cloud KMS API.

Enable Cloud KMS API

In your key project, the user who creates the key ring and key needs the following Cloud IAM permissions:

cloudkms.keyRings.getIamPolicy
cloudkms.keyRings.setIamPolicy
These permissions (and many more) are granted to the pre-defined roles/cloudkms.admin Cloud Identity and Access Management role. You can learn more about granting permissions to manage keys in the Cloud KMS documentation.

In your cluster project, ensure that you have enabled the Cloud KMS API.

Enable Cloud KMS API

Ensure that you have installed the Cloud SDK.

Update gcloud to the latest version:

gcloud components update

Create a Cloud KMS key
Before you can protect your node boot disk or attached disk with a CMEK, create a Cloud KMS key ring, key, and key version (if necessary). You can use an existing Cloud KMS key as long as it is the right type (same region, symmetric encryption key, and you grant permissions).

When you create a key ring, specify a location that matches the location of your GKE cluster:

A zonal cluster should use a key ring from a superset location. For example, a cluster in the zone us-central1-a can only use a key in the region us-central1.

A regional cluster should use a key ring from the same location. For example, a cluster in the asia-northeast1 region should be protected with a key ring from the asia-northeast1 region.

The Cloud KMS global region is not supported for use with GKE.

To create a Cloud KMS key, you can use the gcloud command or the Google Cloud Console.

In your key project, create a key ring:

gcloud
Console
gcloud kms keyrings create ring-name \
    --location location \
    --project key-project-id

where:

ring-name is a name that you choose for your key ring.
location is the region where you want to create the key ring.
key-project-id is your key project ID.
Then, create a key:

gcloud
Console
gcloud kms keys create key-name \
  --location location \
  --keyring ring-name \
  --purpose encryption \
  --project key-project-id

where:

key-name is a name that you choose for your key.
location is the region where you created your key ring.
ring-name is the name of your key ring.
key-project-id is your key project ID.
Grant permission to use the key
You must assign the Compute Engine service account used by nodes in your cluster the Cloud KMS CryptoKey Encrypter/Decrypter role. This is required for GKE Persistent Disks to access and use your encryption key.

The Compute Engine service account's name has the following format:

service-project-number@compute-system.iam.gserviceaccount.com

where project-number is your cluster's project number.

Note: For CMEK-protected node boot disks, this Compute Engine service account is the account which requires permissions to do encryption using your Cloud KMS key. This is true even if you are using a custom service account on your nodes.
To grant access to the service account, you can use the gcloud command or the Google Cloud Console.

gcloud
Console
Grant your Compute Engine service account the Cloud KMS CryptoKey Encrypter/Decrypter role:

gcloud kms keys add-iam-policy-binding key-name \
  --location location \
  --keyring ring-name \
  --member serviceAccount:service-account-name \
  --role roles/cloudkms.cryptoKeyEncrypterDecrypter \
  --project key-project-id

where:

key-name is the name of your key.
location is the region where you created your key ring.
ring-name is the name of your key ring.
service-account-name is the name of your Compute Engine service account.
key-project-id is your key project ID.
Create a CMEK protected boot disk
In this section, you create a new cluster or node pool with a CMEK protected boot disk.

You cannot enable customer-managed encryption for node boot disks on an existing cluster, as you cannot change the boot disk type of an existing cluster or node pool. However, you can create a new node pool for your cluster with customer- managed encryption enabled, and delete the previous node pool.

You also cannot disable customer-managed encryption for node boot disks on an existing cluster or an existing node pool. However, you can create a new node pool for your cluster with customer-managed encryption disabled, and delete the previous node pool.

Create a cluster with a CMEK-protected node boot disk
You can create a cluster with a CMEK-protected node boot disk using the gcloud command or the Google Cloud Console.

To use CMEK with a node boot disk, ensure you select either a standard persistent disk (pd-standard) or a SSD persistent disks (pd-ssd).

gcloud
Console
To create a cluster with customer-managed encryption for node boot disks, specify a value for the --boot-disk-kms-key parameter in your creation command.

  gcloud beta container clusters create cluster-name \
--cluster-version=latest \
--zone zone \
--boot-disk-kms-key projects/key-project-id/locations/location/keyRings/ring-name/cryptoKeys/key-name \
--project cluster-project-id\
--disk-type disk-type

where:

cluster-name is a name that you choose for your cluster.
zone is the zone where you want to create the cluster.
key-project-id is your key project ID.
location is the location of your key ring.
ring-name is the name of your key ring.
key-name is the name of your key.
cluster-project-id is your cluster project ID.
disk-type is pd-standard (default), or pd-ssd.
Create a node pool with a CMEK-protected node boot disk
You can create a new node pool with a CMEK-protected node boot disk using the gcloud command or the Google Cloud Console.

gcloud
Console
To create a node pool with customer-managed encryption for node boot disks, specify a value for the --boot-disk-kms-key parameter in your creation command.

gcloud beta container node-pools create node-pool-name \
--zone zone \
--disk-type disk-type \
--boot-disk-kms-key projects/key-project-id/locations/location/keyRings/ring-name/cryptoKeys/key-name \
--project cluster-project-id \
--cluster cluster-name

where:

node-pool-name is a name that you choose for your node pool.
zone is the zone where you want to create the cluster.
disk-type is pd-standard (default), or pd-ssd.
key-project-id is your key project ID.
location is the location of your key ring.
ring-name is the name of your key ring.
key-name is the name of your key.
cluster-project-id is your cluster project ID.
cluster-name is the name of the cluster you created in the previous step.
Create a CMEK protected attached disk
Complete these instructions to encrypt newly created Persistent Disks. You can enable CMEK on a new or existing cluster, using a new or existing Cloud KMS key.

These instructions need to be completed once per GKE cluster:

Create a GKE cluster (if necessary).
Deploy the Compute Engine Persistent Disk CSI Driver to your cluster.
Create a Cloud KMS key ring, key, and key version (if necessary).
Create a StorageClass that enables disks provisioned by Kubernetes to automatically be encrypted with that Cloud KMS key.
Note: Your cluster must run GKE 1.14 or higher.
Create a StorageClass referencing the Cloud KMS key
Copy the content below into a YAML file named gcepd-sc.yaml. This configuration enables dynamic provisioning of encrypted volumes.

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: csi-gce-pd-cmek
provisioner: pd.csi.storage.gke.io
volumeBindingMode: "WaitForFirstConsumer"
allowVolumeExpansion: true
parameters:
  type: pd-standard
  disk-encryption-kms-key: projects/key-project-id/locations/location/keyRings/key-ring/cryptoKeys/key

The disk-encryption-kms-key field must be the fully qualified resource identifier for the key that will be used to encrypt new disks.
The values in disk-encryption-kms-key are case sensitive (for example: keyRings and cryptoKeys). Provisioning a new volume with incorrect values results in an invalidResourceUsage error.
You can set the StorageClass as the default.
Deploy the StorageClass on your GKE cluster using kubectl:

kubectl apply -f gcepd-sc.yaml

Finally, verify that your StorageClass used the Compute Engine Persistent Disk CSI driver and includes the ID of your key:

kubectl describe storageclass csi-gce-pd-cmek

In the output of the command, verify:

The provisioner is set as pd.csi.storage.gke.io.
The ID of your key follows disk-encryption-kms-key.
Name:                  csi-gce-pd-cmek
IsDefaultClass:        No
Annotations:           None
Provisioner:           pd.csi.storage.gke.io
Parameters:            disk-encryption-kms-key=projects/key-project-id/locations/location/keyRings/ring-name/cryptoKeys/key-name,type=pd-standard
AllowVolumeExpansion:  unset
MountOptions:          none
ReclaimPolicy:         Delete
VolumeBindingMode:     WaitForFirstConsumer
Events:                none

Create an encrypted Persistent Disk in GKE
In this section, you dynamically provision encrypted Kubernetes storage volumes with your new StorageClass and Cloud KMS key.

Copy the following contents into a new file named pvc.yaml, and make sure the value for storageClassName matches the name of your StorageClass object:

kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: podpvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: csi-gce-pd-cmek
  resources:
    requests:
      storage: 6Gi

Note: If you marked the new StorageClass as default, then you can omit the storageClassName field.
Apply the PersistentVolumeClaim (PVC) on your GKE cluster:

kubectl apply -f pvc.yaml

Get the status of your cluster's PersistentVolumeClaim and verify that the PVC is created and bound to a newly provisioned PersistentVolume.

Note: If your StorageClass has the volumeBindingMode field set to WaitForFirstConsumer, you must create a Pod to use the PVC before you can verify it.
kubectl get pvc

NAME      STATUS    VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS     AGE
podpvc    Bound     pvc-e36abf50-84f3-11e8-8538-42010a800002   10Gi       RWO            csi-gce-pd-cmek  9s

You can now use your CMEK-protected Persistent Disk with your GKE cluster.

Removing CMEK protection from a Persistent Disk
To remove CMEK protection from a Persistent Disk, follow the instructions in the Compute Engine documentation.




---




## Encrypting Secret Data at Rest

- [https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/]

This page shows how to enable and configure encryption of secret data at rest.

Before you begin
You need to have a Kubernetes cluster, and the kubectl command-line tool must be configured to communicate with your cluster. If you do not already have a cluster, you can create one by using Minikube, or you can use one of these Kubernetes playgrounds:

Katacoda
Play with Kubernetes
Your Kubernetes server must be at or later than version 1.13. To check the version, enter kubectl version.
etcd v3.0 or later is required

Configuration and determining whether encryption at rest is already enabled
The kube-apiserver process accepts an argument --encryption-provider-config that controls how API data is encrypted in etcd. An example configuration is provided below.

Understanding the encryption at rest configuration.
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - identity: {}
    - aesgcm:
        keys:
        - name: key1
          secret: c2VjcmV0IGlzIHNlY3VyZQ==
        - name: key2
          secret: dGhpcyBpcyBwYXNzd29yZA==
    - aescbc:
        keys:
        - name: key1
          secret: c2VjcmV0IGlzIHNlY3VyZQ==
        - name: key2
          secret: dGhpcyBpcyBwYXNzd29yZA==
    - secretbox:
        keys:
        - name: key1
          secret: YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXoxMjM0NTY=
Each resources array item is a separate config and contains a complete configuration. The resources.resources field is an array of Kubernetes resource names (resource or resource.group) that should be encrypted. The providers array is an ordered list of the possible encryption providers. Only one provider type may be specified per entry (identity or aescbc may be provided, but not both in the same item).

The first provider in the list is used to encrypt resources going into storage. When reading resources from storage each provider that matches the stored data attempts to decrypt the data in order. If no provider can read the stored data due to a mismatch in format or secret key, an error is returned which prevents clients from accessing that resource.

Caution: IMPORTANT: If any resource is not readable via the encryption config (because keys were changed), the only recourse is to delete that key from the underlying etcd directly. Calls that attempt to read that resource will fail until it is deleted or a valid decryption key is provided.
Providers:
Name	Encryption	Strength	Speed	Key Length	Other Considerations	identity	None	N/A	N/A	N/A	Resources written as-is without encryption. When set as the first provider, the resource will be decrypted as new values are written.	aescbc	AES-CBC with PKCS#7 padding	Strongest	Fast	32-byte	The recommended choice for encryption at rest but may be slightly slower than secretbox.	secretbox	XSalsa20 and Poly1305	Strong	Faster	32-byte	A newer standard and may not be considered acceptable in environments that require high levels of review.	aesgcm	AES-GCM with random nonce	Must be rotated every 200k writes	Fastest	16, 24, or 32-byte	Is not recommended for use except when an automated key rotation scheme is implemented.	kms	Uses envelope encryption scheme: Data is encrypted by data encryption keys (DEKs) using AES-CBC with PKCS#7 padding, DEKs are encrypted by key encryption keys (KEKs) according to configuration in Key Management Service (KMS)	Strongest	Fast	32-bytes	The recommended choice for using a third party tool for key management. Simplifies key rotation, with a new DEK generated for each encryption, and KEK rotation controlled by the user. Configure the KMS provider
Each provider supports multiple keys - the keys are tried in order for decryption, and if the provider is the first provider, the first key is used for encryption.

Storing the raw encryption key in the EncryptionConfig only moderately improves your security posture, compared to no encryption. Please use kms provider for additional security. By default, the identity provider is used to protect secrets in etcd, which provides no encryption. EncryptionConfiguration was introduced to encrypt secrets locally, with a locally managed key.

Encrypting secrets with a locally managed key protects against an etcd compromise, but it fails to protect against a host compromise. Since the encryption keys are stored on the host in the EncryptionConfig YAML file, a skilled attacker can access that file and extract the encryption keys.

Envelope encryption creates dependence on a separate key, not stored in Kubernetes. In this case, an attacker would need to compromise etcd, the kubeapi-server, and the third-party KMS provider to retrieve the plaintext values, providing a higher level of security than locally-stored encryption keys.

Encrypting your data
Create a new encryption config file:

apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - aescbc:
        keys:
        - name: key1
          secret: <BASE 64 ENCODED SECRET>
    - identity: {}
To create a new secret perform the following steps:

Generate a 32 byte random key and base64 encode it. If you're on Linux or macOS, run the following command:

head -c 32 /dev/urandom | base64
Place that value in the secret field.

Set the --encryption-provider-config flag on the kube-apiserver to point to the location of the config file.

Restart your API server.

Caution: Your config file contains keys that can decrypt content in etcd, so you must properly restrict permissions on your masters so only the user who runs the kube-apiserver can read it.
Verifying that data is encrypted
Data is encrypted when written to etcd. After restarting your kube-apiserver, any newly created or updated secret should be encrypted when stored. To check, you can use the etcdctl command line program to retrieve the contents of your secret.

Create a new secret called secret1 in the default namespace:

kubectl create secret generic secret1 -n default --from-literal=mykey=mydata
Using the etcdctl commandline, read that secret out of etcd:

ETCDCTL_API=3 etcdctl get /registry/secrets/default/secret1 [...] | hexdump -C

where [...] must be the additional arguments for connecting to the etcd server.

Verify the stored secret is prefixed with k8s:enc:aescbc:v1: which indicates the aescbc provider has encrypted the resulting data.

Verify the secret is correctly decrypted when retrieved via the API:

kubectl describe secret secret1 -n default
should match mykey: bXlkYXRh, mydata is encoded, check decoding a secret to completely decode the secret.

Ensure all secrets are encrypted
Since secrets are encrypted on write, performing an update on a secret will encrypt that content.

kubectl get secrets --all-namespaces -o json | kubectl replace -f -
The command above reads all secrets and then updates them to apply server side encryption.

Note: If an error occurs due to a conflicting write, retry the command. For larger clusters, you may wish to subdivide the secrets by namespace or script an update.
Rotating a decryption key
Changing the secret without incurring downtime requires a multi step operation, especially in the presence of a highly available deployment where multiple kube-apiserver processes are running.

Generate a new key and add it as the second key entry for the current provider on all servers
Restart all kube-apiserver processes to ensure each server can decrypt using the new key
Make the new key the first entry in the keys array so that it is used for encryption in the config
Restart all kube-apiserver processes to ensure each server now encrypts using the new key
Run kubectl get secrets --all-namespaces -o json | kubectl replace -f - to encrypt all existing secrets with the new key
Remove the old decryption key from the config after you back up etcd with the new key in use and update all secrets
With a single kube-apiserver, step 2 may be skipped.

Decrypting all data
To disable encryption at rest place the identity provider as the first entry in the config:

apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - identity: {}
    - aescbc:
        keys:
        - name: key1
          secret: <BASE 64 ENCODED SECRET>
and restart all kube-apiserver processes. Then run:

kubectl get secrets --all-namespaces -o json | kubectl replace -f -
to force all secrets to be decrypted.




## Terraform Database Encryption

To enable it you need to set database_encryption of google_container_clusterresource

- [https://www.terraform.io/docs/providers/google/r/container_cluster.html#database_encryption]
- [https://stackoverflow.com/questions/59442893/how-to-enable-application-layer-secrets-encryption-in-gke-cluster-with-terraform]


I used this one:

  database_encryption {
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.encryption-kms-key.self_link
  }
And this depends_on for used the kKMS keyring created with Terraform.

  depends_on = [
    google_kms_key_ring.keyring
  ]

Ref: https://www.terraform.io/docs/providers/google/d/google_kms_crypto_key.html



---



## Terraform Crypto Key Documentation




google_kms_crypto_key
Jump to Section
Provides access to a Google Cloud Platform KMS CryptoKey. For more information see the official documentation and API.

A CryptoKey is an interface to key material which can be used to encrypt and decrypt data. A CryptoKey belongs to a Google Cloud KMS KeyRing.

»Example Usage
data "google_kms_key_ring" "my_key_ring" {
  name     = "my-key-ring"
  location = "us-central1"
}

data "google_kms_crypto_key" "my_crypto_key" {
  name     = "my-crypto-key"
  key_ring = data.google_kms_key_ring.my_key_ring.self_link
}
»Argument Reference
The following arguments are supported:

name - (Required) The CryptoKey's name. A CryptoKey’s name belonging to the specified Google Cloud Platform KeyRing and match the regular expression [a-zA-Z0-9_-]{1,63}

key_ring - (Required) The self_link of the Google Cloud Platform KeyRing to which the key belongs.

»Attributes Reference
In addition to the arguments listed above, the following computed attributes are exported:

rotation_period - Every time this period passes, generate a new CryptoKeyVersion and set it as the primary. The first rotation will take place after the specified period. The rotation period has the format of a decimal number with up to 9 fractional digits, followed by the letter s (seconds).

purpose - Defines the cryptographic capabilities of the key.

self_link - The self link of the created CryptoKey. Its format is projects/{projectId}/locations/{location}/keyRings/{keyRingName}/cryptoKeys/{cryptoKeyName}