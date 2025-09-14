#!/bin/bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# this looks for scripts inside the above "SCRIPT_DIR" folder.
SCRIPTS=(
    "install_git.sh"
    "install_fzf.sh"
    "install_starship.sh"
    "install_uv.sh"
    "install_tldr.sh"
    "install_direnv.sh"
    "install_docker.sh"
    "install_nerdfont.sh"
    # "install_flatpak.sh"
    "install_nano.sh"
    "install_batcat.sh"
    # "install_bleh.sh"
    "install_aider.sh"
    "install_keyring.sh"
    "install_zsh.sh"
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
        echo "⚠ ~/.bashrc exists but does not point to $TARGET_BASHRC"
        echo "Current target: $CURRENT_TARGET"
        echo "Desired target: $TARGET_BASHRC"
        echo ""
        read -p "Do you want to replace ~/.bashrc with a symlink to $TARGET_BASHRC? (y/N): " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Backup the existing file
            backup_file="$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$HOME_BASHRC" "$backup_file"
            echo "✓ Backed up existing ~/.bashrc to $backup_file"
            
            # Create the symlink
            ln -s "$TARGET_BASHRC" "$HOME_BASHRC"
            echo "✓ Created symlink ~/.bashrc -> $TARGET_BASHRC"
        else
            echo "Exiting without making changes."
            exit 1
        fi
    fi
else
    ln -s "$TARGET_BASHRC" "$HOME_BASHRC"
    echo "✓ Created symlink ~/.bashrc -> $TARGET_BASHRC"
fi
