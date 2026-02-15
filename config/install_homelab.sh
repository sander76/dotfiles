#!/bin/bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"


bash install_git.sh
bash install_docker.sh

git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=720000'

git config --global user.email "s.teunissen@gmail.com"
git config --global user.name "sander"
