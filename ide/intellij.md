
# IntelliJ



## How to Bring a Project Under Version Control

#### Prerequisite - the machine is configured with a private SSH key matching the remote repository public key.

If your project is underway and you want to share the project using Git version control you

- create the remote repository in Github, Gitlab or BitBucket
- in the IntelliJ VCS menu option **`Enable Version Control Integration`** and choose Git
- Add files into version control
- Commit into version control
- **`Ctrl Shift K`** - Push commits to the remote Git repo
- Click on the Add Remote link
- Enter the ssh or https url of the git repository

Now the code will be pushed up to the remote origin. Check via the web user interface.

Click on perspective 9 Git on the bottom left to enjoy the version control view of your project.
