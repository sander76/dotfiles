#!/bin/bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# this looks for scripts inside the above "SCRIPT_DIR" folder.
SCRIPTS=(
    "install_git.sh"
    "install_rg.sh"
    "install_fd.sh"
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
