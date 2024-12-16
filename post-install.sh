#!/bin/bash

# Make sure git credentials are stored
echo -e "\nSetting up git credentials..."
git config --global credential.helper store
echo -e "Done\n"

# Create Nebula folder structure
echo -e "\nCreating Nebula..."
cd ~/
mkdir Nebula
cd Nebula

# Get Nebula's data from Carbonite backups

# Clone Nebula's infrastructure
echo -e "\nCloning Nebula's infrastructure..."
git clone https://github.com/aguilarcarboni/nebula.git
echo -e "Done\n"

# Create Nebula's core
echo -e "\nCloning Athena from source..."
mkdir Athena
cd Athena
git clone https://github.com/aguilarcarboni/athena-webui.git
git clone https://github.com/aguilarcarboni/athena-api.git
git clone https://github.com/aguilarcarboni/athena-speech.git
echo -e "Building Athena using Nebula's infrastructure..."
cd ..
echo -e "\nBuilding Athena using Nebula's infrastructure..."
cd nebula
docker compose -f athena.yaml build
docker compose -f athena.yaml up -d
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
echo -e "\nBuilding Laserfocus using Nebula's infrastructure..."
cd nebula
docker compose -f laserfocus.yaml build
docker compose -f laserfocus.yaml up -d
cd ..
echo -e "Done\n"

echo -e "\nBuilding Atlas using Nebula's infrastructure..."
mkdir Atlas
cd nebula
docker compose -f atlas.yaml build
docker compose -f atlas.yaml up -d
cd ..
echo -e "Done\n"

echo -e "\nBuilding Apollo using Nebula's infrastructure..."
mkdir Apollo
cd nebula
docker compose -f apollo.yaml build
docker compose -f apollo.yaml up -d
cd ..
echo -e "Done\n"

echo -e "Done creating Nebula.\n"