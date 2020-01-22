
# RClone | Push and Pull | S3 | Google Drive | DropBox | NextCloud

Use **RClone** to manage the transfer of objects between your workstation and cloud storage services like

- S3
- DropBox
- GoogleDrive
- NextCloud

You can use RClone at the command line, or call it from your Python, Ruby, Spark, Java and Go software.

## How to Install RClone

Add the the no check certificate if you trust the destination but certificate issues are abound.

``` bash
mkdir .rclone-binary
cd .rclone-binary
wget https://downloads.rclone.org/rclone-current-linux-amd64.deb --no-check-certificate
ls -lh
dpkg-deb --info rclone-current-linux-amd64.deb     # Print out the deb package information
dpkg -I rclone-current-linux-amd64.deb             # Ditto on printing package information
md5sum rclone-current-linux-amd64.deb              # Display the MD5 sum of the debian package
dpkg --contents rclone-current-linux-amd64.deb     # List the contents of the debian tarball
sudo dpkg --install .                              # Install all deb packages in this folder
mkdir xtract-folder
dpkg -x rclone-current-linux-amd64.deb xtract-folder/
cp xtract-folder/usr/bin/rclone /usr/local/bin/
rclone --help
rclone --version
```

The rclone version command should return something like this.

``` bash
rclone v1.41
- os/arch: linux/amd64
- go version: go1.10.1
```

## Google Drive with RClone

Google Drive is a great candidate for rclone integration as there are few (if any) serious Linux clients available for DevOps engineers that need CLI access to the drive.

``` bash
rclone v1.41
- os/arch: linux/amd64
- go version: go1.10.1
```




$$ rclone --version

rclone v1.41
- os/arch: linux/amd64
- go version: go1.10.1

$$ cd
$$ mkdir .rclone-config
$$ cd .rclone-config/
$$ rclone config

## RClone Error
```
2018/05/22 18:59:09 NOTICE: Config file "/path/to/rclone.conf" not found - using defaults
```


No remotes found - make a new one
n) New remote
s) Set configuration password
q) Quit config
n/s/q> n
name> ficando.googledrive
Can't use "ficando.googledrive" as it has invalid characters in it.
name> ficando@googledrive
Can't use "ficando@googledrive" as it has invalid characters in it.
name> ficando-googledrive
Type of storage to configure.
Choose a number from below, or type in your own value
 1 / Alias for a existing remote
   \ "alias"
 2 / Amazon Drive
   \ "amazon cloud drive"
 3 / Amazon S3 Compliant Storage Providers (AWS, Ceph, Dreamhost, IBM COS, Minio)
   \ "s3"
 4 / Backblaze B2
   \ "b2"
 5 / Box
   \ "box"
 6 / Cache a remote
   \ "cache"
 7 / Dropbox
   \ "dropbox"
 8 / Encrypt/Decrypt a remote
   \ "crypt"
 9 / FTP Connection
   \ "ftp"
10 / Google Cloud Storage (this is not Google Drive)
   \ "google cloud storage"
11 / Google Drive
   \ "drive"
12 / Hubic
   \ "hubic"
13 / Local Disk
   \ "local"
14 / Mega
   \ "mega"
15 / Microsoft Azure Blob Storage
   \ "azureblob"
16 / Microsoft OneDrive
   \ "onedrive"
17 / Openstack Swift (Rackspace Cloud Files, Memset Memstore, OVH)
   \ "swift"
18 / Pcloud
   \ "pcloud"
19 / QingCloud Object Storage
   \ "qingstor"
20 / SSH/SFTP Connection
   \ "sftp"
21 / Webdav
   \ "webdav"
22 / Yandex Disk
   \ "yandex"
23 / http Connection
   \ "http"
Storage> 11
Google Application Client Id - leave blank normally.
client_id> 
Google Application Client Secret - leave blank normally.
client_secret> 
Scope that rclone should use when requesting access from drive.
Choose a number from below, or type in your own value
 1 / Full access all files, excluding Application Data Folder.
   \ "drive"
 2 / Read-only access to file metadata and file contents.
   \ "drive.readonly"
   / Access to files created by rclone only.
 3 | These are visible in the drive website.
   | File authorization is revoked when the user deauthorizes the app.
   \ "drive.file"
   / Allows read and write access to the Application Data folder.
 4 | This is not visible in the drive website.
   \ "drive.appfolder"
   / Allows read-only access to file metadata but
 5 | does not allow any access to read or download file content.
   \ "drive.metadata.readonly"
scope> 1
ID of the root folder - leave blank normally.  Fill in to access "Computers" folders. (see docs).
root_folder_id> 
Service Account Credentials JSON file path  - leave blank normally.
Needed only if you want use SA instead of interactive login.
service_account_file> 
Remote config
Use auto config?
 * Say Y if not sure
 * Say N if you are working on a remote or headless machine or Y didn't work
y) Yes
n) No
y/n> y
If your browser doesn't open automatically go to the localhost link at port 53682 and url /auth
Log in and authorize rclone for access
Waiting for code...
Got code
Configure this as a team drive?
y) Yes
n) No
y/n> n
--------------------
[ficando-googledrive]
type = drive
client_id = 
client_secret = 
scope = drive
root_folder_id = 
service_account_file = 
token = {"access_token":"abc123xyz","token_type":"Bearer","refresh_token":"def456vwx","expiry":"2018-05-22T20:07:42.456245235+01:00"}
--------------------
y) Yes this is OK
e) Edit this remote
d) Delete this remote
y/e/d> y
Current remotes:

Name                 Type
====                 ====
ficando-googledrive  drive

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> q


#### Put the rclone.conf file into your credentials manager

$$ rclone lsd remote:
2018/05/22 19:20:38 Failed to create file system for "remote:": didn't find section in config file
$$ rclone lsd remote:ficando-googledrive
2018/05/22 19:20:58 Failed to create file system for "remote:ficando-googledrive": didn't find section in config file
$$ rclone lsd ficando-googledrive
2018/05/22 19:21:25 ERROR : : error listing: directory not found
2018/05/22 19:21:25 Failed to lsd: directory not found

$$ rclone lsd ficando-googledrive:
$$ rclone copy ficando-googledrive:iphone-contents-2013/10/17 .
$$ rclone copy ficando-googledrive:iphone-contents-2013/10/17 ficando-googledrive:newfolder
$$ rclone ls ficando-googledrive:
