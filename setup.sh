#!/bin/sh
# Enable shell script strictness
set -eu
# Enable command tracing
set -x
# Ensure config directory exists
mkdir -p ~/.config

# below the section of symlinks from this repo to the original
# locations.

# Link Git config if it doesn’t exist
[ ! -e ~/.config/git ] && ln -s "$PWD/config/git" ~/.config/git

# zshell stuff
[ ! -e ~/.zshrc ] && ln -s "$PWD/zshrc" ~/.zshrc 
[ ! -e ~/.zprofile ] && ln -s "$PWD/zprofile" ~/.zprofile

# rtx
[ ! -e ~/.config/rtx ] && ln -s "$PWD/config/rtx" ~/.config/rtx
