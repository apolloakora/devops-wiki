
# Git Queries | diff | status | log | ls-files | ls-tree

Let's ask Git to **tell us something we don't already know!**


## Git Repo | The Last N Commits | Who When and Why

Who was involved in the last N commits, when did they do it and why?

```bash
git log -20 --format="%ai %h %ae %cn %s"         # List last 20 commits with date hash author and subject
git log -20 --format="%ai %h %ae %cn %s" | sort  # Oldest first list of the last 20 commits with details
```

## Git Repo | List Files Modified in Chronological Order

Viewing files that are being actively changed gives us a **feel** for what's happening to a repository project.

```bash
git ls-files -z | xargs -0 -n1 -I{} -- git log -1 --format="%ai {}" {} | sort -r    # Recently modified first
git ls-files -z | xargs -0 -n1 -I{} -- git log -1 --format="%ai {}" {} | sort       # Recently modified last
```


---


## Git Repo | List the last N Commits

What were the last 7 commits? Who issued them, when and what was the commit message?

```bash
git log --pretty=oneline | head -n 20   # Produce a brief listing of commits (one per line)
git config --local core.pager cat       # Print output of git log without going to less program
git log -7                              # List the last 7 commits with who made them and date
```

Note that **`git log`** defaults to using the less program so you have to press q to quit and so on.

You can just cat the output by changing the **core.pager** configuration.


---

## git diff | What will be pulled?

The lesser known triple dot comparator tells us what will happen when we do a git pull. You can even predict conflicts.

```
git diff ...master --unified=0                 # File line diffs incoming from master into current
git diff ...master --stat --color              # Excellent files that will change including summary
git diff --name-status <branch>...master       # 1 file per line difference between branch and master
git log ..master  --format="%ai %h %ae %cn %s" # List all the commits that we are behind from master
git --no-pager show ..master --unified=0       # List both the commit and the changes without context
git --no-pager show master --pretty=oneline    # Exactly same as git diff with triple dots
```

---

## git diff | What will be merged?

Do you want to know the differences between two branches - what will be merged?

```
git diff --stat --color master..                        # Listing of files (and changes) to merge
git diff --stat --color master...                       # Can be subtly different (not sure why)
git diff --name-status origin/master                    # All file differences if merging into master
git --no-pager show ...master --unified=0               # List each commit and each line changed
git log ...master  --format="%ai %h %ae %cn %s"         # All commits on this branch not on master
git log <branch>...master  --format="%ai %h %ae %cn %s" # Commits between any given branch and master
```


---


## Git Diff | What will be committed?

What will `git commit` commit? This is the most frequent git query that is used before running git commit.

```bash
git config --local core.pager cat  # Just print without reference to less
git config core.pager cat          # Same because git config defaults to --local
git diff -U0                       # what has changed (with zero lines of context)
git diff --unified=0               # same
git diff --unified=2               # print 2 lines (above and below) of context
```


---


## Git Show | What's in a commit?

    git --no-pager show <<commit-refe>> --unified=0

What changes makeup any **"pushed or unpushed"** commit? You first find the commit reference and then you can query for the changes.

    git cherry -v                          # List the unpushed commits on master
    git cherry -v origin master            # List the unpushed commits on master
    git cherry -v origin <<branch-name>>   # List the commits in a branch
    git --no-pager log origin/master       # List EVERY commit in the origin
    git --no-pager log HEAD                # List EVERY commit in the local repo

    git --no-pager show f6715b924 --unified=0  # Set out changes without context lines
    git --no-pager show f6715b924 -U0          # Set out changes without context lines

The above assumes a **commit reference of f6715b924** is available.


---


## Comparing Git Repository Changes between 2 Commits

This is a same branch comparison so you must first find the start and end commit references.

```
git config --local core.pager cat          # switch off the pesky terminal prompts
git log -10                                # list the last 10 commits
git log -10 --format="%ai %h %ae %cn %s"   # pretty print the last 10 commits
```

Now that you have the two commit references you can do this.

**`git diff 221636a 39ce3f7 -- ":(exclude)*/*.map" ":(exclude)*/*.jar" ":(exclude)*/*.js" ":(exclude)*/*.css" ":(exclude)*/*.html" ":(exclude)*/*.svg"`**

This lists the changes whilst excluding files not meant for human consumption.

```
git diff abcdefg7d4 hijklmno                      # there could be way too many changes
git diff abcdefg7d4 hijklmno -- ":(exclude)this"  # so you could exclude certain file types and paths
git diff abcdefy2a6 hijklmno -- *.yml **/*.yml    # or you could include certain file types and paths
```

git diff 221636a 39ce3f7 -- ":(exclude)*/*.js.map"

So an Ansible project that is primarily YAML can be productively diff'd.

Also note that the output gives you individual diff commands so you can examine changes more studiously.


---

## Git Commit Refs

Both the local and remote git repositories are at a commit reference at this point in time. Did you know that

- after a git pull the commit refs will be equal
- after a git push the commit refs will be equal
- after a git commit the local commit ref jumps one ahead of the remote commit ref
- after someone git pushes the remote ref jumps one ahead of the local commit ref

```
git ls-remote https://github.com/devops4me/safedb.net.git ls-remote -b master   # tell us the remote commit reference
git show-ref master
```


## Git ls-tree | List Repository Files

Give us a simple list of the files in a repository.

```
git ls-tree -r master --name-only
```
