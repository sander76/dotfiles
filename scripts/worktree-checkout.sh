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

    # Check if branch exists
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        git worktree add "../$folder_name" "$branch_name"
    else
        echo "Branch '$branch_name' does not exist."
        read -rp "Create new branch '$branch_name'? [y/N] " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            git worktree add -b "$branch_name" "../$folder_name"
        else
            echo "Aborted."
            exit 1
        fi
    fi

else
    # Simple local branch: my_branch
    folder_name="$branch_name"

    echo "Creating worktree for local branch: $branch_name"
    echo "Folder name: $folder_name"

    # Check if branch exists
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        git worktree add "../$folder_name" "$branch_name"
    else
        echo "Branch '$branch_name' does not exist."
        read -rp "Create new branch '$branch_name'? [Y/n] " response
        if [[ ! "$response" =~ ^[Nn]$ ]]; then
            git worktree add -b "$branch_name" "../$folder_name"
        else
            echo "Aborted."
            exit 1
        fi
    fi
fi

echo "Worktree created successfully at: ../$folder_name"

# Check for common_files folder in parent directory and offer to copy
common_files_dir="../common_files"
if [[ -d "$common_files_dir" ]]; then
    read -rp "Copy contents from common_files to the new worktree? [Y/n] " response
    if [[ ! "$response" =~ ^[Nn]$ ]]; then
        cp -r "$common_files_dir"/. "../$folder_name/"
        echo "Copied common_files to ../$folder_name"
    fi
fi

read -rp "Navigate to the new worktree folder? [Y/n] " response
if [[ ! "$response" =~ ^[Nn]$ ]]; then
    cd "../$folder_name" && exec $SHELL
fi
