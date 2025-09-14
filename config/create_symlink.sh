#!/bin/bash

# This script accepts two arguments: source and target.
# source points to a folder or file
# target points to the symlink target to be created.

if [ $# -ne 2 ]; then
    echo "Usage: $0 <source> <target>"
    exit 1
fi

source="$1"
target="$2"

# Check if source exists
if [ ! -e "$source" ]; then
    echo "Error: Source '$source' does not exist."
    exit 1
fi

# Convert to absolute paths for comparison
source_abs=$(realpath "$source")

# If target does not exist, create symlink
if [ ! -e "$target" ] && [ ! -L "$target" ]; then
    ln -s "$source_abs" "$target"
    echo "Created symlink: $target -> $source_abs"
    exit 0
fi

# If target exists, check if it's already the correct symlink
if [ -L "$target" ]; then
    target_link=$(readlink "$target")
    target_link_abs=$(realpath "$target_link" 2>/dev/null || echo "$target_link")
    
    if [ "$target_link_abs" = "$source_abs" ]; then
        echo "Symlink already exists and points to correct source: $target -> $source_abs"
        exit 0
    fi
fi

# Target exists but doesn't point to source, ask user
echo "Target '$target' already exists."
if [ -L "$target" ]; then
    echo "It is a symlink pointing to: $(readlink "$target")"
else
    echo "It is not a symlink."
fi
echo "Do you want to replace it with a symlink to '$source_abs'? (Y/N)"
read -r response

case "$response" in
    [Yy])
        rm -rf "$target"
        ln -s "$source_abs" "$target"
        echo "Replaced target with symlink: $target -> $source_abs"
        ;;
    *)
        echo "Operation cancelled."
        exit 0
        ;;
esac
