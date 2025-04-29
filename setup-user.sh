#!/bin/bash

# This script is used to setup the user's profile after the installation of Arch Linux.
# This script is meant to be run as the user.

# Get dotfiles
echo -e "\nGetting dotfiles..."
sh get-dotfiles.sh
echo -e "Done\n"