#!/bin/bash

# This script is used to setup the user's profile after the installation of Arch Linux.

# Get dotfiles
echo -e "\nGetting dotfiles..."
sh get-dotfiles.sh
echo -e "Done\n"

# Install development tools
pacman -S --needed --noconfirm docker-compose nodejs npm
npm install -g yarn

# Install docker
pacman -S --needed --noconfirm docker
systemctl enable docker.socket
echo -e "\nAdding user to docker group\n"
gpasswd -a ${username} docker
echo -e "Done\n"