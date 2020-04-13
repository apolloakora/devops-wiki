
# Github | The Git Repository Cloud Service

- **[Hub Documentation](https://hub.github.com/hub.1.html)**
- **[Hub CLI User Guide](https://hub.github.com/)**


## hub | The Github Command Line Interface

The key Github resource pages are

- **[GitHub.com Help Documentation]()**
- **[]()**
- **[]()**



Use `git --version` to ensure that git is at least at version 2.x

## Install hub on Ubuntu

```
sudo snap install hub --classic
```

## Install hub on Mac

```
brew install hub
```


## How to Authenticate with Github

export GITHUB_HOST=github.apolloakora
export GITHUB_USER=apolloakora
export GITHUB_PASSWORD=p455w0rd

git config --global hub.protocol ssh

GITHUB_HOST
The GitHub hostname to default to instead of "github.com".
GITHUB_TOKEN
OAuth token to use for GitHub API requests.
GITHUB_USER
The GitHub username of the actor of GitHub API operations.
GITHUB_PASSWORD
The GitHub password used to exchange user credentials for an OAuth token that gets stored in hub configuration. If not set, it may be interactively prompted for on first run.
GITHUB_REPOSITORY
A value in "OWNER/REPO" format that specifies the repository that API operations should be performed against. Currently only used to infer the default value of GITHUB_USER for API requests.



## How to Create a Repository

```
hub create --private --description=="This repository provisions virtual machines." apolloakora/provision_virtual_machine
```

-p, --private
Create a private repository.

-d, --description DESCRIPTION
A short description of the GitHub repository.

-h, --homepage HOMEPAGE
A URL with more information about the repository. Use this, for example, if your project has an external website.

--remote-name REMOTE
Set the name for the new git remote (default: "origin").

-o, --browse
Open the new repository in a web browser.

-c, --copy
Put the URL of the new repository to clipboard instead of printing it.



## How to Invite Collaborators



## How to Clone a Repository
## How to Clone a Repository
