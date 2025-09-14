#!/bin/bash
set -e

PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
echo "$PARENT_FOLDER"

"$PARENT_FOLDER/prepare.sh"
"$PARENT_FOLDER/install_uv.sh"

uv tool install --force --python python3.12 --with pip aider-chat@latest

#AI! change the below line by using the create_symlink.sh script located inside the $PARENT_FOLDER
[ ! -e ~/.aider.conf.yml ] && ln -s "$PARENT_FOLDER/aider_config/.aider.conf.yml"  ~/.aider.conf.yml
