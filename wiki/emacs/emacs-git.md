#### Powerful views disseminate an incredible amount of information at a glance, whilst staying simple. The best views highlight an aspect of a complex subject and quickly communicate information and intelligence while you efficiently explore, learn, understand and make decisions. The Git interfaces in emacs are a good example of a powerful view.

# Git Emacs | Use Git via Emacs

The **emacs git vc mode** combines the power of emacs with the power of git. In doing so it delivers substantial productivity hike.

You can interact with git from multiple outposts including

- the **vc directory** accessible through **`Ctrl-x v d`**
- the **emacs directory editor** (dired)
- any **file buffer** (even yet-to-be-added files)
- the little **command buffer** at the bottom

## Git Emacs | Repository or File Level

Similar to the buffer that displays files and directories, emacs has a version control view giving you oversight of the VC state of your **local git repository** and its interaction with the **origin repository**.

```
Alt-x vc-dir         # open the version control directory view
Alt-x vc-rename-file # rename or move a file or a folder
Ctrl-x v d [Enter]   # open the version control directory view
g                    # refresh the view after making changes
Ctrl-x k [Enter]     # kill the version control directory view
```

The above can be done when visiting any repository file ( not just the root git folder ) - also from shells and the directory editor (dired).

## The VC Directory View

This view is the centrepiece of the e-macs version control offering. You can see the entire change set of files including the files and folders that

- are (unregistered) not in repository
- exist only in the external repository [+] on root or subsequent repository tree folder.
- have been registered but not committed
- have recently been committed
- have been changed in the working directory
- contain conflicts against the repository
- were changed and by which revisions


### Core Git Commands from VC Directory View

The core git comands **clone, checkout, pull, add, commit and push**.

The most common git use case is to clone, checkout a branch, pull in remote changes, add files to a commit set, commit and push changes to a remote repository. These commands are issued when inside the version control directory view.

- **`shift-plus`** | ***git pull***
- **`i`** | ***git add***
- **`D`** | **prints every line in the current commit set**
- **`=`** | **prints lines in file (or total)  commit set**
- **`v`** | ***git commit*** then **`ctrl-c ctrl-c`** after comment
- **`ctrl-x v O`** | **Log (O)utgoing - What will be pushed?**
- **`ctrl-x v P`** | ***git push***
- **`ctrl-x v I`** | **Log (I)ncoming - What will be pulled?**
- **`ctrl-x v +`** | ***git push***
- **`ctrl-x v u yes`** revert file (reset) to undo un-commited changes
- **`x`** | ***refresh (hide up-to-date files)***
- **`f`** | visit file in current buffer
- **`o`** | visit file in another buffer
- **`q`** | quit the vc-buffer and bury it
- **`l`** | list the file's change log
- **`L`** | list each and every one of the repo's commits
- **`G`** | adds file to .gitignore (if it exists)


By moving to the dot slash ./ line – you can act on all files and folders listed in the emacs version control directory (vc dir).

***You can do this only if all the files and/or folders are in the same version control state.***

## Git Emacs | File Level

When visiting a file normally in a bog-standard emacs buffer you can press

- **`Ctrl-x v x`** Delete (remove) file from version control (confirm with yes and y)
- **`Ctrl-x v =`** for lines differing between the working copy and commited (local) repo
- **`alt-x vc-diff`** (same as above)
- **`Ctrl-x  v g`** who changed which line when (for current set of file lines).
- **`Ctrl-x v u yes`** revert file (reset) to undo un-commited changes
- **`alt-x vc-annotate`** (same as above)
- **`Ctrl-x v ~ Tab`** provides list of file revisions to navigate to
- **`Ctrl-x v l`** show list of file commits with ref, person name and date


### Untested Commands

More work and understanding required to make full use of the functionality below.

```
C-x v s vc-create-snapshot — tag all the files with a symbolic name
C-x v r vc-retrieve-snapshot — undo checkouts and return to a snapshot with a symbolic name
C-x v a vc-update-change-log — update ChangeLog
C-x v m vc-merge
C-x v h vc-insert-headers
M-x vc-resolve-conflicts — pop up an ediff-merge session on a file with conflict markers
```
