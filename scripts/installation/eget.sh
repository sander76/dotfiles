#!/bin/bash

ORIGINAL_DIR=$(pwd)
TEMP_DIR=$(mktemp -d)

cd "$TEMP_DIR"
curl https://zyedidia.github.io/eget.sh | sh
mv eget ~/bin

rm -rf "$TEMP_DIR"