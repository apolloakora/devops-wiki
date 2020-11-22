
# Emacs Keymap Keyboard Shortcuts for IntelliJ PyCharm and RubyMine

These keyboard shortcuts are for the Emacs keymap in IntelliJ, PyCharm and RubyMine. They come out-of-the-box so you don't need to do any custom key bindings. It is sad that the keyboard shortcuts PDF from the IntelliJ IDE are incorrect when you opt for the Emacs keymap.

Thankfully the shortcuts below are all tested and verified to work with all the aforementioned IDEs.

## Editing (Cutting) Code

These settings will work on Windows, Linux and MacOS as long as you set the Keymap to Emacs (**`Command ,`** or **`Ctrl ,`**).

| Capability              | Keyboard Shortcut               | And then ...                                   |
|:----------------------- |:------------------------------- |:---------------------------------------------- |
| Wrap with Block Comment | **`Ctrl Shift /`**              | select the block again and **`Ctrl Shift /`** to uncomment |
| Line by Line Comments   | **`Option ;`**                  | select the block again and **`Option ;`** to uncomment |
| Auto-Indent Code Block  | **`Ctrl Option q`**             | |
| Move Line Up            | **`Option Shift (Up)`**         | |
| Move Line Down          | **`Option Shift (Down)`**       | |
| Move Method Vars Left   | **`Ctrl Option Shift (Left)`**  | |
| Move Method Vars Right  | **`Ctrl Option Shift (Right)`** | |
| Run Tests or App        | **`Ctrl Shift F10`**            | |
| Organize Imports        | **`Ctrl Option o`**             | |
| Undo the last action    | **`Ctrl Shift - (hyphen)`**     | |
| Fold Up a Code Block    | **`Ctrl - (hyphen)`**           | |
| Unfold a Code Block     | **`Ctrl = (equals)`**           | |
| Duplicate Current Line  | **`Command d`**                 | |
| Refactor Create Method  | **`Ctrl Option m`**             | select code block then enter method name and Enter|
| Deleting (Project View) | **`fn Backspace`**              | Enter at the prompt to actually delete (or tap the touch bar) |
| Text Upper / Lowercase  | **`Ctrl Shift U`**              | select first with **`Ctrl Space`** then **`Ctrl n`** |
| Refactor Rename         | **`Shift F6`**                  | rename and **`Ctrl Option d`** to Do the Refactoring |
| Complete Code Element   | **`Option / Enter`**            | **`Ctrl n (or p) Enter`** to navigate and select option |
| Overwrite Code Element  | **`Option / Tab`**              | **`Ctrl n (or p) Enter`** to navigate and select option |
| Find and Replace Text   | **`Ctrl Shift R`**              | |


---


## Reading and Exploring Code


| Read Explore Activity            | Keyboard Shortcut                 | And then ...                   |
|:-------------------------------- |:---------------------------------- |:------------------------------ |
| Jump to the Last Edit Location   | **`Ctrl Shift Backspace`**         | **`Ctrl Shift E`** or **`Ctrl Option Arrow`** to return |
| Jump to Previous/Next Location   | **`Ctrl Option Left/Right Arrow`** | Visit recent locations with **`Ctrl Shift E`** |
| Open Recent Locations Dropdown   | **`Ctrl Shift E`**                 | **`Ctrl Option Left/Right Arrow`** to jump again |
| Find usages of a code element    | **`Ctrl Option g`** (in IntelliJ)  | **`Ctrl-n`** to move down, Enter to visit |
| Navigate to element definition   | **`Ctrl Option g`** (in RubyMine)  | to go back press **`Ctrl Option Left Arrow`** |
| Navigate to element definition   | **`Option . (period)`**            | to go back press **`Ctrl Option Left Arrow`** |
| Find usages tab                  | **`Option Shift S`**               | use Ctrl-n to move down, Enter to jump to editor, Ctrl-x k to close |
| Show File Details (Project View) | **`Option Shift |`**               | read file size and date/time created and viewed |
| Goto line (go to line)           | **`Option g`**                     | type 14:8 to go to line 14 column 8 (or just 14) |
| Goto the next method             | **`Ctrl Option e`**                |  |
| Goto the previous method         | **`Ctrl Option a`**                |  |
| View Class Elements Structure    | **`Ctrl F12`**                     | use Ctrl-n and p to move up and down and enter to visit |
| View Class Method Documentation  | **`Ctrl q`**                       | read documentation and scroll with arrow keys |
| Options (Project View)           | **`Ctrl Option Enter`**            | Ctrl-n to move, Enter to Open or select, esc esc to jump to editor, Ctrl-x k (or Option 1 again) to close  |
| View Gem Dependency Diagram      | **`Ctrl Option u`** (RubyMine)     |  |
| Jump to the first line (top)     | **`Option Shift <`**               |  |
| Jump to the last line (bottom)   | **`Option Shift >`**               |  |
| Find Method or Class            | **`Ctrl Shift Option N`**         | |
| Find Text in any File           | **`Ctrl Shift F`**                | **`Ctrl n`** and **`Ctrl p`** to select and **`Enter`** to visit |
| Goto any class in the editor    | **`Option Shift G`**              | |
| Find any file, class or package | **`Shift Shift`**                 | |


---


## Find Search and Replace | Files, Occurrences and Usages

Finding files, finding text, finding usage of a particular class, method or variable and perhaps replacing are all key parts of any IDE's productivity offering. IntelliJ is no different and these shortcut keys make you even faster.

| Find Search Replace                   | Mac Keyboard                      | And then ...   |
|:------------------------------------- |:--------------------------------- |:-------------- |
| Find Method or Class                  | **`Ctrl Shift Option N`**         | |
| Find (Highlight) Text in Current File | **`Ctrl s`**                      | repeat **`Ctrl s`** for next, **`Ctrl r`** for previous and **`Ctrl g Ctrl g`** to stop |
| Find Text in any File                 | **`Ctrl Shift F`**                | **`Ctrl n`** and **`Ctrl p`** to select and **`Enter`** to visit |
| Find and Replace Text in path         | **`Ctrl Shift R`**                | |
| Goto any class in the editor          | **`Option Shift G`**              | |
| Find any file, class or package       | **`Shift Shift`**                 | |
| Find usages tab                       | **`Option Shift S`**              | |
| Navigate to element definition        | **`Ctrl Option g`** (in RubyMine) | |
| In projects search within names       | **`Option 9`** then type          | |
| In console search log output          | **`Option 4`** then **`Ctrl s`** then type. **`Ctrl s`** next and **`Option r`** previous and **`esc esc`** to jump out. | |


---


## Navigate to Tool Windows (incl Settings)

| Perspective                  | Mac Keyboard Shortcut            | And then ...                                |
|:---------------------------- |:-------------------------------- |:------------------------------------------- |
| Goto Projects Tool Window    | **`F12`**                        | use **`Shift F12`** to invoke editor fullscreen |
| Jump from Projects to Editor | **`Shift F12`** or **`Esc Esc`** | use **`F12`** to go back to the Projects tool window |
| Goto Terminal                | **`Option F12`**                 | use **`Option F12`** again or **`Esc Esc`** to go back to the Editor |
| Open Settings Window         | **`Command , (Comma)`**          |   |
| Project Hierarchy            | **`Option 1`**                   | Ctrl-n to move, Enter to Open or select, esc esc to jump to editor, Ctrl-x k (or Option 1 again) to close  |
| Class Hierarchy              | **`Ctrl h`**                     | Ctrl-x k to close and return  |
| View @todo locations         | **`Option 6`**                   | Ctrl-n to move, Enter to Open or Select, esc esc to jump to editor, Ctrl-x k (or Option 6 again) to close  |
| Console (Run) and Logs       | **`Option 4`**                   |   |
| Class/Method Structure       | **`Option 7`**                   | Ctrl-n to move, Enter to Open or Select, esc esc to jump to editor, Ctrl-x k (or Option 7 again) to close  |
| Git Version Control          | **`Option 9`**                   |   |


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
- either **`Ctrl Option k`** or **`Option Shift Enter Enter`** - to commit and goto listing of commits to be pushed
- **`Ctrl Option p`** - to push the list of commits

### How to just Commit (without pushing)

If you want to just commit and then push a bunch of them later you

- **`Option 9`** - to go to the VCS context
- **`Ctrl k`** - to open the commit and push context
- **`Shift Tab Tab Enter`** - performs the commit and returns to the VCS tab
- **`Ctrl-x k`** to return to the editor tab

### How to Pull from a Branch (like Master)

To pull from any remote branch (including master) you

- **`Ctrl Shift Backtick`** for the branches popup
- **`Ctrl n`** and **`Ctrl p`** to navigate do the remote branch to pull from
- **`Ctrl f`** or **`Enter`** then **`Ctrl n`** to move to option
- Hit **`Enter`** to **`Merge into Current`**

You can back out with a **`Ctrl b`** after a **`Ctrl f`** (forward). Also to see what's coming down the tracks select **`Compare with Current`**

### How to Push without Committing

When you've done a bunch of commits already you may want to push one some or all of them without having to go down the commit route. To do this

- **`Ctrl shift k`** - opens the push window (no need to do Option 9)
- **`Ctrl option p`** - pushes the selected commits and returns you

Note that even from the VCS tab (arrived at by **`Option 9`**) you can still use **`Ctrl shift k`** to open the push window.

### How to Add a File or Folder to Git

To add an untracked file or folder use **`Option 9`** to go to the local changes and then

- **`Ctrl n`** and **`Ctrl p`** to navigate to what you need to add
- **`Ctrl Option a`** to add it
- **`Ctrl k`** then enter a commit message
- **`Ctrl Option k`** to Commit and **`Ctrl Option p`** to push


### How to Create a Branch

To create a branch within the IDE you

- **`Ctrl Shift Backtick`** to awaken the branches popup
- opt to create a branch, type in the branch name and Enter
- **`Ctrl Shift k`** then **`Ctrl Option p`** to push it up

### How to Merge a Branch into Master

Although you can merge through Github/Gitlab user interfaces it is better to merge locally so that you can run tests against the merged code and fix any conflicts, that may be lurking.

To merge within the IDE

- do a git pull from both the master and current branch (teammates may have done a cheeky push in-between)
- **`Ctrl Shift Backtick`** to awaken the branches popup
- **`Ctrl n`** and **`Ctrl p`** to move to master
- hit Enter then select **`Checkout`**
- **`Ctrl Shift Backtick`** again but now goto local branch and select **`Merge into Current`**
- fix conflicts and run the tests against the new branch
- if conflict free no commits are needed - just pushing the list of merged commits
- **`Ctrl Shift k`** then **`Ctrl Option p`** to push

### Other Useful Version Control Shortcuts

Whilst in version control mode **`Option 9`** you can

- **`Ctrl-x k`** to close the Version Control tab (perspective)
- **`Option Left Arrow`** - to visit the console to see the IDE's actual git command


---


## Run Code | Run Tests | Run Rake Tasks | Run Gem Install | Running Maven Goals | Run Configurations

You can execute unit tests (in Cucumber, Behave, Minitest) and you can execute code using interpreters (for Ruby and Python) and much more.

| Running Capabilities             | Keyboard Shortcut                      | And then ...                            |
|:-------------------------------- |:-------------------------------------- |:--------------------------------------- |
| Run a Rake task                  | **`Ctrl Ctrl`**                        | "rake build" or "rake install"          |
| Run Recently ran again           | **`Ctrl Ctrl`**                        | **`Ctrl n`** or **`Ctrl p`** then Ent
er |
| Running a Class (Code or Test)   | **`Ctrl Shift F10`**                   | b4 - go to class with **`Option 1`**    |


---


## Navigating the Editor Tabs

| Capability             | Keyboard Shortcut                  | Worth noting that            |
|:---------------------- |:---------------------------------- |:---------------------------- |
| Kill Editor Tab        | **`Ctrl x k`**                     |  |
| Kill All Editor Tabs   | **`Ctrl x c`**                     | **`Ctrl x b`** will list all tabs that were open |
| Switch Editor Tabs (1) | **`Ctrl x p (n)`**                 | Use when there aren't many tabs |
| Switch Editor Tabs (2) | **`Option Left(Right) Arrow`**     | Use to cycle through every tab  |
| Switch Editor Tabs (3) | **`Ctrl-x b`** Ctrl-n Enter        | Use when many tabs and you know which one you want |
| Goto last edited tab   | **`Ctrl Shift Backspace`**         | **`Ctrl Shift E`** or **`Ctrl Option Arrow`** to return |
| Goto to prev/next tab  | **`Ctrl Option Left/Right Arrow`** | Visit recent locations with **`Ctrl Shift E`** |
| Open Recent Locations  | **`Ctrl Shift E`**                 | **`Ctrl Option Left/Right Arrow`** to jump again |



---


## Working in the Terminal Window

| Capability             | Keyboard Shortcut                  | Worth noting that            |
|:---------------------- |:---------------------------------- |:---------------------------- |
| Grab previous command  | **`Ctrl p`**                       |  |


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

