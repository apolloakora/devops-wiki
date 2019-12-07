
# Git Checkout | Branch | Merge


## Git | Branch the Master Line

You’ve cloned the repository (see above) to a directory called mirror.app.assets.  Within the mirror.app.assets folder root

    $ git status
    $ git checkout -b ui/bug-4214
    $ git status


## Checking Out a Branch You Did NOT Create

When checking out a branch you did not create the command **'git checkout ui/contact-form'** will fail because that branch does not exist in your .git folder (under remotes).


### If Branch NOT on Local Machine

    $ git fetch origin
    $ git checkout -b <<branch>> origin/<<branch>>


### If Branch IS on Local Machine

    $ git fetch origin            # <<will bring a list of new branches>>
    $ git checkout <<branch>>     # may say already on <<branch>>
    $ git pull origin <<branch>>  # if checkout said your branch is behind


Now your workspace will echo the changes in the remote branch – your remotes will be up to date and you are ready to continue working on this branch.


## Naming Your Branch

Use either a **noun-verb** or a **verb-noun** style or both. You can use a **forward slash** to delineate the branch name. Examples are

    ssh-harden     # this is noun-verb
    validate-email # this is verb-noun

Another style is to use bug and feature ids like **feature-153.12** and **bug-146**. This manner is succinct but one has to refer to another app to understand so prefer the above method or at worst a combination of both like **login-lockout/feature-621**.

### Layer Prefix

For application stacks that are well delineated by layers you can prefix the branch name with terms like infrastructure, dblayer, app-engine, weblayer and ui.

### Application Interface Prefix

Application interfaces like the below can also be appended to make the branch name communicate more.

- cli
- rest-api
- web-ui
- mobile-ui


## Software Downloading Repository Assets from a Branch

Frequently operational and provisioning ( iaas – infrastructure as a service) software will download and use repository assets. If you want that software to read from your branch and not the master line use the below command.

  git clone -b ui-layer/bug-4214 http://www.assets4u.co.uk/vcs/know.how mirror.app.assets


## Pull Frequently From the Master Branch

If the team is pushing changes into the master branch (see step 7) – it pays for us to pull those changes (twice a day) into our branch. When the time comes to merge our branch back into the master – you will be glad you pulled frequently. If others are working on the same branch as yourself then employ the second command.

    $ git pull origin master
    $ git pull origin ui-layer/bug-4214

If no files or folders clash your branch will be updated with the current contents of the master branch making our lives significantly simpler when we come to merge our branch back into master (see step 7).


## Push Into the Branch

Once you have a gaggle of commits and you want to test your entire branch – the time has come to push up all your commits into the branch. This does not change the master branch – but it will allow you to see the up-to-date difference between your branch and the master.

    $ git push origin ui-layer/bug-4214


## How to Merge the Branch Back In

Finally we are ready for the team to see our bug fix. Aim to merge back into master once, twice or three times a day. It depends on how fast you develop a distinct feature or how fast you fix a bug, or how fast you perform a refactoring.

Three (3) common ways to merge our branch into the master exist

- the quick way
- the careful way
- the conflicts way



### 1. Git Branch Merging (The Fast Way)

Below is the fast (one-command) way to achieve merging our branch into master.

    $ git push origin ui-layer/bug-4214:master
    $ git branch -d ui-layer/bug-4214

Note the 2nd command deleted the branch on our local machine (the repository still has it).

This method cannot be used when an integration bug exists. An integration bug is when both branches work separately but not together.



### 2. Git Branch Merging (The Careful Way)

With the fast way you cannot forage and finger out integration bugs because master gets the branch changes immediately (in a conflict-free scenario).

We can forego changing the master branch after the merge.

With the careful way you can run exploratory and integration tests on the merged entity. If you aren’t happy abort changing the master.

The procedure is to

- pull master into a local folder
- perform the merge locally
- run integration and exploratory tests on the merged entity
- abort the merge if necessary
- push to the master branch if happy

As we are merging the two branches locally, we can resolve clashes and conflicts locally. You can now change your local repository in-place.

- **`git checkout master`**
- **`git pull origin master`**
- **`git merge ui-layer/bug-4214`**

The merge is done locally so do your integration and exploratory tests now. Skip the next step if you decide not to proceed.

To update the remote master (effectively merging the branch into it) – you issue this single command.

    $ git push origin master

In order to use git push you must have already run the command git push -u origin master in the session.



### 3. Git Branch Merging (The Conflict Way)

If there are conflicts between the branch and master – we need to step with even more care. Let’s assume the branch we are merging is called eco/cli.

First check out the branch that is to be merged.

    $ git fetch origin
    $ git checkout -b eco/cli origin/eco/cli

Then review the changes locally and when you are ready to proceed with the merge you do the following

    $ git checkout master
    $ git merge --no-ff eco/cli

Now is the time to resolve the conflicts. Simplest way is to go to the conflict locations and remove the line of left and right arrows and set the code in between them the way you want. Save and you are done – finally you push back to master.

    $ git push origin master
