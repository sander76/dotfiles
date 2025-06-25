#!/bin/bash

# Find and change to a directory in the tree,
# excluding .git, .vscode and other common ignored directories
#
# Usage: source find_folders.sh [directory]
# If no directory is specified, uses current directory

# This needs to be sourced to allow changing directory
if [ "$0" = "$BASH_SOURCE" ]; then
    echo "Error: Script must be sourced"
    echo "Usage: source $0 [directory]"
    exit 1
fi

# Use first argument as search directory, or current directory if not provided
search_dir="${1:-.}"

selected=$(find "$search_dir" \
  -name ".git" -prune -o \
  -name ".vscode" -prune -o \
  -name ".venv" -prune -o \
  -name "venv" -prune -o \
  -name ".nox" -prune -o \
  -name "*cache*" -prune -o \
  -type d \
  -print | fzf)

if [ -n "$selected" ]; then
    cd "$selected"
fi
