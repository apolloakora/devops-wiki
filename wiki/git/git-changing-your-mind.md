
# Git | Changing Your Mind

The ability to change your mind, makes using Git a pleasure. After all a version control system is designed to record versions so that you can chop and change at will.

## Listing your Commit History

Use these commands to find the ID of the commit you want to roll back to.

- **`git log --pretty=oneline | head -n 20`** # simply list the last n commits
- **`git log -10`** # list with dates, author and message the last n commits


---


## Reverting Back to a Commit | Whole Repository

We describe three of the most common scenarios when reverting your entire repository state.

1. revert back to a particular commit on the branch you are on
1. start a branch from a commit point, work on it and merge back in
1. revert un-published (un-pushed) changes to a historical commit


If you need to do something more colourful you'll be glad to note that reams have been written on the subject of reverting repositories.

#### [StackOverflow - Revert Repository to Previous Commit](https://stackoverflow.com/questions/4114095/how-do-i-revert-a-git-repository-to-a-previous-commit)



### 1. Revert the Branch to Mirror a Commit

This technique does not rewrite history. It simply picks up the repository state at the commit point and leapfrogs it so that HEAD points to an exact mirror of that state.

- **`git revert --no-commit <<commit-reference>>..HEAD`**
- **`git commit -m "walking back because of this and that."`**

This walks back the repository to the commit point and --no-commit means you don't have to enter a commit statement for each commit point you meet on the way back.



### 2. Rewind to a Commit then Create a Branch

Once you know which commit you want to start from you checkout and start a new branch.

```
git checkout -b new/branch/name <<commit-reference>>
```

Visit the **[git branching primer](git-branching.md)** for more on how to manage your branch. The most common use case simply merges the branch back into the trunk line (develop or master) using these commands.

- **`git checkout master`**
- **`git pull origin master`**
- **`git merge ui/bug-4214`**
- **`git push --set-upstream origin master`**

Replace **`master`** with your chosen destination branch and **`ui/bug-4214`** with your source branch.



### 3. Revert un-published Changes

As long as you have not pushed (published) changes you can simply revert back to a commit point and **trash** one or more of your local changes and commits.

- **`git reset --hard <<commit-reference>>`**



---



## Added one or more files by mistake? | git add

**Problem** - You've done **`git add <<filename>>`** but you've changed your mind and you do not want to commit the file. You've not yet done a **`git commit`**.

**Pre-Check** - **`git status`** and check that the file is in the **Changes to be committed** list.

**Solution 1** - **`git reset <<filename>>`** to un-add one file
**Solution 2** - **`git reset <<filepath/*>>`** to un-add all files in a directory

**Post-Check** - **`git status`** and ensure the file, files or directory is/are in the **Untracked files** list



---



## Committed a file by mistake? | git commit

**Problem** - You've committed a file by mistake using **`git commit`** maybe as part of a numerous file commit set. Maybe you've pushed and github says **this exceeds GitHub's file size limit of 100.00 MB**.

**Pre-Check** - **`git cherry -v`** shows the commit that is sitting there un-pushed.

**Solution** - **`git rm --cached path/to/file`**

**Post-Check** - **`git status`** now displays the file in **both** the **Changes to be committed** and the **Untracked files** sections. The change to be committed is a delete.

Now you can continue with a **`git commit`** to rip out the file, a **`git status`** to check and then **`git push`** to complete the reversal.



---



## Changing Your Mind (Break this up into smaller pieces)

You’ve changed your mind about the changes in a file and you want to revert. What you do depends on these situations

1. the local file is identical to the one in the repository branch but different to the one in master.
1. the local file is identical to the one in the commit set but different to the one in the repository branch.
1. the local file is not in the commit set and is different to the one in the repository branch.


### 1. file is identical to branch | different from master

#### Your Intent

You want to roll back and make the file contents match the one on the master branch.

#### Your Situation

Your local file is not in the commit set. Furthermore it is identical to the file in the repository branch that you are working on.

#### Your Saviour

- **`git checkout origin/master path/to/file`**

Assert that git status lists your file in the index (commit set). Your file is listed as “modified”.

Once you commit and push to the branch – the contents of the file in the repository branch will have been rolled back and are identifical to the contents of the file in master.


### 2. file is identical to commit set | different from branch

#### Your Intent

Actually you want to see two things.

    your local file identical to the file in the repository branch and
    the file removed from the commit set

#### Your Situation

You change your mind after editing the file and putting it into the commit set (with a git add path/to/file.

You want to undo two things. You want to undo your edits and you want to undo putting the file into the index (commit set).

#### Your Saviour

- **`git reset HEAD path/to/file`**
- **`git checkout path/to/file`**

Now do git status and your file should no longer be in the index (commit set).

Also your local file has been rolled back and is identical to the file in the repository branch.


### 3. file not in commit set (index) | different to repository branch

#### Your Intent

You want to roll back the edits you made to a file. You want the file contents to be identical to the file in the repository branch.

#### Your Situation

Your local file is not in the commit set. You edited it but you did not do a git add path/to/file. However, the contents of your file differ fron the contents of the file in the repository branch you are working on.

#### Your Saviour

- **`git checkout path/to/file`**

Assert that git status still does not list your file in the index (commit set).

Check that your local edits have vanished (been rolled back). The local file is now identical to the file in the repository branch.
