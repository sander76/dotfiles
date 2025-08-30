#!/bin/bash

packages=(
btop
git
)

install_packages() {
    echo "Installing packages: ${packages[@]}"
    echo "----------------------------------------"
    
    for package in "${packages[@]}"; do
        echo "Installing $package..."
        apt install -y "$package"
        
        if [[ $? -eq 0 ]]; then
            echo "✓ $package installed successfully"
        else
            echo "✗ Failed to install $package"
        fi
        echo "----------------------------------------"
    done
}


# Main execution
main() {
    echo "Package Installation Script"
    echo "=========================="
    
    install_packages
    
    echo "Package installation process completed!"
}

# Run the main function
main "$@"