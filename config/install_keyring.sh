#!/bin/bash
set -e

PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
echo "$PARENT_FOLDER"

"$PARENT_FOLDER/prepare.sh"
"$PARENT_FOLDER/install_uv.sh"

uv tool install keyring

