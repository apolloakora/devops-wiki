
# How to Clone all Git Repositories | BitBucket | GitHub | GitLab

How can you clone every bitbucket, gitlab or git repository

- without complex sed, awk or regular expressions
- without typing the password every time

The first step is to setup **[[passwordless git interactions|passwordless git]]** (cloning, pulling, pushing) is the same as setting up passwordless ssh login.

Once that is done we run a simple ruby program to pick up the repository list, then loop through cloning them.

