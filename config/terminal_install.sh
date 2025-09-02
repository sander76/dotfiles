#!/bin/bash


# AI! create a script that does the following checks:
# - check if a `~/.bashrc` file exists.
# - if exists, check if it is a symlink pointing to the `./config/terminal/bashrc` file in this repo.
# - if it is the correct symlink do nothing.
# - if it is not a symlink, ask the user whether to rename the original to `.bashrc.bak` and create the symlink.
# - if the file does not exist, also create the symlink
