
# Zip | Unzip | Tar | GZip

When interacting with **`Windows`** we use zip and unzip instead of the **tar and gzip** tooling.

To recursively zip up a directory and then unzip it somewhere else here is the command set.

```
sudo apt install --assume-yes zip gzip tar
cd <<folder-containing-folder-to-zip>>
zip -r <<name-of-package>>.zip <<folder-to-zip>>
unzip <<name-of-package>>.zip
```

```
mkdir ziptime
cd ziptime/
sudo cp -R ~/runtime/* .
sudo chown -R $USER:$USER *
```

