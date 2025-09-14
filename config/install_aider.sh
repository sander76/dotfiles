#!/bin/bash
set -e

PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
echo "$PARENT_FOLDER"

"$PARENT_FOLDER/prepare.sh"
"$PARENT_FOLDER/install_uv.sh"

uv tool install --force --python python3.12 --with pip aider-chat@latest

"$PARENT_FOLDER/create_symlink.sh" "$PARENT_FOLDER/aider_config/.aider.conf.yml" ~/.aider.conf.yml
