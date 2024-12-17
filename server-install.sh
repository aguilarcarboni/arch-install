#!/bin/bash

# Make sure git credentials are stored
echo -e "\nSetting up git credentials..."
if [ ! -f ~/.git-credentials ]; then
    echo "Warning: ~/.git-credentials file not found"
    echo "Please make sure to login to git to create credentials"
    exit 1
fi
git config --global credential.helper store
echo -e "Done\n"

# Create Nebula folder structure
echo -e "\nCreating Nebula..."
cd ~/
mkdir Nebula
cd Nebula

# Mount Vault 111 and fetch Carbonite backups
echo -e "\nMounting Vault 111 and fetching most recent Carbonite backups..."
mkdir Carbonite
echo -e "Done\n"

# Clone Nebula's infrastructure
echo -e "\nCloning Nebula's infrastructure..."
git clone https://github.com/aguilarcarboni/nebula.git
echo -e "Done\n"

# Create Nebula's core
read -p "Do you want to set up Atlas in this machine? (Y/n): " atlas
if [[ -z "${atlas}" || "${atlas}" =~ ^[Yy]$ ]]; then
    echo -e "\nBuilding Atlas using Nebula's infrastructure..."
    mkdir atlas
    cd nebula
    docker compose -f atlas.yaml build
    docker compose -f atlas.yaml up -d
    cd ..
    echo -e "Done\n"
fi

read -p "Do you want to set up Apollo in this machine? (Y/n): " apollo
if [[ -z "${apollo}" || "${apollo}" =~ ^[Yy]$ ]]; then
    echo -e "\nBuilding Apollo using Nebula's infrastructure..."
    mkdir apollo
    cd nebula
    docker compose -f apollo.yaml build
    docker compose -f apollo.yaml up -d
    cd ..
    echo -e "Done\n"
fi

read -p "Do you want to set up Laserfocus in this machine? (Y/n): " laserfocus
if [[ -z "${laserfocus}" || "${laserfocus}" =~ ^[Yy]$ ]]; then
    echo -e "\nCloning laserfocus from source..."
    mkdir laserfocus
    cd laserfocus
    git clone https://github.com/aguilarcarboni/oasis.git
    git clone https://github.com/aguilarcarboni/oasis-socket.git
    git clone https://github.com/aguilarcarboni/laserfocus-api.git
    echo -e "Building laserfocus using Nebula's infrastructure..."
    cd ..

    echo -e "\nBuilding laserfocus using Nebula's infrastructure..."
    cd nebula
    docker compose -f laserfocus.yaml build
    docker compose -f laserfocus.yaml up -d
    cd ..
    echo -e "Done\n"
fi

read -p "Do you want to set up Athena in this machine? (Y/n): " athena
if [[ -z "${athena}" || "${athena}" =~ ^[Yy]$ ]]; then
    echo -e "\nCloning Athena from source..."
    mkdir athena
    cd athena
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
fi


echo -e "Done building Nebula.\n"