
# Git Remote Origin | Working with Remote Repositories

A git repository can stand on its own two feet but usually we map local repositories to a robust central repository hosted by providers such as Github, Gitlab and Bitbucket.

A git **`remote origin`** is basically a url in either the **https** or **ssh** formats.

```
git config --get remote.origin.url     # print the remote origin url
git remote show origin                 # print origin info including urls
```


## Information About Remote Origins


## How to Delete a Remote Branch in Git

```bash
git push origin --delete name_of_remote_branch
```

Make sure you delete any local branches too with the below.

```bash
git branch -D name_of_local_branch
```
	

## How to Map to a New Remote Url

What if your local repository has never linked to a remote - basically you did a git init, git add then git commit?

In this case you need to **add an origin** as opposed to **resetting its url** like below.

```bash
git remote add origin git@github.com:<<USERNAME>>/<<REPO_NAME>>.git
git push --set-upstream origin master
```

### Connecting via SSH Config

If you have set a private key and altered the **`~/.ssh/config`** file by adding a section, then the add origin command is different.

```bash
git remote add origin git@<<SSH_CONFIG_NAME>>:<<USERNAME>>/<<REPO_NAME>>.git
git push --set-upstream origin master
```

Instead of stating `github.com` you state the name that was used in the SSH config file.


## How to Set Different Fetch and Push Origin Urls

To set different urls for git fetch and git push you first add the origin url which sets both and then update the push url to the one you'd like.

```
git --git-dir=<PATH_TO_DOT_GIT> --work-tree=<PATH_TO_LOCAL_REPO> remote add origin <FETCH_ORIGIN_URL>
git --git-dir=<PATH_TO_DOT_GIT> --work-tree=<PATH_TO_LOCAL_REPO> remote set-url --push origin <PUSH_ORIGIN_URL>
```


## How to Remove a Remote Origin

**`fatal: remote origin already exists.`**

The `remote origin already exists` error can be thrown when you are trying to add a remote origin. The solution is to first remove the existing remote origin.

```
git remote rm origin
```


## How to Change the Remote Url

If a remote git repository moves but maintains the same domain name, the source repositories mapping to it needn't know anything.

However if the hostname changes - we need to reconfigure the remote for local repositories and then when we push we make sure we set the upstream url (the shortcut is **`-u`**).

```bash
git remote -v
git remote set-url origin https://git.the-new-hostname.com/repository-name.git
git push --set-upstream origin master
```

The above changes 2 urls because Git maintains one URL for (fetch) and another for (push). In most cases these 2 are one and the same.

