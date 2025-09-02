#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# List of scripts to execute
SCRIPTS=(
    "install_git.sh"
    "install_fzf.sh"
    "install_starship.sh"
    "install_uv.sh"
    "install_tldr.sh"
    "install_direnv.sh"
    "install_docker.sh"
    "install_flatpak.sh"
    "install_nerdfont.sh"
)

# Loop through and execute each script
for script in "${SCRIPTS[@]}"; do
    script_path="$SCRIPT_DIR/$script"
    if [ -f "$script_path" ]; then
        echo "Executing $script..."
        if bash "$script_path"; then
            echo "✓ $script completed successfully"
        else
            echo "✗ $script failed"
            exit 1
        fi
    else
        echo "⚠ Script not found: $script_path"
    fi
done

TARGET_BASHRC="$SCRIPT_DIR/terminal/bashrc"
HOME_BASHRC="$HOME/.bashrc"

# Check if the target bashrc file exists in the repo
if [ ! -f "$TARGET_BASHRC" ]; then
    echo "Error: Target bashrc file not found at $TARGET_BASHRC"
    exit 1
fi

if [ -e "$HOME_BASHRC" ]; then
    # Check if it's a symlink pointing to the correct file
    CURRENT_TARGET=$(readlink -e "$HOME_BASHRC")
    
    if [ "$CURRENT_TARGET" = "$TARGET_BASHRC" ]; then
        echo "✓ ~/.bashrc is already correctly symlinked to $TARGET_BASHRC"
        exit 0
        
    else
        # It's a regular file, ask to backup and replace
        echo "⚠ ~/.bashrc exists but does not point to $TARGET_BASHRC"
        echo "FIX THIS FIRST."
        exit 1
    fi
else
    ln -s "$TARGET_BASHRC" "$HOME_BASHRC"
    echo "✓ Created symlink ~/.bashrc -> $TARGET_BASHRC"
fi
