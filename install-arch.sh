#!/bin/bash

# Script to install Arch Linux
# WARNING: This script is meant to be run as root.

set -e
set -o pipefail

###############################################################################
# Install Arch Linux                                                           
###############################################################################

echo "Installing Arch Linux..."

# Create partitions, boot needs to be 500 MBs and root takes extra
cfdisk /dev/sda

# Format partitions to FAT and EXT4
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# Mount partitions
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot

# Install Arch-Linux
pacstrap -K /mnt linux linux-firmware base git

# Generate File System Tabs
genfstab -U /mnt >> /mnt/etc/fstab

# Change root to Arch
arch-chroot /mnt

echo "Successfully installed Arch Linux."