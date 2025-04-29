#!/bin/bash

# This script is used to get the dotfiles from Github and install them on the user's machine.
# WARNING: THIS IS A DESTRUCTIVE SCRIPT. IT WILL OVERWRITE THE USER'S EXISTING DOTFILES.

# TODO: add public support

set -e
set -o pipefail

###############################################################################
# Get Dotfiles
###############################################################################

echo "Getting your dotfiles..."

echo "Cloning dotfiles from Github..."
git clone https://github.com/aguilarcarboni/dotfiles.git ~/dotfiles

echo "Copying basic dotfiles to home directory..."

###############################################################################
# GPG
###############################################################################

# Copy .gnupg to home directory
cp -r ~/dotfiles/.gnupg ~/

# Set permissions for .gnupg
chown -R $(whoami) ~/.gnupg/
chmod 600 ~/.gnupg/*
chmod 700 ~/.gnupg

###############################################################################
# SSH
###############################################################################

# Copy .ssh files to home directory
# This config allows the Apple Keychain to be used for SSH authentication
cp -r ~/dotfiles/.ssh ~/

###############################################################################
# Git
###############################################################################

# Copy .gitconfig to home directory
cp ~/dotfiles/.gitconfig ~/

###############################################################################
# Shell
###############################################################################

# Copy .zprofile to home directory
cp ~/dotfiles/.zprofile ~/

# Copy .bashrc to home directory
cp ~/dotfiles/.bashrc ~/

# Copy .zshrc and .zprofile to home directory
cp ~/dotfiles/.zshrc ~/
cp ~/dotfiles/.zprofile ~/

###############################################################################
# Decrypt Dotfiles
###############################################################################

cd ~/dotfiles
echo "Decrypting heavier files..."

# Decrypt the zip
read -sp "Enter your passphrase to decrypt your files: " passphrase
gpg --batch --passphrase ${passphrase} --decrypt encrypted.tar.gz.gpg > encrypted.tar.gz

# Extract the zip
tar xzf encrypted.tar.gz

cp encrypted/.pypirc ~/
cp encrypted/.git-credentials ~/

# Remove the dotfiles directory
rm -rf ~/dotfiles

echo "Done"
