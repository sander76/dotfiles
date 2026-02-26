#!/bin/bash
set -e
# make sure we have our preparations done.
"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"
PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

curl https://mise.run/zsh | sh

