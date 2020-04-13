
# Mac Keyboard Shortcuts

## Mac App Switching with Command Tab

Minimized applications do not switch nicely with Command Tab. The icons are visible but on release the window is not opened. The only way to un-minimize an app is with a mouse click.

The two solutions are
- **`killall Dock`** # perform this on the command line (terminal or emacs)
- use the mouse to un-minimize the app first

## Home | End | Moving Around with Home and End

Where is the Home key on the Mac - and where is our beloved Delete key that can remove text backwards?

- Home key is **`Fn Left Arrow`**
- End key is **`Fn Right Arrow`**

Not on **emacs** but on other text areas like Outlook and TextEdit you can move around using

- **`Home`** scroll window to the top (without changing the keyboard focus)
- **`End`** scroll window to the bottom (without changing the keyboard focus)
- **`Command Up Arrow`** moves the insertion point to the beginning of the document
- **`Command Down Arrow`** moves the insertion point to the end of the document
- **`Command Left/Right Arrow`** moves to the beginning or end of the line
- **`Option Left/Right Arrow`** moves forward or backword by words
- **`Option Up/Down Arrow`** jumps upwards and downwards by paragraph

To select text whilst moving you hold the shift key.


## How to Quit the Finder

You can quit the Finder and add the quit option to the Finder menu with this terminal command.

``` zsh
defaults write com.apple.finder QuitMenuItem -bool true
killall Finder
```


## Firefox Keyboard Shortcuts on Mac

- back and forward with **Delete** and **Shift-Delete**
- reload with **Command-r** and **Command-Shift-R**
- move down and up | Fn and UP/Down Arrows | SpaceBar and Shift-SpaceBar
- Close Tab Command - w
- Close Window - Command Shift W
- Quit Entirely - Command Q
- Undo Close Tab - Command Shift T
- Undo Close Window - Command Shift N
- History Sidebar - Command Shift H
- Bookmark this page - Command dD
- Bookmark ALL Open Tabs - Command Shift D
