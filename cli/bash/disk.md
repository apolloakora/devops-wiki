
# Disk Usage Analysis | Ubuntu | Linux

The Disc Usage Analyzer on Ubuntu is simple with a small but excellent feature set.

Use the menu and type **`disk`** for the analyzer. The key features are

- a **ring chart** | click on big sections to go to the folder that is taking up that space
- a **treemap chart** | again click on big sections to go to the folder that is taking up that space
- **drillable tree folders** on the left for a more detailed view of directory and file disk usage
- a **left arrow** to to examine and select different **device volumes** and locations


## Bash Shell Disk Commands ~> du, df, swap, fdisk

## du | Disk Used Recursively including Hidden Directories

Due to a finickity bug **du -shc | sort -hr** can be **extremely misleading** because it **ignores directories beginning with a dot**. The summary figure can be a hundredth of the real size if you have large dot directories under your nose.

    du -shc .[!.]* * | sort -hr

Adding the <strong>.[!.]*</strong> clears up the problem giving you an accurate view.

It is worth your while to memorize the six extra **squeezed in** character sequence

- <em>dot</em>
- **open square bracket**
- <em>exclamation mark</em>
- **dot**
- <em>close square bracket</em>
- **asterix**

Now to confuse us follows a space and another asterix.

## du | Disk Used

The disk used command parameters are
- h ~> show human readable file sizes
- a ~> show all (include dot files/folders) and drill recursively
- s ~> summarize the results (excluding hidden dot files/folders)

We can combine the disk used, sort and grep commands to examine the disk usage for particular types of files or folders.

```bash
du -cah * | sort -hr | grep pdf   # find and list the sizes of all pdf files in the folder tree
du -cah * | sort -hr              # human readable (size) sorted list of every file and folder
du -shc * | sort -hr              # summarize but exclude all the hidden (dot files and folders)
```

## Common Disk Utilities

- run from terminal **`sudo cfdisk /dev/xxxx`**
- **`sudo parted -l`**
- **`sudo apt install pydf --assume-yes`**
- **`pydf`**
- **`sudo apt install hwinfo --assume-yes`**


## df | Disk Free

