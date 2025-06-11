#!/bin/bash

set -e

cd ~/.vscode/extensions/ms-python.vscode-pylance-2025.5.1/dist/.cache

if [ -d "global_indices" ]; then
    rm -rf global_indices
    echo "Folder global_indices has been deleted"
else
    echo "Folder global_indices does not exist"
fi


if [ -d "local_indices" ]; then
    rm -rf local_indices
    echo "Folder local_indices has been deleted"
else
    echo "Folder local_indices does not exist"
fi

