#!/bin/bash

# Package-specific installation functions
install_fzf() {
    echo "Installing fzf..."
    if ! brew install fzf; then
        return 1
    fi
    # Add fzf key bindings and fuzzy completion
    if ! $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc; then
        return 1
    fi
}

install_git_delta() {
    echo "Installing git-delta..."
    if ! brew install git-delta; then
        return 1
    fi
    # No additional setup needed
}

install_starship() {
    echo "Installing starship..."
    if ! brew install starship; then
        return 1
    fi
    # No additional setup needed (config is already in your dotfiles)
}

install_tlrc() {
    echo "Installing tlrc..."
    if ! brew install tlrc; then
        return 1
    fi
    # No additional setup needed
}

install_kanata() {
    echo "Installing kanata..."
    #AI! explain what happens here
    if ! brew install kanata; then
        return 1
    fi
    # Add any system-level setup here if needed
    echo "Note: kanata may require additional system configuration"
}

# Function collections
TERMINAL_FUNCTIONS=(
    "install_fzf"
    "install_git_delta"
    "install_starship"
    "install_tlrc"
)

SYSTEM_FUNCTIONS=(
    "install_kanata"
)

# Function to install packages
install_packages() {
    local functions=("$@")
    local failed=0
    for func in "${functions[@]}"; do
        if ! $func; then
            echo "Error: $func failed"
            failed=1
        fi
    done
    if [ $failed -eq 1 ]; then
        echo "Some packages failed to install"
        exit 1
    fi
}

# Function to display help
show_help() {
    echo "Usage: $0 {terminal|full}"
    echo "  terminal - Install only terminal packages (works for wsl too.)"
    echo "  full     - Install terminal and system packages. this assumes you're running linux system (not wsl.)"
}

# Main script logic
case "$1" in
    "terminal")
        echo "Installing terminal packages..."
        install_packages "${TERMINAL_FUNCTIONS[@]}"
        echo "Installation complete!"
        ;;
    "full")
        echo "Installing all packages (terminal + system)..."
        install_packages "${TERMINAL_FUNCTIONS[@]}"
        install_packages "${SYSTEM_FUNCTIONS[@]}"
        echo "Installation complete!"
        ;;
    "")
        show_help
        ;;
    *)
        show_help
        exit 1
        ;;
esac
