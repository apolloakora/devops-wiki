
# RubyMine | Ruby's Integrated Development Environment (IDE)

RubyMine is the leading Ruby IDE from Jetbrains who also engineer IntelliJ IDE (the leading Java IDE) and PyCharm (a python IDE).

- **[RubyMine official documentation](https://www.jetbrains.com/help/ruby/get-started.html#)**


## How to Install Ruby Mine on a Mac

Go to the RubyMine downloads page and pull down a **.dmg** file then run it and add it to the Applications folder.

Then you can run it and open from a git repository like https://github.com/devops4me/safedb.net

## How to Install Ruby Mine in Ubuntu

Go to the [RubyMine Downloads Page](http://www.jetbrains.com/ruby/download/ "Download RubyMine Tar File") and choose the executable.

```bash
cd Downloads                             # CD to the Downloads folder
sudo tar xfz RubyMine-*.tar.gz -C /opt/  # Unpack RubyMine into /opt
ls -lah /opt
cd /opt/RubyMine-2018.2/bin
./rubymine.sh
```

When unpacked the opt folder should contain a file like **RubyMine-2018.2**. Go there to the binary folder and run the **rubymine.sh** script (without sudo).

Go through and answer the questions and then RubyMine starts.


## RubyMine Official Documentation

https://www.jetbrains.com/help/ruby/configuring-project-and-ide-settings.html

