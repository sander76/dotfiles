#!/bin/bash
set -e

# make sure we have our preparations done.
PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
echo "$PARENT_FOLDER"


# Get the original user's home directory
"$PARENT_FOLDER/create_symlink.sh" "$PARENT_FOLDER/zed" ~/.config/zed
