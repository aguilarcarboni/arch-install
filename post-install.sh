#!/bin/bash

# Make sure git credentials are stored
echo -e "\nSetting up git credentials..."
if [ ! -f ~/.git-credentials ]; then
    echo "Warning: ~/.git-credentials file not found"
    echo "Please make sure to login to git to create credentials"
    exit 1
fi

git config --global credential.helper store
echo -e "Done\n"