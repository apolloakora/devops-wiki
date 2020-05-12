
# Emacs on the MacBook with Zsh

## Initializing Emacs | `.emacs`

To map the hash key correctly on emacs (from the terminal and perhaps from the Application too) we need to add a binding to the .emacs file.

**Create a ~/.emacs file if it does not exist and place the below into it.**

Some things are best done in the .emacs file. Here we

- get emacs to respect Alt-3 as the hash symbol
- disable command echoing in the shell

```
;; Get emacs to respect Alt-3 as hash on the Mac.
(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))

;; Disable echoing of commands in the emacs shell
(defun my-comint-init ()
           (setq comint-process-echoes t))
(add-hook 'comint-mode-hook 'my-comint-init)
```

Emacs configuration on the mac with the z shell is different in some ways to something like Ubuntu running bash.

## Emacs Disk Permissions

Rumour has it that emacs is actually instantiated by a Ruby script and so adopts the base permissions given to Ruby. To resolve the many issues of emacs not being able to access parts of the disk simply do

- System Preferences
- search for **`Privacy Settings`**
- on the left scroll to **`Full Disk Access`**
- click to Unlock and enter the sudo password
- click the + (plus) to Add
- go to **`/usr/bin/ruby`** and click Open
- make sure the Terminal and sh have full disk access too

Now your emacs permission issues are resolved.


## Making emacs fullscreen

Use alt-x toggle-frame-fullscreen to move emacs in and out of full screen mode on the mac.


---


## Copy and Paste from Terminal Shell

In the unfortunate circumstance where you have to ssh into a remote computer - you install emacs and then you need to use terminal emacs - how do you copy from it and paste into the terminal emacs on a Mac.

You don't use the Ctrl-Shift-C nor the Ctrl-Shift-V

### Copy from Terminal Emacs

To copy you select with the mouse and then do command-c
Now you can paste elsewhere including Ctrl-y in a proper emacs window.


### Paste into Terminal Emacs

To paste you simply use command-v
This drops in text for example previously copied with Option-w from a proper emacs window.


---


## Where is the History

Instead of .bash_history the z shell uses the .zsh_history file.

## Emacs Path not Correct

On the MAC the path is not set accurately at startup. I find that only /usr/local/bin is missing from the path. To fix this create and/or append to the **`~/.zshrc`** file.

### Use .zshrc to Run Commands when Shells Start

``` sh
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Emacs.app/Contents/MacOS/bin-x86_64-10_14:/Applications/Emacs.app/Contents/MacOS/libexec-x86_64-10_14:/usr/local/bin
export SAFE_TTY_TOKEN=`safe token`
```

Note that /usr/local/bin has been tagged on at the end of the path. Also we are running a command installed at the new path.
