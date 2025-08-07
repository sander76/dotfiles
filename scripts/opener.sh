#!/bin/bash

# This script needs to be sourced, not executed directly
# Usage: source scripts/opener.sh

opener() {
    local selected_file=$(~/bin/lstr-linux-x86_64/lstr interactive --icons)

    if [ -z "$selected_file" ]; then
        echo "No file selected"
        return 1
    fi

    if [ -d "$selected_file" ]; then
        # It's a directory, cd into it
        cd "$selected_file"
        echo "Changed directory to: $selected_file"
    elif [[ "$selected_file" == *.py ]]; then
        # It's a Python file, open with VSCode
        code "$selected_file"
        echo "Opened Python file: $selected_file"
    else
        echo "Selected item is neither a directory nor a Python file: $selected_file"
        return 1
    fi
}

# If the script is being sourced, define the function and run it
# If it's being executed directly, show usage instructions
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This script should be sourced, not executed directly."
    echo "Usage: source scripts/opener.sh"
    exit 1
else
    # Script is being sourced, run opener immediately
    opener
fi
