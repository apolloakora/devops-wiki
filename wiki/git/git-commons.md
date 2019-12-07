
# Git Commons | Clone | Add | Commit | Push | Pull

Git – The 7 Simple Git Tasks

    create or connect to a Git repository
    branch the master line
    edit, add and delete files and folders
    commit (to the branch) frequently
    pull frequently (this makes the merge easier)
    push into the branch
    merge the branch back into the master

Don’t worry you are still doing 3 things – checking out repository files usually from a remote repository, changing your copy and checking your changes back into the repository. Git is still the copy modify merge model (as opposed to lock change unlock).
Git Configuration – Line Endings | Global or Local

## Colorful Git Responses

```
git config color.ui true
```


## Linux vs Windows

```
git config --global core.autocrlf input  # for Linux based git clients
git config --global core.autocrlf true  # for Windows based git clients
```

## Git Username and Email

You can configure using –local or –global (steer clear of –system). You need to tell git your full name and email address.
For scripts it is best to use --local and for human beings on a Windows client say it is best to use --global

Human Being

```
git config --global user.name "Apollo Akora"
git config --global user.email "apolloakora@gmail.com"
```

DevOps Software

```
git config --local user.name "DevOps Script"
git config --local user.email "devops@assets4u.co.uk"
Git Passsword Config | Working Copy
```

You don’t want to retype your password again and again. So perform edits and do a git commit.
Then type in this config command and push.

```
git config credential.helper store
git push -u origin master
```

The console will ask for your username and password. Give it once and you’ll never have to give it again for the working copy.
Note : You will need to repeat this every time you clone a repository into a working copy.



## 0. The First Git Client Interaction with a Git Repository

This is the simple case – you can interact with a git repo via archive files, ssh, and so on.

Assume we have installed GitLab and we have a username and password to the repositories that we have setup within it. Cloning is easy.

  git clone http://www.assets4u.co.uk/commons/laundry4j.com.git/ mirror.laundry4j
  git checkout -b first/branch
  ... (make changes)
  git add .
  git commit -m "The first repository checkin"
  git push -u origin first/branch
  ... (enter username/password)

Either in emacs or Git Bash or DOS prompt (do not use Tortoise Git) – Git will pop up a box asking for the username and password. Enter these and you are done.
First Git Workspace – Important Notes

The below are important and need careful attention.

    the forward slash after dot git is important .git/
    append .git/ in the above clone url to avoid pesky warnings
    append .git/ to url in workspace .git/config file if you forgot
    ensure in main git config (off home) » autocrlf = true




## 1. Create or Connect to a Git Repository

The most common use case is connecting to a ready-made remote repository which is readable by everyone.

  git clone http://www.assets4u.co.uk/docs/ mirror.documentation.git
  cd mirror.app.assets

Git Clone | Key Considerations

Keep two things in mind when you clone a repository.

    End the repository url with a forward slash.
    End (with .git) the name you choose for the git assets folder.

If you omit the final forward slash when cloning the repository you will get the below warning every time you do a git push origin ...

    warning: redirecting to … 

Lucky for you – the final forward slash omission is fixable.

Visit the .git/config file (off your local working directory) and add the final forward slash there.
Creating the Original Git Repository

To create the original (source) repository, you can

    create an account at GitHub, GitLab or BitBucket
    create a (local file accessible) git repository
    create a (remote ssh accessible) git repository
    instal GitLab and http/https wire it with nginx

The Git Front Ends

You manage Git (and all version control systems) from a local mirror called a “working directory” or “working copy” and a way to issue commands.

Front end client software talks to the Git API on your behalf. You can choose to use one (or more) of the below Git clients

    Tortoise Git – a high quality Windows based GUI. It has a great diff and conflict resolution interface.
    Git Bash – a command line (or GUI) shell which coincidentally rolls out (brings to Windows), most Linux shell commands as a tribute to its (Git’s) creator – Linus Torvalds).
    any SSH Client like Putty or MobaXTerm – they talk to a remote Git repository by issuing commands through SSH (TCP based) protocol (only for hardcore users).
    Emacs Generic Version Control Interface – emacs has a generic interface that talks to Git, Subversion, Mercurial, Perforce and more. Clearly the productivity boost is felt most keenly by emacs users.
    Every self-respecting IDE ships with a Git communicator as standard – this includes IntelliJ, Eclipse, Visual Studio, NetBeans and PyCharm.

The 4 Git Back Ends

GitHub, BitBucket (and the hosted GitLab) are free as long as everyone can read your intellectual property. If you can install GitLab, you get to choose who can read (fork) and/or write (merge) to it.

The 4th Git Backend – Your Filesystem. – Every git working directory is a repository all in itself carrying the full repository version history.

git clone http://www.assets4u.co.uk/ mirror.app.artifacts.git

The git clone command gives you a mirrored functional repository containing the full version history.





## 3. Edit, Add, Delete, Rename Files and Folders

$ git add puts a file or folder into the commit set
git add | Adding to the Commit Set

Just go ahead and create files and folders, edit them and even delete them. It’s all good.

Run this command after you either create or change a file that you want to commit.

git add path/to/new-file.txt

git add | When do I use it?

In Subversion you add the file just once (after it is newly created). In Git you have to add the file every time you want to commit the changes. If you don’t add it, it won’t get committed. There is a shortcut in the next section by employing the -a switch to git commit.

You do need to use git add when

    you have created a new file
    you have edited a file and you want to version your changes
    you remove an already committed file
    you have renamed a file without using git rename

But you do not need to use git add when

    you use git rm to remove a file or folder
    you use git mv to move a file or folder
    you plan to use the a switch in git commit -a -m “Commit Message.”

Using git add (Period)

    Tip | Using git add (period)

    Did you know you can use git add (period).

    git add .

    Running this at the folder root of your working copy will add every single changed file to the commit set. It doesn’t add new files but it can be really handy if your IDE does a massive refactor and changes 200 files here there and everywhere. 

Be careful not to delete files or folders that have been committed. The simple way is to sync (commit) them first.

Also renaming or deleting files changed in the repository (since you cloned it) – can cause stress. So it pays to refresh (“pull” or “checkout”) before the rename or delete.

It is best to use git mv because your version history will be preserved and viewable against the renamed file.

Finally note that Git can maintain version history when files and folders are renamed. Other repository managers treated renaming as “deleting” and then “adding” thereby banishing the history. Git does it better so you Git rename.
Empty Folders are Ignored

git by name becomes git by nature and ignores you

You will be ignored if you create an empty folder and try a git add or git status. Git by name really does become a git by nature.









## 4. Commit to the Branch Frequently

You should commit every time a small change works – so every 10 to 15 minutes if you are adding and editing familiar code. This git command commits to our branch. It commits the files we have created, edited, removed and/or renamed and explicitly added with the git add command.

Go to our mirror.app.assets repository root.

  git status
  git commit -m "fixed validation of email addresses lacking periods"

Shortcut | Adding to the Commit Set During the Commit

If you are editing many files (or your IDE does a massive cascading refactor for you) – it makes no sense to add each and every file to the commit set individually. Lucky for us, git commit has a -a switch which assumes you want to add all new and edited files to the commit set.

  git commit -a -m "fixed validation of email addresses lacking periods"
  git status

Git Commit Name / Address Warning + Line Endings Protocol

    Your name and email address were configured automatically based
    on your username and hostname. Please check that they are accurate. 

To avoid the above warning and to have the correct Windows/Linux line endings add the below snippet to the .gitconfig file in your home directory.
For emacs projects you add the below to the mirror.app.assets/.git/config file. Beware not to duplicate the [core] block as it may already exist.

    [user]
    name = Apollo Akora
    email = apolloakora@gmail.com
    [credential]
    helper = manager
    [core]
    autocrlf = true

Once done, you should see the more succinct text below after git commit.

    git commit -a -m “Committing a wee change.”
    [ui-layer/bug-4214 2b0ee8e] Committing a wee change.
    1 file changed, 1 insertion(+), 1 deletion(-)

