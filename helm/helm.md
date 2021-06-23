
# How to Install Helm (and maybe Tiller) on Mac

On the Mac you will need to run both helm2 and helm3 for various use cases.

## How to Install helm version 2 with tiller

```
brew install helm   # for the latest version
brew install helm@2 # for a specific version
echo 'export PATH="/usr/local/opt/helm@2/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
helm init --client-only
helm plugin install https://github.com/rimusz/helm-tiller
helm tiller run helm version
```


## How to Install helm3 whilst keeping helm2

If we already have helm2 installedd with **`brew install helm@2`** then the following commands should work.

```
helm2 version
helm2 tiller run helm2 version
```

We would expect something like this after the **`helm2 tiller run helm2 version`** command.

```
Installed Helm version v2.16.7
Installed Tiller version v2.16.7
Helm and Tiller are the same version!
```

Now to upgrade to helm3 use these commands.

```
brew install helm
cd /usr/local/bin
ln -s helm helm3n
helm3 version
```

Now the command **`helm3 version`** should indicate v3 is installed. Also check that helm2 and tiller are still alive and well with these commands.

```
helm version
helm2 version
helm tiller run helm version
helm2 tiller run helm2 version
```
