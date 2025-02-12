# remove local branches which are no longer on remote.

https://stackoverflow.com/a/47939403/1629704

- git fetch --prune (or git fetch -p, which is an alias, or git prune remote origin which does the same thing without fetching, and is probably not what you want most of the time).
- Note any remote branches that are reported as deleted. Or, to find them later on, git branch -v (any orphaned tracking branch will be marked "[gone]").
- git branch -d [branch_name] on each orphaned tracking branch

https://stackoverflow.com/questions/17983068/delete-local-git-branches-after-deleting-them-on-the-remote-repo


## remove tracked files

```
git rm --cached <filename>
git commit -m "<Message>"
```

more info: https://www.baeldung.com/ops/git-remove-tracked-files-gitignore


## change parent branch

```
git rebase --onto master feature-branch
                     |       |
                     |        --> old-parent
                     --> new-parent
```

from:

```
A---B---C---D  master
            \
              E---F---G  feature-branch
                      \
                        H---I---J current-feature-branch (HEAD)
```

to:

```
A---B---C---D  master
            |\
            | E---F---G  feature-branch
            |
             \
              H'---I'---J' current-feature-branch (HEAD)
```


## show change history of a file.

`git log --follow --patch -- name-of-file`

The --patch/-p flag generates patch text, i.e. diffs of the file across commits. The --follow flag will include changes across renames in our change log. Note that --follow will only work if we’re looking at a single file – we should remove this flag if we’re viewing the history of multiple files, or want to exclude history past the file’s most recent renaming.
