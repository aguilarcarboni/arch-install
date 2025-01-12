#!/bin/bash

# Script to set up main user configuration after the installation of a base Arch Linux
# WARNING: This script is not meant to be run as root. It is meant to be run as the main user.
set -e
set -o pipefail

# Copy dotfiles to home directory
echo -e "\nCopying dotfiles..."

# Copy .gnupg
cp -r /opt/laserfocus-os/dotfiles/.gnupg ~/

# Set up correct gnupg ownership
chown -R $(whoami) ~/.gnupg/
chmod 600 ~/.gnupg/*
chmod 700 ~/.gnupg

# Copy .gitconfig
cp -r /opt/laserfocus-os/dotfiles/.gitconfig ~/

# Decrypt .git-credentials
echo -e "Decrypting heavier files..."
read -sp "Enter your passphrase to decrypt your files: " passphrase
echo -e "\n"
gpg --batch --passphrase ${passphrase} --decrypt /opt/laserfocus-os/dotfiles/.git-credentials.gpg > ~/.git-credentials
echo -e "Done\n"

# Setup AUR helper
cd $HOME
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

fastfetch
echo -e "Welcome to the laserfocus-os."
echo -e "The path to success starts with laserfocus."
