
# How to Install Helm and Tiller (on Mac)

```
brew install helm   # for the latest version
brew install helm@2 # for a specific version
echo 'export PATH="/usr/local/opt/helm@2/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
helm init --client-only
helm plugin install https://github.com/rimusz/helm-tiller
helm tiller run helm version
```
