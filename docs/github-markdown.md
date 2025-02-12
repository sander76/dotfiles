# Github flavored markdown.

add WARNING / INFO / ALERT block

```
> [!NOTE]  
> Highlights information that users should take into account, even when skimming.

> [!IMPORTANT]  
> Crucial information necessary for users to succeed.

> [!WARNING]  
> Critical content demanding immediate user attention due to potential risks.
```


## remove accidentally tracked files.
1. Introduction

As we know, the .gitignore file prevents future untracked files from being added to the git index. In other words, any files that are currently tracked will still be tracked by git.

In this tutorial, we’ll explore different possibilities to remove tracked files from the git index after adding them to .gitignore.
2. Removing a Single File

In order to remove a single file, we first have to add the file name to .gitignore and then run the git rm command, followed by a commit:

git rm --cached <filename>
git commit -m "<Message>"

The first command removes the file from the index and stages the change, while the second command commits the change to the branch.
3. Removing a Folder

We can remove an entire folder by first adding the folder name to .gitignore and running the git commands:

git rm --cached -r <folder>
git commit -m "<Message>"

Notice the -r addition to the command, as without it, the command will fail with:

fatal: not removing 'folder' recursively without -r.

4. Removing All Ignored Files

Here, we’re removing all files that are currently being ignored in .gitignore:

git rm -r --cached .
git add .
git commit -m "Removes all .gitignore files and folders"

The first command removes all the files from the index. The second command re-adds all the files without those in .gitignore, and the last command commits the change. After these three commands, all the files from .gitignore will be removed from the index.
