#!/bin/bash

# Script to set up main user configuration and dotfiles
# WARNING: This script is not meant to be run as root. It is meant to be run as the main user.

set -e
set -o pipefail

# Clone dotfiles from Github
echo -e "Cloning dotfiles from Github..."
git clone https://github.com/aguilarcarboni/dotfiles.git ~/dotfiles
echo -e "Done\n"
echo -e "Copying basic dotfiles to home directory..."

# Copy .gnupg to home directory
cp -r ~/dotfiles/.gnupg ~/

# Set permissions for .gnupg
chown -R $(whoami) ~/.gnupg/
chmod 600 ~/.gnupg/*
chmod 700 ~/.gnupg

# Copy .gitconfig to home directory
cp -r ~/dotfiles/.gitconfig ~/
echo -e "Done\n"
echo -e "Decrypting heavier files..."

# Decrypt .git-credentials
read -sp "Enter your passphrase to decrypt your files: " passphrase
echo -e "\n"
gpg --batch --passphrase ${passphrase} --decrypt ~/dotfiles/.git-credentials.gpg > ~/.git-credentials
echo -e "Done\n"

# Remove dotfiles folder
rm -rf ~/dotfiles

echo -e "Dotfiles added successfully"