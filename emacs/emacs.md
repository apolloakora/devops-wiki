
# Emacs | Operating Platform for IT Professionals

<img id="right30" src="/media/emacs-logo-square-2.png" title="GNU Emacs Logo" />
To get the most out of emacs - you must exploit its massive eco-system of tools and plugins. They can

- manage your gmail inbox
- give you a Ruby IDE
- interact with a Git VCS

and lots more. Your productivity starts to ramp up the as soon as you commit the basic text selection, text editing, folder navigation commands to memory.

Don't stop there - achieve crazy productivity by using the emacs family of tools when and where appropriate.

Tools such as IntelliJ, Eclipse and PyCharm allow you to opt for **emacs key mappings** - furthering your productivity even more.


## emacs | recursive find and replace

How do you find and replace a string across many files in a directory tree? How do you use a regular expression (regex) to match certain types of files?

- **<tt>alt-x find-name-dired</tt>** - enter the root folder and filename pattern eg **`*.rb`** or **`key-*.java`**
- **<tt>press t</tt>** to toggle mark all the files found and listed
- **<tt>press Q</tt>** to query replace in files and enter the query and replace strings
- **<tt>SPACE</tt>** replaces, **<tt>n</tt>** skips, **<tt>!</tt>** replaces all, **<tt>.</tt>** replace then stop, **<tt>Ctrl-g</tt>** to stop
- **<tt>press ctrl-x s</tt>** to save the buffers one by one - **<tt>!</tt>** saves them all


## emacs grep | recursive string search

To find a file containing a given string do <tt>alt-x grep</tt>.
Now amend the command by adding a r (recursive) and the string to match.

**`grep --color -rnH -e <STRING>`**

Then use <tt>n</tt> and <tt>p</tt> to navigate up and down the search results.


## How to Run Emacs in Terminal

To run emacs within the terminal window (if/when it starts to launch the GUI version) you use the -nw switch.

``` bash
emacs -nw
```

## Emacs Configuration Tweaks

Emacs has great defaults but there are still some settings to tweak like the **cursor color** and the annoying bell/beep. Add the below to the **`~/.emacs`** configuration file.

```lisp
; Set cursor color to white
(set-cursor-color "#ff4444")
; Disable the annoying beep / bell
(setq visible-bell t)
```

Then perform an **`alt-x load-file`** and enter the **`~/.emacs`** path.


## Remap (Launcher) Alt-Key in Ubuntu's Desktop for Emacs

If Ubuntu starts up the launcher when you press the ALT key in emacs - it pays to remap it. Note that this does not happen in Ubuntu 18.04 (Bionic Beaver) - but it does in 16.04 Ubuntu Client.

- click ***System Settings** (top right on/off switch)
- in ***Hardware*** tab choose ***keyboard***
- click the ***Shortcuts*** tab and ***Launchers***
- click on ***Key to Show the HUD***
- press the right ALT Gr button and is says ***Level3 Shift***

That's it - no more launcher activation when the ALT key is pressed,


---


## Launch Web Browser (like Firefox) from Emacs

You can visit a HTML file in an emacs buffer and then launch the page within the default web browser.

**Ctrl-c, Ctrl-v**


---


## How to go to the top and bottom of a file

The most common keyboard shortcuts for navigating to the extremeties are
- **`ESC Shift <`** - go to the beginning
- **`ESC Shift >`** - go to the end

However the ESC key can be a bit of a pain to hit espeically on MacBook's that relegate the escape key to tracker pad. It's a pain because you don't get the key press feedback so you must look at the keyboard to ensure you have hbit (or missed) it.

- **`Ctrl-u 1 Option-g-g`** - go to the top on a Mac keyboard
- **`Ctrl-u 1 Alt-g-g`** - go to the top on standard keyboards
- **`Ctrl-u 1000 Option-g-g`** - go to the bottom on a Mac keyboard
- **`Ctrl-u 1000 Alt-g-g`** - go to the bottom on standard keyboards

Yes the **`1000`** is a bit of a hack - it works for files with 10 or 20 or anything up to 1000 lines.

Also you may prefer these (very slightly shorter) key sequences

- **`Option-g-g 1 Enter`** - go to the top on a Mac keyboard
- **`Alt-g-g 1 Enter`** - go to the top on standard keyboards
- **`Option-g-g 1000 Enter`** - go to the bottom on a Mac keyboard
- **`Alt-g-g 1000 Enter`** - go to the bottom on standard keyboards


---


## Launch Firefox Bookmarks from Emacs

Viewing bookmarks as an HTML page is powerful as is viewing them as satellites within a devops wiki page.

In firefox **Ctrl-Shift-O** will bring up the bookmarks page. Use hotkeys to export the bookmarks as HTML. Then navigate using **emacs** to the bookmarks buffer and do **Ctrl-c, Ctrl-v** to launch them within a Firefox page.

## Disable Line Wrapping in Emacs Buffer

```
Alt-x toggle-truncate-lines
```
