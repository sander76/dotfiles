#!/bin/bash

# Exit immediately if any command fails
set -e


manage_pre_requisits(){
    # Create ~/bin directory if it doesn't exist
    mkdir -p ~/bin
    mkdir -p ~/repos

    sudo apt update
    sudo apt install software-properties-common curl zip unzip stow -y

}

manage_pre_requisits
