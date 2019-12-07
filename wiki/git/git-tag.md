
# Git Tags

**In Git, a tag is nothing more than an annotated pointer to a commit.**

## Why Tag a Repository

The [[Git tagging documentation]](https://git-scm.com/book/en/v2/Git-Basics-Tagging) states that **you tag in order to mark a specific point in history as being important** and a versioned release is just that - an important point in the lifecycle of a product.

By convention tags begin with a lowercase v and semantic versioning offers up 3 numbers for the major, minor and patch versions.

## Git Tag Commands

These are the most commonly used commands in relation to tagging.

``` bash
git tag -a <name> -m '<msg>'  # creates an annotated tag
git tag <name>                # creates a lightweight tag
git push origin --tags        # push all tags to origin
git push origin <name>        # push up just a single tag
git pull origin --tags        # pull down all repo tags
git --no-pager tag            # List all the tags
git tag -l "v1.8.5*"          # Search tags for a pattern
git tag -d <name>             # Remove a tag from a repo
git push origin :refs/tags/<name>
```

Like branches - tags do not get pushed up to a remote server automatically. You must manually do it by specifying the tag name starting with a v.

## How to Tag (After the Fact)

You can go back in history and tag a specific commit.

``` bash
git log --pretty=oneline   # list all the commits
```

```
166ae0c4d3f420721acbb115cc33848dfcc2121a started write support
9fceb02d0ae598e95dc970b74767f19372d61af8 updated rakefile
964f16d36dfccde844893cac5b347e7b3d44abbc commit the todo
8a5cbc430f1a9c3d00faaeffd07798508422908a updated readme
```

Now we can tag the commit starting with `9fceb02`.

```
git tag -a v1.0.0023 9fceb02
```

## Checking Out Tags | Bug Reproduction and Fixing

When a bug is reported against a particular version of the software you will often need to checkout that specific tag to reproduce it.

> Gotcha Warning @->> Do not commit to a checked out tag

The below checkout gives you the repository as it was at that point in time. Do not commit against this though otherwise you get the dreaded **detached HEAD state** condition.

```
git checkout v1.0.0023               # checkout just to reproduce
git checkout -b login.bug v1.0.0023  # checkout to reproduce and fix
```

Checking out the tag with a new branch is the preferred action. The bug fixing protocol should be

- checkout creating a new branch (eg login.bug)
- perform a commit - test - ouch - perform another commit
- bug fixed so push up both commits
- now create another tag say version v1.0.0024
- push up this latest tag
- release against this new tag and branch
- merge the bug-fix branch into master (which may have moved ahead some)

To review the bug fix you diff against tag v1.0.0023 and tag v1.0.0024.

