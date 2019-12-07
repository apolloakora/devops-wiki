# RVM | Ruby Gem Environment Isolation







On branch master
Your branch is behind 'origin/master' by 2 commits, and can be fast-forwarded.
  (use "git pull" to update your local branch)
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   documents/programming/ruby/gems/publish-ruby-gems.md

--------------------------------------------------
Changes not staged for commit:
diff --git i/documents/programming/ruby/gems/publish-ruby-gems.md w/documents/programming/ruby/gems/publish-ruby-gems.md
index 1c96173..4c66993 100644
--- i/documents/programming/ruby/gems/publish-ruby-gems.md
+++ w/documents/programming/ruby/gems/publish-ruby-gems.md
@@ -13,9 +13,16 @@ title =  RubyGems.org | How to Use Ruby Gems
 -->
 
 
-## Deploy to RubyGems.org | Learn to Build, Install, Test and Release Gems
+#### Before we can deploy to RubyGems.org we need to know how to
 
-### First install rvm.
+- yard | document gems and read gem documentation
+- rake | up the gem version and then build gems
+- rake | install gems either locally (to the user) or systemwide
+- rake | install gems either locally (to the user) or systemwide
+- test gems
+- release Gems
+
+## First install rvm.
 
 ``` bash
 sudo apt-add-repository -y ppa:rael-gc/rvm
@@ -41,7 +48,7 @@ After rebooting - hit Windows button then type "ter" and enter to enter the term
 - Click on Command Tab
 - Check the "Run Command as a Login Shell" box.
 
-### Use RVM to Install Ruby then Create and Use GemSet
+## Use RVM to Install Ruby then Create and Use GemSet
 
 Go to a terminal and enter
 
@@ -51,6 +58,25 @@ rvm gemset create <<gem_name>>
 rvm gemset use <<gem_name>>
 ```
 
+## IMPORTANT - with gemset use - I believe affects other commands.
+
+## rvm all do gem install | Use rvm to Install Gems
+
+After rvm installs ruby - gems stop being referenced from an obscure system directory and start being referenced from within the .gems folder in your home directory. This makes life easier and sudo is not needed during development.
+
+``` bash
+rvm all do gem install net-ssh
+rvm all do gem install net-scp
+```
+
+### rvmsudo | the force gem install command
+
+Do not use the below command normally because it will create gems in your user area **~/.rvm/gems/ruby-2.4.1/gems/** as root making subsequent updates fail. But its good to know rvmsudo exists.
+
+``` bash
+rvmsudo gem install filesize
+```
+
 
 ### Install bundler
 















We will use RVM (Ruby Version Manager) to **install Ruby**, **install Rake** and then **Create a Gemset**. Then we will create a **Hello World** gem and deploy it to rubygems.org.

Problems will arise if 2 or more of your gems share the same interpreter and central gem libraries (and versions).

It pays to separate out your gem development so each project specifies its own Ruby interpreter version and dependent gem versions.

## Install RVM | Use RVM to Install Ruby

Install RVM and add the uses that need it to the rvm group.

    sudo apt-add-repository -y ppa:rael-gc/rvm
    sudo apt-get update
    sudo apt-get install --assume-yes rvm
    sudo usermod -a -G rvm &lt;&lt;username&gt;&gt;

Now logout and login again and test the new rvm command.

    rvm list known
    rvm install ruby

The output from the Ruby install is like below for **Ruby Version 2.4.1**.

```
Searching for binary rubies, this might take some time.
Found remote file https://rvm_io.global.ssl.fastly.net/binaries/ubuntu/16.04/x86_64/ruby-2.4.1.tar.bz2
Checking requirements for ubuntu.
Requirements installation successful.
ruby-2.4.1 - #configure
ruby-2.4.1 - #download
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 16.4M  100 16.4M    0     0  4490k      0  0:00:03  0:00:03 --:--:-- 4491k
ruby-2.4.1 - #validate archive
ruby-2.4.1 - #extract
ruby-2.4.1 - #validate binary
ruby-2.4.1 - #setup
ruby-2.4.1 - #gemset created /home/apollo/.rvm/gems/ruby-2.4.1@global
ruby-2.4.1 - #importing gemset /usr/share/rvm/gemsets/global.gems..................................
ruby-2.4.1 - #generating global wrappers........
ruby-2.4.1 - #gemset created /home/apollo/.rvm/gems/ruby-2.4.1
ruby-2.4.1 - #importing gemsetfile /usr/share/rvm/gemsets/default.gems evaluated to empty gem list
ruby-2.4.1 - #generating default wrappers........
```

## gemset | Use RVM to Create a New Gemset

RVM is the best at creating a gemset that will easily deploy to rubygems.org. The gemsets created by bundler and/or rake are not comprehensive and will not deploy to rubygems without much tweaking.

``` bash
rvm gemset create <<gem_name>>
rvm gemset use <<gem_name>>
```

Rake is automatically installed and we can now proceed to use rake to build, test, install and release our gems.

