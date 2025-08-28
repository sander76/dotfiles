#!/bin/bash
set -e

# make sure we have our preparations done.
PARENT_FOLDER="$(dirname "${BASH_SOURCE[0]}")"

"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

# use custom repo to get the latest git version.
add-apt-repository ppa:git-core/ppa -y
apt update -y
apt install git -y

~/bin/eget https://github.com/dandavison/delta --to ~/bin


# Link Git config if it doesn’t exist

#AI! the file location of "$PWD/config/git" is not correct. the actual location is two levels 
[ ! -e ~/.config/git ] && ln -s "$PWD/config/git" ~/.config/git
