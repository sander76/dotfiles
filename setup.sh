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
# bash shell stuff. Need this as zshell doesn't pick up the
# .zprofile file.
[ ! -e ~/.profile ] && ln -s "$PWD/profile" ~/.profile

# mise
[ ! -e ~/.config/mise ] && ln -s "$PWD/config/mise" ~/.config/mise

# starship
[ ! -e ~/.config/starship.toml ] && ln -s "$PWD/config/starship.toml" ~/.config/starship.toml

# vscode custom spell dictionary
[ ! -e ~/.config/vscode_dictionary ] && ln -s "$PWD/config/vscode_dictionary" ~/.config/vscode_dictionary

# run or raise
[ ! -e ~/.config/run-or-raise ] && ln -s "$PWD/config/run-or-raise" ~/.config/run-or-raise

# nano config
[ ! -e ~/.nanorc ] && ln -s "$PWD/nanorc" ~/.nanorc
