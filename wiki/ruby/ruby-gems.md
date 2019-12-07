

# Setup Ruby Gem Development Environment | Bundler | Rake | [yard] | rubygems.org | Thor | Cucumber | Aruba

For Ubuntu 16.04 and 18.04

System ruby and ruby for gem development are completely different beasts. These commands will install Ruby for gem development.

The third command should produce output similar to this stating the Ruby version.
<pre>
ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux-gnu]
</pre>

### **Note that you need to give the user write permissions to every under the /var/lib/gems directory. ?? Do we - let us check the validity of this statement by not doing it next time.**

## Why is RVM Used

Just using system ruby for development leads to problems down the road with clashing dependencies and more. RVM provides a Ruby environment for the specific shell you are using to develop ruby gems.

This means you can use Ruby 2.3.x for gem development while using Ruby 2.5.x for your other system dependencies.

## How to Install RVM

This is a weird one - not sure how it would work on a server.
But on a client you go into regular non emacs shell and click preferences then go to command then tick the "run command as a login shell".

When you come out and you do rvm --version it should work.
But will not work in emacs.

After installing rvm you must add the user to the rvm group and then log out and log back in again.

``` bash
sudo apt-get update && sudo apt-get --assume-yes upgrade
sudo apt-get install software-properties-common
sudo apt-get update
sudo apt-get install ruby --assume-yes  ## maybe we do not want the system version of ruby
ruby --version
sudo apt-get install ruby-dev --assume-yes ## else rake will not work as C extensions cannot be compiled
ls -lah /var/lib/gems/2* ## Is root the owner - if so rake install will fail
sudo chown -R `whoami`:`whoami` /var/lib/gems   ## allows for gem development without using sudo
sudo chown -R `whoami`:`whoami` /usr/local/bin  ## this will allow installing of gems without sudo
ls -lah /var/lib/gems/2* ## change the owner to the current user

gem install bundler  ## To create a new gem with gemspec, gitignore, and more
gem install yard     ## To run a yard documentation server through http://localhost:8808
bundler <<gem-name>>

## Try NOT installing rvm - for now till we understand its use case
sudo apt-get install -y curl gnupg build-essential
sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | sudo bash -s stable
sudo usermod -a -G rvm `whoami`
getent group rvm
```
Now that your local gem development is up and running let's release to rubygems

## rubygems.org | releasing

We must create an account at http://rubygems.org and have the email address and password handy. Before we release with `rake release` we need to generate a credentials file locally to authenticate with the public rubygems api.

Note - put the `$HOME/.gem/credentials` file into your secrets vault (like HashiCorp's Vault, Git Secrets, the (no-cloud) opensecret, or credstash for python and AWS enthusiasts.

``` bash
gem build <<gem-name>>
gem push <<gem-name>>
```

**gem build** will quite rightly recommend that dependencies should not be open ended (the default is greater than or equal to zero). If it builds successfully it should return the below lines.

<pre>
  Successfully built RubyGem
  Name: <<gem-name>>
  Version: 0.0.987
  File: <<gem-name>>-0.0.987.gem
</pre>









## rvm | upgrade/downgrade ruby version for gem development

Suppose you want to jump back and forth to see whether your priceless gem works for Ruby version 1.9 and then 2.4.1 and then 2.3.0 - you use rvm - **but never with sudo**.

### rvm | Why never with sudo?

Never do **sudo rvm** as rvm should never change your system (that other apps depend on). It should only change your user area whilst you develop a gem. You want rvm to fail if it starts trying to change system-wide locations like `/usr/share/...` or `/var/lib/gems/2.3.0/...`

### rvm | Use a Ruby version for Gem Development

To use a ruby version (for that first time) that has not yet been downloaded you install it.

``` bash
ruby --version
rvm use 2.5.1
rvm install "ruby-2.5.1"
ruby --version
```

Hey nothing changed! The first and last ruby version commands say the same thing.
You must do an rvm use for version 2.5.1 after the rvm install command.

``` bash
ruby --version
rvm use 2.5.1
ruby --version
printenv
```

Now the version changes.

Look at the environment variables and you'll see a handful of changes including your path to the ruby binary. The ruby version will revert back to the default once you login to another shell.

### rvm | rake install fails

After you change the ruby version rake will fail.

<pre>
rake aborted!
LoadError: cannot load such file -- bundler/gem_tasks
</pre>

You **installing bundler** for the new ruby version and **rake install** will work.

``` bash
gem install bundler
rake install --trace
```
You are done switching ruby versions.

### rvm | down or upgrade after rvm install

Now to test your gem with another (even older) version of ruby you simply run the one **rvm use** command with a version parameter.

``` bash
rvm use 2.3.0
```

When you log out of the shell and log back in your ruby version reverts back to the system version.


## rvm | install output


The output from `rvm install "ruby-2.5.1"` is something like the below.

<pre>
Searching for binary rubies, this might take some time.
Found remote file https://rvm_io.global.ssl.fastly.net/binaries/ubuntu/16.04/x86_64/ruby-2.5.1.tar.bz2
Checking requirements for ubuntu.
Requirements installation successful.
ruby-2.5.1 - #configure
ruby-2.5.1 - #download
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 16.8M  100 16.8M    0     0  8464k      0  0:00:02  0:00:02 --:--:-- 8468k
No checksum for downloaded archive, recording checksum in user configuration.
ruby-2.5.1 - #validate archive
ruby-2.5.1 - #extract
ruby-2.5.1 - #validate binary
ruby-2.5.1 - #setup
ruby-2.5.1 - #gemset created /home/<user>/.rvm/gems/ruby-2.5.1@global
ruby-2.5.1 - #importing gemset /usr/share/rvm/gemsets/global.gems..............................
ruby-2.5.1 - #generating global wrappers........
ruby-2.5.1 - #gemset created /home/<user>/.rvm/gems/ruby-2.5.1
ruby-2.5.1 - #importing gemsetfile /usr/share/rvm/gemsets/default.gems evaluated to empty gem list
ruby-2.5.1 - #generating default wrappers........
</pre>


## rvm | is not emacs friendly

Remember that rvm does not work inside emacs (the old version anyway - try the new emacs). If it still complains then use a simple shell.










## openssl version | ruby

OpenSSL is never compiled along with Ruby - instead Ruby is told at compile time where to look for OpenSSL. This command will tell you the directory where ruby looks.

``` bash
ruby -r rbconfig -e 'puts RbConfig::CONFIG["configure_args"]'
```

Once you have the directory go to it and execute these commands.

``` bash
./openssl version
```


## Command Bin | These commands exist in case the above does not work.Once above is verified - Delete them.


rvm install ruby
rvm --default use ruby
ruby --version





  * First you need to add all users that will be using rvm to 'rvm' group,
    and logout - login again, anyone using rvm will be operating with `umask u=rwx,g=rwx,o=rx`.

  * To start using RVM you need to run `source /etc/profile.d/rvm.sh`
    in all your open shell windows, in rare cases you need to reopen all shell windows.





Have a gem in Git ready to test out the ruby command line dev environment.



``` bash
git clone https://<<git-host>>/<<group>>/<<project>>.git mirror.<<project>>
cd mirror.<<project>>

```






# How to Create and Publish Ruby Gems to RubyGems.org

<!-- facts

[page]
authority = publish ruby gems to rubygems.org, publish ruby gems, release ruby gems, create ruby gems, install ruby gems, install yard, install rake, install bundler, ruby documentation, rdoc

[http://guides.rubygems.org/]
authority = ruby gems, rubygems.org
title =  RubyGems.org | How to Use Ruby Gems

-->


## Ruby Version | Ruby Last Stable Release

```
https://www.ruby-lang.org/en/downloads/
```

To discover the current stable version or to check which versions are still being actively supported visit this link.


## GemSpec | How to Write Portable Gems

A great gemspec assures gem usability and portability and orchestrates the install of your working gem on Ubuntu, CoreOS, RHEL, CentOS, Windows, MacOs, iOS, Android and more besides.

### Understanding Dependency

Many gem writers test gems on their systems and deploy to RubyGems assuming it will just work for everyone. It often **doesn't work** and won't work because

- the **gemset** on the developer's workstation **differs** from target environments
- using *require* fails because the **dependency wasn't specified** in the gemspec (so isn't downloaded)
- dependency **version mismatches** breaks the software due to ***gem versions not being specified***.
- the **version of ruby** itself (and bundler and, rake) on the target machine are incompatible.
- **dependent packages only work on some platforms** *(eg OpenSSL does not work on Windows)*.
- protocols used are not supported by some platform (eg net-scp, net-ssh mostly don't work on Linux)


### Troubleshooting Dependency Issues

``` ruby
puts $LOADED_FEATURES.grep(/openssl/)
```

Examining the LOADED_FEATURESk data structure and focusing in on OpenSSL helps to debug dependency errors like this one.

```
undefined method `scrypt' for OpenSSL::KDF:Module (NoMethodError)
```


### Gem Commands | Portability and Usability

Some commands that can help you assert usability and also portability are

- <tt>gem check opensecret</tt> - look at extra and/or missing files
- <tt>gem cleanup</tt> - clears out the clutter of older versions
- <tt></tt> 
- <tt></tt> 
- <tt></tt> 
- <tt></tt> 
- <tt></tt> 



### Dependency management is key. 

``` ruby
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twitter/version'

Gem::Specification.new do |spec|
  spec.add_dependency 'addressable', '~> 2.3'
  spec.add_dependency 'buftok', '~> 0.2.0'
  spec.add_dependency 'equalizer', '~> 0.0.11'
  spec.add_dependency 'http', '~> 3.0'
  spec.add_dependency 'http-form_data', '~> 2.0'
  spec.add_dependency 'http_parser.rb', '~> 0.6.0'
  spec.add_dependency 'memoizable', '~> 0.4.0'
  spec.add_dependency 'multipart-post', '~> 2.0'
  spec.add_dependency 'naught', '~> 1.0'
  spec.add_dependency 'simple_oauth', '~> 0.3.0'
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.authors = ['Erik Michaels-Ober', 'John Nunemaker', 'Wynn Netherland', 'Steve Richert', 'Steve Agalloco']
  spec.description = 'A Ruby interface to the Twitter API.'
  spec.email = %w[sferik@gmail.com]
  spec.files = %w[.yardopts CHANGELOG.md CONTRIBUTING.md LICENSE.md README.md twitter.gemspec] + Dir['lib/**/*.rb']
  spec.homepage = 'http://sferik.github.com/twitter/'
  spec.licenses = %w[MIT]
  spec.name = 'twitter'
  spec.require_paths = %w[lib]
  spec.required_ruby_version = '>= 1.9.3'
  spec.summary = spec.description
  spec.version = Twitter::Version
end
```


### Understanding the Gem Environment

Use this command to print out the complete listing of the gem environment on your workstation.

``` bash
gem ENV
```

<tt>
RubyGems Environment:
  - RUBYGEMS VERSION: 2.5.2.1
  - RUBY VERSION: 2.3.1 (2016-04-26 patchlevel 112) [x86_64-linux-gnu]
  - INSTALLATION DIRECTORY: /var/lib/gems/2.3.0
  - USER INSTALLATION DIRECTORY: /home/apollo/.gem/ruby/2.3.0
  - RUBY EXECUTABLE: /usr/bin/ruby2.3
  - EXECUTABLE DIRECTORY: /usr/local/bin
  - SPEC CACHE DIRECTORY: /home/apollo/.gem/specs
  - SYSTEM CONFIGURATION DIRECTORY: /etc
  - RUBYGEMS PLATFORMS:
    - ruby
    - x86_64-linux
  - GEM PATHS:
     - /var/lib/gems/2.3.0
     - /home/apollo/.gem/ruby/2.3.0
     - /usr/lib/x86_64-linux-gnu/rubygems-integration/2.3.0
     - /usr/share/rubygems-integration/2.3.0
     - /usr/share/rubygems-integration/all
  - GEM CONFIGURATION:
     - :update_sources => true
     - :verbose => true
     - :backtrace => false
     - :bulk_threshold => 1000
     - :sources => ["https://rubygems.org/"]
     - "gem" => "--document=yri"
  - REMOTE SOURCES:
     - https://rubygems.org/
  - SHELL PATH:
     - /home/apollo/bin
     - /home/apollo/.local/bin
     - /usr/local/sbin
     - /usr/local/bin
     - /usr/sbin
     - /usr/bin
     - /sbin
     - /bin
     - /usr/games
     - /usr/local/games
     - /snap/bin
</tt>






## Deploy to RubyGems.org | Learn to Build, Install, Test and Release Gems

### ---> ### Check Option on Terminal Window

### ---> After rebooting - hit Windows button then type "ter" and enter to enter the terminal window.

### ---> - Click on Edit
### ---> - Click on Profile Preferences
### ---> - Change from "Unnamed" to "Default".
### ---> - Click on Command Tab
### ---> - Check the "Run Command as a Login Shell" box.




## Bundler | Documentation

The key bundler documentation can be found below.

http://bundler.io/docs.html
http://bundler.io/v1.16/man/bundle-package.1.html
http://bundler.io/v1.16/guides/creating_gem.html
http://bundler.io/v1.16/guides/deploying.html
http://bundler.io/v1.16/guides/git.html
http://bundler.io/v1.16/guides/using_bundler_in_applications.html


## Rake | Bundler | Gem Environment Tools

<tt>Rake</tt> is to **Ruby** like <tt>make</tt> is to **C** and <tt>Maven</tt> was to **Java**.

We must install bundler to aide in gem dependency management.

``` bash
gem install bundler
bundler --version
```

## Yard | Thor | Minitest | Gem Development Tools


For Ruby (DevOps) developers - the command line is the most important interface. Even more so than the Ruby on Rails UI.

Thor helps you create robust, intuitive, secure and well documented command line interfacees in an efficient manner. See also the Ruby Option Parser and Rake.


## Minitest | Ruby Test Framework

Next to documentation, ample test coverage is another quality indicator - if the code is documentated and then documented again with up-to-date and robust tests, that code is most probably easily extendible.

We could choose RSpec, Cucumber or even Aruba that tests any command line interface, be it backed by Ruby, Python, Perl, C, Java, Bash, indeed any of the usual suspects.

We choose <tt>Minitest</tt> because it is simple, lightweight and good enough.

``` bash
gem install minitest
```

## rake test | Run Tests with Rake

#### Once minitest is installed you can add this snippet to your rakefile.

Files ending with **_test.rb** are deemed test files as per the final test_files assignment in the Rake::TestTask block.

``` ruby
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :default => :test
```

Now we have a new command in our "integration" sequence.

``` bash
rake build
rake test
rake yard
rake install
rake release
```



## Thor | Ruby Command Line Parser

There are 3 ways to parse the command line in Ruby to provide error messages, help and finally information or a state changing action.

- the ARGV array to manually examine command options and switches
- OptionParser (robust though rather verbose and hard to learn)
- Thor - the best of breed object oriented command line parser

Thor helps you create robust, intuitive, secure and well documented command line interfacees in an efficient manner.

True to its "scripting language" designation, Ruby is not short of command line parsers. However look no further than the above three. Use ARGV directly for very simple CLIs. Visit our OptionParser documentation to see if you like it. Otherwise Thor should be your tool of choice.

``` bash
gem install thor
```




## Name your Gem | Search for Unused Name

If **s3upload** sounds awesome for your great new **upload to S3** gem then

``` bash
gem search ^s3
gem search ^s3up
gem search ^s3uploads
```
with the above searches you discover which names have already been taken.

opensecret stashes uncrackable secrets into your Git, S3, DropBox, Google Drive and filesystems backends. You interface with its intuitive Linux, Windows, iOS front ends and it offers SDKs and plugins for Ruby, Python, Java, Jenkins, CodeShip, Ansible, Terraform, Puppet and Chef.

Something utterly simple and utterly secure.

The name **opensecret** (ops) comes to mind.



## Use Bundler to Install Gem Template

Bundler is great at creating the **skeleton** of our gem. It even makes it a git project by doing a git init for us.

``` bash
bundle gem opensecret
```

It asks some questions (say y for yes) and then creates the necessary and needful.

> create  opensecret/Gemfile
> create  opensecret/lib/opensecret.rb
> create  opensecret/lib/opensecret/version.rb
> create  opensecret/opensecret.gemspec
> create  opensecret/Rakefile
> create  opensecret/README.md
> create  opensecret/bin/console
> create  opensecret/bin/setup
> create  opensecret/.gitignore
> create  opensecret/.travis.yml
> create  opensecret/test/test_helper.rb
> create  opensecret/test/opensecret_test.rb
> create  opensecret/LICENSE.txt
> create  opensecret/CODE_OF_CONDUCT.md

Initializing git repo in /home/apollo/mirror.gem1/opensecret

## Edit Gem Project's Semantic Version

First find the &lt;&lt;gem-name&gt;&gt;/lib/&lt;&lt;gem-name&gt;&gt;/version.rb and set your version.

## Edit GemSpec Configuration

Now visit the &lt;&lt;gem-name&gt;&gt;.gemspec file and change five key values.

- authors
- email address
- website homepage
- summary and
- description



## Create rubygems account

Create account by signing up.

CLICK on the email that comes otherwise access denied will ensue.


## rake install | without sudo

``` bash
rake install
```

You can expect these common errors if you haven't dealt with access to local gem storage.

<pre>
ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions for the /var/lib/gems/2.3.0 directory.

and

ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions for the /usr/local/bin directory.
</pre>

Without some intervention <tt>rake install</tt> will produce insufficient privilege errors. The usual suspects are

- <tt>/var/lib/gems/2.3.0/gems</tt> - every imported gem is put here
- <tt>/usr/local/bin</tt> - our very own dev gems are placed here

To fix the issue we change the ownership of the folders.

``` bash
sudo chown -R apollo:apollo /var/lib/gems/2.3.0
sudo chown -R apollo:apollo /usr/local/bin
```

Ensure now that installing gems is done **without sudo**. If sudo is added to a gem install the gems will come in owned as root and then failure almost certainly will occur somewhere down the line.


## rake install | command output

<code>
opensecret 0.0.1 built to pkg/opensecret-0.0.1.gem.
opensecret (0.0.1) installed.
</code>

Now "gem list" should show up.
and in the pkg directory there should be an opensecret-0.0.2.gem file.

git remote add origin https://www.eco-platform.co.uk/software/opensecret.git
git add .
git commit -am "OpenSecret initial checkin."

Do above after setting up git repo in github, gitlab, bitbucket.



Finally we do

rake release



Now enter email
enter password (setup at rubygems)

Signed in.
Pushing gem to https://rubygems.org...
Successfully registered gem: opensecret (0.0.1)


IMPORTANT - if login fails then DELETE the .gem/credentials file as it will just fail next time.

Once succeeds then the credentials is good.
Encrypt and lock it.
Deploy whenever you want to deploy a gem.
You will not have to type in password again.


Note that we ned to do a sudo (rake release) because the .gem/credentials file is most likely owned by root with only 600 permissions (read/write by root).



Most important Create/Publish RubyGem using RVM tutorial.
http://blog.thepete.net/blog/2010/11/20/creating-and-publishing-your-first-ruby/

Good rvm install blog => https://github.com/rvm/ubuntu_rvm
Install rvm blog      => https://rvm.io/rvm/install
Make Gem guide => http://guides.rubygems.org/make-your-own-gem/
Rails Cast on publishing your own gem => http://help.rubygems.org/kb/gemcutter/publishing-your-own-rubygem
publish gem - http://guides.rubygems.org/publishing/

3. Logout and login
A lot of changes were made (scripts that needs to be reloaded, you're now member of rvm group) and in order to properly get all them working, you need to login and logout. This requires not only close terminal, but really logout and login again.

4. Install a ruby
Now you're ready to install rubies. Open a terminal (Ctrl+Alt+T) and run:

rvm install ruby
RVM Usage
RVM complete instructions are available at RVM repository: https://github.com/rvm/rvm

Additionally you can check manual pages too: open a Terminal (Ctrl+Alt+T) and run:

