#!/bin/bash

# This script is used to setup the user's profile after the installation of Arch Linux.

set -e
set -o pipefail

###############################################################################
# Install Essential Software
###############################################################################

echo "Installing essential software..."

# Install essential packages
pacman -S --needed --noconfirm neovim spice-vdagent btop cmatrix fastfetch gnupg

# Install Python
pacman -S --needed --noconfirm python python-virtualenv

# Install developer packages
if [[ -z "${developer}" || "${developer}" =~ ^[Yy]$ ]]; then

    # Install Node.js and npm
    pacman -S --needed --noconfirm nodejs npm

    # Verify the Node.js version:
    node -v
    npm -v
    
    # Install yarn
    npm install --global yarn

    # Install docker
    pacman -S --needed --noconfirm docker docker-compose
    systemctl enable docker.socket
    echo -e "\nAdding user to docker group\n"
    gpasswd -a ${username} docker
    echo -e "Done\n"

fi

###############################################################################
# Get Dotfiles
###############################################################################

read -p "Do you want to get dotfiles? (Y/n): " dotfiles
if [[ -z "${dotfiles}" || "${dotfiles}" =~ ^[Yy]$ ]]; then
    sh utils/get-dotfiles.sh
fi

###############################################################################
# Generate SSH key for Github                                   
###############################################################################

read -p "Do you want to generate an SSH key for Github? (Y/n): " ssh_key
if [[ -z "${ssh_key}" || "${ssh_key}" =~ ^[Yy]$ ]]; then
    echo "Generating SSH key for Github. Save it in the default location."
    ssh-keygen -t ecdsa -b 521 -C "aguilarcarboni@gmail.com"
    cat ~/.ssh/id_ecdsa.pub
    read -sp "Please make sure you have copied this SSH key and will add it to Github." key_confirmation

    echo "\nCreating SSH agent to store keychain."
    eval "$(ssh-agent -s)"
    ssh-add --apple-use-keychain ~/.ssh/id_ecdsa
fi

###############################################################################
# Install Essential Applications
###############################################################################

###############################################################################
# Install Optional Applications
###############################################################################

###############################################################################
# Install Essential Developer Tools                                                     
###############################################################################

if [[ -z "${developer}" || "${developer}" =~ ^[Yy]$ ]]; then
    
    # Make Developer directories
    mkdir -p ~/Developer/Repositories
    mkdir -p ~/Developer/Virtual\ Machines/Disk\ Images
    mkdir -p ~/Developer/Scripts
    
fi

###############################################################################
# Install Optional Developer Tools
###############################################################################

if [[ -z "${developer}" || "${developer}" =~ ^[Yy]$ ]]; then

fi

fastfetch
exit 0