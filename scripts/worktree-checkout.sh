#!/bin/bash

# Script to create a git worktree from a branch name
# Handles local branches, ticket-prefixed branches, and remote branches

set -e

branch_name="${1:-}"

if [[ -z "$branch_name" ]]; then
    echo "Usage: worktree-checkout.sh <branch-name>"
    exit 1
fi

# Determine the type of branch and set folder name accordingly
if [[ "$branch_name" == origin/* ]]; then
    # Remote branch: origin/22504/my_branch
    # Remove 'origin/' prefix for folder name
    folder_name="${branch_name#origin/}"
    # Replace '/' with '__' for folder name
    folder_name="${folder_name//\//__}"
    # Local branch name (without origin/)
    local_branch="${branch_name#origin/}"

    # Create worktree with tracking branch
    echo "Creating worktree for remote branch: $branch_name"
    echo "Folder name: $folder_name"
    echo "Local tracking branch: $local_branch"

    git worktree add -b "$local_branch" "../$folder_name" "$branch_name"

elif [[ "$branch_name" == */* ]]; then
    # Local branch with ticket number: 22504/my_branch
    # Replace '/' with '__' for folder name
    folder_name="${branch_name//\//__}"

    echo "Creating worktree for local branch: $branch_name"
    echo "Folder name: $folder_name"

    git worktree add "../$folder_name" "$branch_name"

else
    # Simple local branch: my_branch
    folder_name="$branch_name"

    echo "Creating worktree for local branch: $branch_name"
    echo "Folder name: $folder_name"

    git worktree add "../$folder_name" "$branch_name"
fi

echo "Worktree created successfully at: ../$folder_name"
