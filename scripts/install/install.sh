#!/bin/bash

# Package collections
TERMINAL_PACKAGES=(
    "fzf"
    "git-delta"
    "starship"
    "tlrc"
)

SYSTEM_PACKAGES=(
    "kanata"
)

# Function to install packages
install_packages() {
    local packages=("$@")
    for package in "${packages[@]}"; do
        echo "Installing $package..."
        brew install "$package"
    done
}

# Main script logic
case "$1" in
    "terminal")
        echo "Installing terminal packages..."
        install_packages "${TERMINAL_PACKAGES[@]}"
        ;;
    "full")
        echo "Installing all packages (terminal + system)..."
        install_packages "${TERMINAL_PACKAGES[@]}"
        install_packages "${SYSTEM_PACKAGES[@]}"
        ;;
    *)
        echo "Usage: $0 {terminal|full}"
        echo "  terminal - Install only terminal packages"
        echo "  full     - Install terminal and system packages"
        exit 1
        ;;
esac

echo "Installation complete!"
