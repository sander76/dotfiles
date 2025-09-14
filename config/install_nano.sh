#!/bin/bash
set -e

PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
"$PARENT_FOLDER/prepare.sh"

echo "$PARENT_FOLDER"

apt install nano -y


"$PARENT_FOLDER/create_symlink.sh" "$PARENT_FOLDER/nano/nanorc" ~/.nanorc
