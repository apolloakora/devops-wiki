
## Yard | Ruby Documentation Build and Serve

Yard generates professional (javadoc style) web documentation by parsing your Ruby software. If you publish to RubyGems.org, Yard makes the documentation publicly available.

``` bash
gem install yard
yard config --gem-install-yri
yard --version
```

The above configures yard to watch for gem installs and update our local <tt>gemset</tt> documentation.

## Gem Documentation (vs) Gem Popularity

Great documentation is a key factor in the decision to try out a gem. If the gem has had a few releases, a handful of contributors and it purports to solve their problem, users check the code documentation.

**On finding documentation that is neither trivial nor pithy, they install your gem and give it a whirl.**

Documentation is extremely important in acquiring trust, because it implies extendibility.

## Yard Docs Web Server | Read Gem Docs

Run the gem documentation server locally. We can then browse the documentation for each installed gem.

``` bash
yard server --gems
```

## Yard Commands | Gem Project

Go to the root folder of your gem. Use these commands to access various aspects of your **gem's documentation**.

- <tt>yard list</tt> &raquo; list all modules, classes, methods and attributes
- <tt>yard stats</tt> &raquo; report the count of un-documented meta objects
- <tt>yard display CommandProcessor</tt> &raquo; show class/method ... documentation
- <tt>yard </tt> &raquo;
- <tt>yard </tt> &raquo;
- <tt>yard server --gems</tt> &raquo; startup the local ruby WEBrick server


## rake yard | Create Documentation with Yard

``` bash
yard server --gems
```

#### Once yard has been installed you can add this snippet to your rakefile.

``` ruby
require 'yard'
# -
# - This configuration allows us to run "rake yard"
# - to build documentation.
# -
YARD::Rake::YardocTask.new do |t|
 t.files   = ['lib/**/*.rb']   # optional
 t.stats_options = ['--list-undoc']
end
```

## rake yard | Stats and Undocumented List

The option --list-undoc will list the files (modules/classes) that lack documentation. Stats like
the below will be printed regardless.

```
Files:          25
Modules:         2 (    1 undocumented)
Classes:        24 (    2 undocumented)
Constants:       1 (    1 undocumented)
Attributes:     12 (    0 undocumented)
Methods:       160 (   15 undocumented)
 90.45% documented
```

Now we have a new command for creating browsable documentation in our "integration" sequence.


## Yard Configuration on your DevOps workstation

The points of note for your workstation's yard configuration are that

- the <tt>yard config --gem-install-yri</tt> creates docs when gems are installed
- the url http://localhost:8808/ can be used to read the gem yard (and rdoc) docs
- the line <tt>spec.metadata["yard.run"] = "yri"</tt> should be added to gemspecs

Adding the metadata["yard.run"] to your gemspec and running <tt>yard config --gem-install-yri</tt> means that

- every <tt>gem install</tt> will update your local yard documentation
- every <tt>rake install</tt> will use yard (instead of rdoc) for building local docs
- every <tt>rake release</tt> will push yard created documentation to <tt>rubygems.org</tt>


### Install a Gem and See

Now check by installing a gem (for example Thor). Suddenly you have this new line saying <tt>Building YARD (yri) index for thor-0.20.0...</tt>

<pre>
Fetching: thor-0.20.0.gem (100%)
Successfully installed thor-0.20.0
Building YARD (yri) index for thor-0.20.0...
</pre>
