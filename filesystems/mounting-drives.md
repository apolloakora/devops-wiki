

# Mounting Drives

Mounting **remote or external storage drives** allows files and folders to be accessed as if they are (or were) on the local filesystem. With some techniques the files actually are on the local filesystem whilst with others, they appear to be usually through a given interface.

## Common Drive Mounting

Drive mounting is a technique as old as time itself. Despite thousands of drive mounting technologies and ideologies, only a handful feature in a DevOps engineer's toolset. These are

- Samba | for mounting drives between Linux and Windows
- NFS | network file system for mounting storage that is LAN accessible
- EBS | Amazon's elastic block storage system (for mounting by EC2 compute elements)
- S3FS (FUSE) | for mounting S3 buckets into Linux and MAC workstations
- Google Drive
- DropBox
- Android drive mounting
- Linux USB drive mounting
- HDFS | for processing data
- GridFS | for using files that exceed the BSON limit of 16MB
- Ceph and Gluster

At a lower level, technologies like SFTP, SCP and the lower SSH can be used to manage files connect to a remote authorized compute element.

# Mounting Cloud Storage

Work through these articles.

## Mounting Google Drive on Linux
https://www.techrepublic.com/article/how-to-mount-your-google-drive-on-linux-with-google-drive-ocamlfuse/

## Mounting S3 Buckets on AWS EC2 Compute Elements
https://cloudkul.com/blog/mounting-s3-bucket-linux-ec2-instance/

## Mount S3 Buckets on Linux with S3FS from FUSE
**`https://cloud.netapp.com/blog/amazon-s3-as-a-file-system`**

## MongoDB's GridFS specification for larger BSON elements
https://docs.mongodb.com/manual/core/gridfs/

