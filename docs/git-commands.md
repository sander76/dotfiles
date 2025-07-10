# remove local branches which are no longer on remote.

https://stackoverflow.com/a/47939403/1629704

- git fetch --prune (or git fetch -p, which is an alias, or git prune remote origin which does the same thing without fetching, and is probably not what you want most of the time).
- Note any remote branches that are reported as deleted. Or, to find them later on, git branch -v (any orphaned tracking branch will be marked "[gone]").
- git branch -d [branch_name] on each orphaned tracking branch

https://stackoverflow.com/questions/17983068/delete-local-git-branches-after-deleting-them-on-the-remote-repo


## remove tracked files

```
# add files to .gitignore first.(if needed)

git rm --cached <filename>
git commit -m "<Message>"
```

more info: https://www.baeldung.com/ops/git-remove-tracked-files-gitignore


## change parent branch

https://stackoverflow.com/questions/29914052/how-to-git-rebase-a-branch-with-the-onto-command

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

## rebase dev branch on updated main branch:

```
git fetch origin main:main
git rebase main
```

or when on dev branch:

```
git pull -r origin main
```

## breaking a big branch into smaller ones.

`git log --oneline --decorate`

`git cherry-pick <hash of commit>`

## stacked pr

https://www.codetinkerer.com/2023/10/01/stacked-branches-with-vanilla-git.html

https://andrewlock.net/working-with-stacked-branches-in-git-is-easier-with-update-refs/

example of three stacked branches on main:

```
* branch_3
|
* branch_2
|
* branch_1
|
* main
```

change is made in branch_1

```
* branch_1 (with new commit)
|
|  * branch_3
|  |
|  * branch_2
|  |
| /
*/  old branch_1 from which branch_2 originally branched from.
```

rebase both branch_2 and 3 on the latest commit of branch_1:

```
git checkout branch_3  # the top of the stack.

git rebase branch_1 --update-refs

```

## diff with filter

view the diff between current and main branch, excluding any *.lock file:

git diff main ':(exclude)*.lock'
