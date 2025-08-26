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
    echo "Installing tlrc (aka tldr)..."
    if ! brew install tlrc; then
        return 1
    fi
    # No additional setup needed
}

install_kanata() {
    echo "Installing kanata..."
    # Install kanata keyboard remapping tool via homebrew
    # brew install returns 0 on success, non-zero on failure
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

# Function to show what would be installed (dry run)
show_packages() {
    local functions=("$@")
    for func in "${functions[@]}"; do
        # Extract package name from function name (remove "install_" prefix)
        local package_name="${func#install_}"
        echo "  - $package_name (via $func)"
    done
}

# Function to display help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --group=terminal    Install only terminal packages (works for wsl too.)"
    echo "  --group=full        Install terminal and system packages. this assumes you're running linux system (not wsl.)"
    echo "  --single=FUNCTION   Install a single package function (e.g., install_kanata)"
    echo "  --dry-run           Show what would be installed without actually installing"
    echo ""
    echo "Examples:"
    echo "  $0 --group=terminal"
    echo "  $0 --group=full"
    echo "  $0 --single=install_fzf"
    echo "  $0 --group=terminal --dry-run"
    echo ""
    echo "Available functions:"
    echo "  Terminal packages:"
    printf "    %s\n" "${TERMINAL_FUNCTIONS[@]}"
    echo "  System packages:"
    printf "    %s\n" "${SYSTEM_FUNCTIONS[@]}"
}

# Function to ensure ~/.config directory exists
ensure_config_dir() {
    if [ ! -d "$HOME/.config" ]; then
        echo "Creating ~/.config directory..."
        mkdir -p "$HOME/.config"
    fi
}

# Function to check if a function exists
function_exists() {
    declare -f "$1" > /dev/null
    return $?
}

# Check for dry-run flag
DRY_RUN=false
if [[ "$*" == *"--dry-run"* ]]; then
    DRY_RUN=true
    # Remove --dry-run from arguments
    set -- "${@/--dry-run/}"
fi

# Main script logic
case "$1" in
    --group=terminal)
        if [ "$DRY_RUN" = true ]; then
            echo "Would install terminal packages:"
            show_packages "${TERMINAL_FUNCTIONS[@]}"
        else
            echo "Installing terminal packages..."
            install_packages "${TERMINAL_FUNCTIONS[@]}"
            echo "Installation complete!"
        fi
        ;;
    --group=full)
        if [ "$DRY_RUN" = true ]; then
            echo "Would install all packages (terminal + system):"
            echo "Terminal packages:"
            show_packages "${TERMINAL_FUNCTIONS[@]}"
            echo "System packages:"
            show_packages "${SYSTEM_FUNCTIONS[@]}"
        else
            echo "Installing all packages (terminal + system)..."
            install_packages "${TERMINAL_FUNCTIONS[@]}"
            install_packages "${SYSTEM_FUNCTIONS[@]}"
            echo "Installation complete!"
        fi
        ;;
    --single=*)
        FUNCTION_NAME="${1#--single=}"
        if function_exists "$FUNCTION_NAME"; then
            if [ "$DRY_RUN" = true ]; then
                echo "Would install single package:"
                show_packages "$FUNCTION_NAME"
            else
                echo "Installing single package: $FUNCTION_NAME"
                if ! $FUNCTION_NAME; then
                    echo "Error: $FUNCTION_NAME failed"
                    exit 1
                fi
                echo "Installation complete!"
            fi
        else
            echo "Error: Function '$FUNCTION_NAME' does not exist"
            echo "Available functions:"
            printf "  %s\n" "${TERMINAL_FUNCTIONS[@]}" "${SYSTEM_FUNCTIONS[@]}"
            exit 1
        fi
        ;;
    "")
        show_help
        ;;
    *)
        show_help
        exit 1
        ;;
esac
