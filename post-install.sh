#!/bin/bash

# Make sure git credentials are stored
echo -e "\nSetting up git credentials..."
if [ ! -f ~/.git-credentials ]; then
    echo "Warning: .git-credentials file not found in home directory"
    echo "Please make sure to restore your dotfiles"
    exit 1
fi

git config --global credential.helper store
echo -e "Done\n"