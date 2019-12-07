
# bash commands | find | grep

**What one thing made the Unix command line great?**

Pipes | are the thing that put Unix head and shoulders above the competition. The ability to string commands together so that the output of one acts as the input to the other combines simplicity, elegance and power.

**`find`** and **`grep`** are the stand out performers amongst a gaggle of search commands.

## How to Search for Files Folders and Strings

We can combine the disk used, sort and grep commands to examine the disk usage for particular types of files or folders.

```bash
du -cah * | sort -hr | grep pdf   # find and list the sizes of all pdf files in the folder tree
du -cah * | sort -hr              # human readable (size) sorted list of every file and folder
du -shc * | sort -hr              # summarize but exclude all the hidden (dot files and folders)
```

## grep | for text in INI files and Ruby scripts

```bash
grep -Frn "plugin_symbol" * --include=*.ini --include=*.rb # search in INI and ruby scripts
grep -Frn "@[" ~/path/to/dir/* --exclude=*.txt      # find text containing "@["
```

## find (filter) files by path and content

This command finds files with **vpn** in (either) their path (or name) in which the text **staging** occurs.

```bash
sudo find . -path "*vpn*" -type f -exec grep -i "staging" {} +
```

## find emacs squiggle file

Need to scan a repo for those pesky but sometimes life-saving emacs squiggle files? Look no further.

```bash
find . -name "*.*~"             # find any type of squiggle file
find . -name "*.*~" 2>/dev/null # find squiggle files but ignore permission errors
find . -name "*.md~"            # squiggle markdown files
```

## find | find files and filter the results

Use **`find .`** to list every file in the current folder's subtree.

```bash
find .                          # list every file in folder's subtree
find . -type d                  # list every directory in subtree
find . | grep aws               # list files/folders containing aws
find . -name *.pdf 2>/dev/null  # skip the permission denied errors
find . -type d ! -path '*.git*' # ignore directories with .git in their path
```

### find | with options for negation, type, name and path

The find command has a few tricks up its sleeve. It can

```bash
find . -type d ! -path '*.git*' # exclude paths containing .git
find . -name "*.pem"            # search for name patterns
find . -type d -name "*.kube*"  # return folders ending with .kube
find . -type d -path "*.kube*"  # list folders with .kube incl the end
find . -type f -name "*.kube*"  # return files with .kube in the name
find . -type f -path "*.kube*"  # return files with .kube in the path
```

Note that **-path** covers the whole path from tip (at present folder or specified folder) to toe.
Contrast this with **-name** which only looks at the end file or folder name.

### find from somewhere else

Replace the dot and find from say **`~mirror.library`**

```bash
find ~/mirror.library -type f ! -name '*.md'
```

## Find Shell Command | find . -name *.pdf

The find command looks for files of a given ilk.

``` bash
find . -name "manifest.json"             # find from this folder a file called manifest.json
find . -name *.pdf | grep pycharm        # find a pdf file with pycharm in the name
find . -name *.pdf | grep -i pycharm     # find a pdf file with pycharm or PyCharm in the name
find . -name *.pdf                       # find (recursively) all pdf files from here on in
find . -name *.pdf 2>/dev/null           # ignore the error lines when printing the pdf files
find . -name *.pdf | wc -l               # count the number of pdf files from here on in
find . -name *.pdf 2>/dev/null | wc -l   # no error lines - I just want the PDF file count
find . -name *.pdf | grep -i python | wc -l  # count the pdf files with p(P)ython in the name
```

## double grep commands | match one not another

Find lines matching one string but excluding another string.

Note that **`grep "forthis" -v`** will find every line that does NOT include the string.

``` bash
grep -Frn "amazon.com" * | grep "Binary file" -v # match amazon.com but exclude "Binary file ... matches"
```


## grep | handy grep commands

find lines inn markdown files.

``` bash
grep -Frn "grep" * --include=*.md        # find lines in markdown files
```
