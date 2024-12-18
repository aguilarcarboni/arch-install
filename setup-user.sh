#!/bin/bash

# Script to set up main user configuration after the installation of a base Arch Linux
# WARNING: This script is not meant to be run as root. It is meant to be run as the main user.

# Copy dotfiles to home directory
echo -e "\nCopying dotfiles..."
cp -r /opt/laserfocus-os/dotfiles/.gnupg ~/
cp -r /opt/laserfocus-os/dotfiles/.gitconfig ~/
gpg --decrypt /opt/laserfocus-os/dotfiles/.git-credentials.gpg > ~/.git-credentials
echo -e "Done\n"

# Make sure git credentials are stored
echo -e "\nSetting up git credentials..."
if [ ! -f ~/.git-credentials ]; then
    echo "Warning: ~/.git-credentials file not found"
    echo "Please make sure to login to git to create credentials"
    exit 1
fi
git config --global credential.helper store
echo -e "Done\n"

fastfetch

fastfetch
echo -e "Welcome to the laserfocus-os."
echo -e "The path to success starts with laserfocus."

wait 5
cmatrix