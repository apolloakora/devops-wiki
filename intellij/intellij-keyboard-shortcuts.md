
# IntelliJ, PyCharm and RubyMine EMacs Keyboard Shortcuts

## Editing (Cutting) Code

These settings will work on Windows, Linux and MacOS as long as you set the Keymap to Emacs (**`Command ,`** or **`Ctrl ,`**).

| Capability             | Keyboard Shortcut               | And then ...                                   |
|:---------------------- |:------------------------------- |:---------------------------------------------- |
| (Un)Comment Code Block | **`Ctrl Shift /`**              | |
| (Un)Comment Code Lines | **`Option Semicolon`**          | |
| Auto-Indent Code Block | **`Ctrl Option q`**             | |
| Move Line Up           | **`Option Shift (Up)`**         | |
| Move Line Down         | **`Option Shift (Down)`**       | |
| Move Method Vars Left  | **`Ctrl Option Shift (Left)`**  | |
| Move Method Vars Right | **`Ctrl Option Shift (Right)`** | |
| Run Tests or App       | **`Ctrl Shift F10`**            | |
| Organize Imports       | **`Ctrl Option o`**             | |
| Undo the last action   | **`Ctrl Shift - (hyphen)`**     | |
| Fold Up a Code Block   | **`Ctrl - (hyphen)`**           | |
| Unfold a Code Block    | **`Ctrl = (equals)`**           | |
| Duplicate Current Line | **`Command d`**                 | |
| Refactor Create Method | **`Ctrl Option m`**             | select code block then enter method name and Enter|


---


## Reading and Exploring the Code


| Exploring and Cutting Code      | Mac Keyboard                      | And then ...                   |
|:------------------------------- |:--------------------------------- |:------------------------------ |
| Find usages of a code element   | **`Ctrl Option g`** (in IntelliJ) | **`Ctrl-n`** to move down, Enter to visit |
| Navigate to element definition  | **`Ctrl Option g`** (in RubyMine) | to go back press |
| Find usages tab                 | **`Option Shift S`**              | use Ctrl-n to move down, Enter to jump to editor, Ctrl-x k to close |
| When was file read/changed      | **`Option Shift \`**              | read info from project window (includes size) - repeat to switch off |
| Goto the next method            | **`Ctrl Option e`**               |  |
| Goto the previous method        | **`Ctrl Option a`**               |  |
| View Class Elements Structure   | **`Ctrl Fn F12`**                 | use Ctrl-n and p to move up and down and enter to visit |
| View Class Method Documentation | **`Ctrl q`**                      | read documentation and scroll with arrow keys |


---


## Find Search and Replace | Files, Occurrences and Usages

Finding files, finding text, finding usage of a particular class, method or variable and perhaps replacing are all key parts of any IDE's productivity offering. IntelliJ is no different and these shortcut keys make you even faster.

| Find Search Replace             | Mac Keyboard                   |
|:------------------------------- |:------------------------------ |
| Goto any class in the editor    | **`Option Shift G`**           |
| Find any file, class or package | **`Shift Shift`**              |
| Find a String Globally          | **`Ctrl Shift f`**             |
| In projects search within names | **`Option 9`** then type       |
| In console search log output    | **`Option 4`** then **`Ctrl s`** then type. **`Ctrl s`** next and **`Option r`** previous and **`esc esc`** to jump out. |


---


## Navigating to Tools Views and Settings

| Perspective             | Mac Keyboard Shortcut          | And then ...        |
|:----------------------- |:------------------------------ |:------------------- |
| Open Settings Window    | **`Command , (Comma)`**        |   |
| Project Hierarchy       | **`Option 1`**                 | Ctrl-n to move, Enter to Open or select, esc esc to jump to editor, Ctrl-x k (or Option 1 again) to close  |
| Class Hierarchy         | **`Ctrl h`**                   | Ctrl-x k to close and return  |
| View @todo locations    | **`Option 6`**                 | Ctrl-n to move, Enter to Open or Select, esc esc to jump to editor, Ctrl-x k (or Option 6 again) to close  |
| Console (Run) and Logs  | **`Option 4`**                 |   |
| Class/Method Structure  | **`Option 7`**                 | Ctrl-n to move, Enter to Open or Select, esc esc to jump to editor, Ctrl-x k (or Option 7 again) to close  |
| Git Version Control     | **`Option 9`**                 |   |


---


## Switch Themes | Switch View Mode | Switch Key Mappings

There's something cool about switching - be it **switching lanes** or **switching up the program**. You can switch up themes, view modes, keymaps and more with **`Ctrl backtick`**. Try
- **`Ctrl backtick`** to access the switcher
- **`Ctrl-n**` and **`Ctrl-p`** (or type the number) to move up and down
- and then **`Enter`** to switch

### Swithcing Keymaps

When pair-programming and your other half isn't an emacs fan you can quickly use the sequence

- **`Ctrl Backtick 3 1`** - to switch to the MacOS keymap
- **`Ctrl Backtick 3 4`** - to switch back to an emacs keymap


---


## Git Version Control Shortcuts

**`Option 9`** is the gateway to the version control perspective. From this context these keyboard shortcuts become available.

### How to Commit and Push

The fastest shortcuts to commiting and pushing to the current branch is as follows.

- **`Option 9`** - to go to the VCS context
- **`Ctrl k`** - to open the commit and push context
- then type the commit message
- either **`Ctrl Option k`** or **`Option Shift Enter Enter`** - to commit and goto lising of commits to be pushed
- **`Ctrl Option p`** - to push the list of commits

### How to just Commit (without pushing)

If you want to just commit and then push a bunch of them later you

- **`Option 9`** - to go to the VCS context
- **`Ctrl k`** - to open the commit and push context
- **`Shift Tab Tab Enter`** - performs the commit and returns to the VCS tab
- **`Ctrl-x k`** to return to the editor tab

### How to Push without Committing

When you've done a bunch of commits already you may want to push one some or all of them without having to go down the commit route. To do this

- **`Ctrl shift k`** - opens the push window (no need to do Option 9)
- **`Ctrl option p`** - pushes the selected commits and returns you

Note that even from the VCS tab (arrived at by **`Option 9`**) you can still use **`Ctrl shift k`** to open the push window.

### Other Useful Version Control Shortcuts

Whilst in version control mode **`Option 9`** you can

- **`Ctrl-x k`** to close the Version Control tab (perspective)
- **`Option Left Arrow`** - to visit the console to see the IDE's actual git command



---


## Navigating the Editor Tabs

| Capability             | Mac Keyboard                    | Worth noting that
|:---------------------- |:------------------------------- |:---------------------------- |
| Kill Editor Tab        | **`Ctrl x k`**                  |  |
| Switch Editor Tabs (1) | **`Ctrl x p (n)`**              | Use when there aren't many tabs |
| Switch Editor Tabs (2) | **`Option Left(Right) Arrow`**  | Use to cycle through every tab  |
| Switch Editor Tabs (3) | **`Ctrl-x b`** Ctrl-n Enter     | Use when many tabs and you know which one you want |
| Kill Editor Tab        | **`Ctrl x k`**                  | **`Ctrl x k`**               | Editor Tabs    |


---
## Opening and Closing Projects and the IDE


| Capability               | Mac Keyboard                 | What?          |
|:------------------------ |:---------------------------- |:-------------- |
| Close the Project Window | **`Command q`**              | IDE Projects   |
|                          | **`xxx`**                    | IDE Projects   |

It is a shame that switching between IDE projects does not have a keyboard shortcut. On Mac you can switch by left clicking the icon in the Dock. If you have more than 2 projects open you can right click and then select the one you want.

---


## Surrounding Code Blocks With ...

You can surround a code block with try/catch, if/else and other wrapping behaviour using **`Ctrl Option t`** and then a character.

### Ctrl Option t

| Char   | Surrounds with       | Mac Keyboard                | Ordinary Keyboard           | Activity |
|:------ |:-------------------- |:--------------------------- |:--------------------------- |:-------- |
|   1    | if statement         | **`Ctrl Option t 1`**       | **`Ctrl Alt t 1`**          | Editing Code   |
|   2    | if/else statement    | **`Ctrl Option t 2`**       | **`Ctrl Alt t 2`**          | Editing Code   |
|   3    | while statement      | **`Ctrl Option t 3`**       | **`Ctrl Alt t 3`**          | Editing Code   |
|   4    | do/while statement   | **`Ctrl Option t 4`**       | **`Ctrl Alt t 4`**          | Editing Code   |
|   5    | for statement        | **`Ctrl Option t 5`**       | **`Ctrl Alt t 5`**          | Editing Code   |
|   6    | try catch statement  | **`Ctrl Option t 6`**       | **`Ctrl Alt t 6`**          | Editing Code   |
|   7    | try finally          | **`Ctrl Option t 7`**       | **`Ctrl Alt t 7`**          | Editing Code   |
|   8    | try catch finally    | **`Ctrl Option t 8`**       | **`Ctrl Alt t 8`**          | Editing Code   |

