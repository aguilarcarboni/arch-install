#!/bin/bash
# Exit on error and ensure errors in pipelines are caught
set -e
set -o pipefail

# Make sure docker group exists
if ! getent group docker; then
    groupadd docker
fi

# Add user to docker group so it can run docker without sudo
gpasswd -a aguilarcarboni docker

# Make sure git credentials are stored
git config --global credential.helper store

# Check for .git-credentials file
if [ ! -f "$HOME/.git-credentials" ]; then
    echo "Error: .git-credentials file not found in home directory"
    exit 1
fi

# Create Repositories folder structure
cd /
mkdir Repositories
cd Repositories

mkdir Personal
cd Personal

# Clone the infrastructure
git clone https://github.com/aguilarcarboni/nebula.git

# Clone laserfocus
echo "\nCloning laserfocus..."
mkdir Laserfocus
cd Laserfocus
git clone https://github.com/aguilarcarboni/oasis.git
git clone https://github.com/aguilarcarboni/oasis-socket.git
git clone https://github.com/aguilarcarboni/laserfocus-api.git
git clone https://github.com/aguilarcarboni/athena-webui.git
git clone https://github.com/aguilarcarboni/athena-api.git
git clone https://github.com/aguilarcarboni/athena-speech.git
echo "Successfully cloned laserfocus.\n"