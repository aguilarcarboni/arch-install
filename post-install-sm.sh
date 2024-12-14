#!/bin/bash

# Make sure git credentials are stored
echo -e "\nSetting up git credentials..."
git config --global credential.helper store
echo -e "Done\n"

# Get Nebula's data from Carbonite

# Create Nebula folder structure
echo -e "\nCreating Nebula..."
cd ~/
mkdir Nebula
cd Nebula

# Clone Nebula's infrastructure
echo -e "\nCloning Nebula's infrastructure..."
git clone https://github.com/aguilarcarboni/nebula.git
echo -e "Done\n"