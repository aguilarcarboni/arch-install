#!/bin/bash

# Add user to docker group so it can run docker without sudo
echo "Adding user to docker group\n"
gpasswd -a aguilarcarboni docker
echo "Done\n"


# Make sure git credentials are stored
echo "Setting up git credentials\n"
git config --global credential.helper store
echo "Done\n"