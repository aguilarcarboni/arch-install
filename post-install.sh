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


# Create Nebula's core
echo -e "\nBuilding Atlas using Nebula's infrastructure..."
mkdir Atlas
cd Atlas
cd ..
echo -e "Done\n"

echo -e "\nBuilding Apollo using Nebula's infrastructure..."
mkdir Apollo
cd Apollo
cd ..
echo -e "Done\n"

echo -e "\nCloning Athena from source..."
mkdir Athena
cd Athena
git clone https://github.com/aguilarcarboni/athena-webui.git
git clone https://github.com/aguilarcarboni/athena-api.git
git clone https://github.com/aguilarcarboni/athena-speech.git
echo -e "Building Athena using Nebula's infrastructure..."
cd ..
echo -e "Done\n"

echo -e "\nCloning laserfocus from source..."
mkdir Laserfocus
cd Laserfocus
git clone https://github.com/aguilarcarboni/oasis.git
git clone https://github.com/aguilarcarboni/oasis-socket.git
git clone https://github.com/aguilarcarboni/laserfocus-api.git
echo -e "Building laserfocus using Nebula's infrastructure..."
cd ..
echo -e "Done\n"


echo -e "Done creating Nebula.\n"