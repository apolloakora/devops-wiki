
# Google Chrome Browser

## How to Install the **Google Chrome** Browser on Ubuntu 18.04 and 16.04

Firefox comes pre-installed but Chrome does not. Installing it requires the below commands.

```bash
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
sudo apt-get install --assume-yes google-chrome-stable
```

