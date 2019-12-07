
# Emacs Dired Mode

*Dired* stands for **Directory Editor** and the dired buffer lists the folder's child files (and child folders.

## Dired Mode | Why Omit Dot Prefixed Content

Your **productivity rises when you omit** files and folders whose names begin with a period (dot). These items are not for everyday consumption and looking through a long list of dot prefixed files, slows you down.


## Dired Mode | Omit Dot Prefixed Content

<img id="right30" src="/media/emacs-logo-square.png" title="GNU Emacs Logo" />
The simplest way to omit these files and folders in every ***Dired buffer*** is to add some directives into the .emas file that lives off your home directory.

Don't worry if no .emacs file exists - just create it.

Now add (or append) these directives into ***<code>.emacs</code>***.

<pre>
   (require 'dired-x)
    (setq-default dired-omit-files-p t) ; Buffer-local variable
    (setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
</pre>

Then restart emacs and you'll see the effect.


## Dired Mode | Omit Squiggle Terminated Files

The above omit mode also hides files with a trailing squiggle - these are the ubiquitous emacs backup files.

If checking content into Git - you can either ***.gitignore*** the squiggle files or tell emacs not to create them in the first place ***(I'm a big boy (or girl) - I know what I'm doing)***.

<!-- facts
authority = dired mode
neglect = emacs
-->
