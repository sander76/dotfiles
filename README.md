# My linux configuration backup.

taken from the book: Boost Your Git DX

## Add a configuration

- move your config file or folder to this repo
    
    my `.config/git` folder moved to `config/git` (observe the removal of the dot to better tracking the files in this repo)

- edit the `setup.sh` file to create a symlink from this repo to the original location.

## Restore

When you wipe your computer or get a new one,
your dotfiles repository will let you rapidly restore your configuration.

First, clone the dotfiles repository to wherever you like to keep it:

```
$ cd ~/repos/
$ git clone git@example.org:hacker/dotfiles
```

Second, run the script:

```
$ ./setup.sh
+ mkdir -p /Users/hacker/.config
+ '[' '!' -e /Users/hacker/.config/git ']'
...
```

Boom, you’re done.

## docker / testing

docker run -v /repos/dotfiles:/dotfiles -it ubuntu:latest
