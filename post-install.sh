#!/bin/bash

# Add user to docker group so it can run docker without sudo
gpasswd -a aguilarcarboni docker

# Make sure git credentials are stored
git config --global credential.helper store
