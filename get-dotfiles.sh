#!/bin/bash

###############################################################################
# Get Dotfiles                                                                #
###############################################################################

echo -e "Getting dotfiles..."

# Clone dotfiles from Github
echo -e "Cloning dotfiles from Github..."
git clone https://github.com/aguilarcarboni/dotfiles.git ~/dotfiles

# Copy .gnupg to home directory
echo -e "Copying basic dotfiles to home directory..."
cp -r ~/dotfiles/.gnupg ~/

# Set permissions for .gnupg
chown -R $(whoami) ~/.gnupg/
chmod 600 ~/.gnupg/*
chmod 700 ~/.gnupg

# Copy .gitconfig to home directory
cp -r ~/dotfiles/.gitconfig ~/

###############################################################################
# Decrypt Dotfiles                                                            #
###############################################################################

# Decrypt .git-credentials
echo -e "Decrypting heavier files..."
read -sp "Enter your passphrase to decrypt your files: " passphrase
echo -e "\n"
gpg --batch --passphrase ${passphrase} --decrypt ~/dotfiles/.git-credentials.gpg > ~/.git-credentials

# Remove dotfiles folder
rm -rf ~/dotfiles
echo -e "Done\n"
