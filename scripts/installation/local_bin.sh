#!/bin/bash

# Script to create a  ~/bin directory and add it to PATH in .bashrc

cd ~

# Check if ~/bin directory exists
if [ ! -d "$HOME/bin" ]; then
    echo "Note: ~/bin directory does not exist yet."
    mkdir bin
else
    echo "~/bin directory exists"
fi

# Check if PATH export line already exists in .bashrc
BASHRC="$HOME/.bashrc"
PATH_LINE='export PATH="$HOME/bin:$PATH"'

# Check if ~/bin is already in PATH in .bashrc
if grep -q 'export PATH="$HOME/bin:$PATH"' "$BASHRC" ; then
    echo "~/bin is already in PATH in .bashrc"
else
    # Check if "## PATHS" section exists
    if grep -q "^## PATHS" "$BASHRC"; then
        # Insert PATH line after "## PATHS" line
        sed -i '/^## PATHS/a export PATH="$HOME/bin:$PATH"' "$BASHRC"
        echo "✓ Added ~/bin to PATH under ## PATHS section"
    else
        # Add PATH export to end of .bashrc
        echo "$PATH_LINE" >> "$BASHRC"
        echo "✓ Added ~/bin to PATH at end of .bashrc"
    fi
    echo "Note: Run 'source ~/.bashrc' or restart your terminal to apply changes"
fi

echo "PATH setup complete!"