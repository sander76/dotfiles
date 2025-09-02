#!/bin/bash

# Get the directory where this script is located
#AI! do not cd into the SCRIPT_DIR folder
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
TARGET_BASHRC="$REPO_ROOT/config/terminal/bashrc"
HOME_BASHRC="$HOME/.bashrc"

# Check if the target bashrc file exists in the repo
if [ ! -f "$TARGET_BASHRC" ]; then
    echo "Error: Target bashrc file not found at $TARGET_BASHRC"
    exit 1
fi

# Check if ~/.bashrc exists
if [ -e "$HOME_BASHRC" ]; then
    # Check if it's a symlink pointing to the correct file
    if [ -L "$HOME_BASHRC" ]; then
        # Get the target of the symlink
        CURRENT_TARGET=$(readlink "$HOME_BASHRC")
        
        # Resolve to absolute path for comparison
        if [ "$CURRENT_TARGET" = "$TARGET_BASHRC" ] || [ "$(readlink -f "$HOME_BASHRC")" = "$TARGET_BASHRC" ]; then
            echo "✓ ~/.bashrc is already correctly symlinked to $TARGET_BASHRC"
            exit 0
        else
            echo "⚠ ~/.bashrc is a symlink but points to: $CURRENT_TARGET"
            echo "Expected: $TARGET_BASHRC"
            read -p "Do you want to update the symlink? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm "$HOME_BASHRC"
                ln -s "$TARGET_BASHRC" "$HOME_BASHRC"
                echo "✓ Updated symlink to point to $TARGET_BASHRC"
            else
                echo "No changes made."
                exit 1
            fi
        fi
    else
        # It's a regular file, ask to backup and replace
        echo "⚠ ~/.bashrc exists but is not a symlink"
        read -p "Do you want to rename it to .bashrc.bak and create the symlink? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mv "$HOME_BASHRC" "$HOME_BASHRC.bak"
            ln -s "$TARGET_BASHRC" "$HOME_BASHRC"
            echo "✓ Backed up original to ~/.bashrc.bak"
            echo "✓ Created symlink to $TARGET_BASHRC"
        else
            echo "No changes made."
            exit 1
        fi
    fi
else
    # File doesn't exist, create the symlink
    ln -s "$TARGET_BASHRC" "$HOME_BASHRC"
    echo "✓ Created symlink ~/.bashrc -> $TARGET_BASHRC"
fi
