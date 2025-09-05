#!/bin/bash

# Exit immediately if any command fails
set -e

eget_location="$HOME/bin/eget"

manage_pre_requisits(){
    # Check if script is run with sudo rights
    # if [ "$EUID" -ne 0 ]; then
    #     echo "Error: This script requires sudo privileges to install packages."
    #     echo "Please run with: sudo $0"
    #     exit 1
    # fi

    # Create ~/bin directory if it doesn't exist
    mkdir -p ~/bin
    mkdir -p ~/.config
    mkdir -p ~/repos

    sudo apt update
    sudo apt install software-properties-common curl zip unzip -y

    # Check if eget is installed, if not install it
    if [ ! -f "$eget_location" ]; then
        echo "eget not found. Installing eget..."
        curl https://zyedidia.github.io/eget.sh | sh
        # Move eget to a directory in PATH if it's not already there
        if [ -f ./eget ]; then
            mv ./eget ~/bin/
            chmod +x "$eget_location"
            
        fi
    fi
}

manage_pre_requisits
