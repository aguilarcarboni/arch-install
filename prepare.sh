#!/bin/bash

# Script to install a base Arch Linux and prepare a system for the laserfocus-os project
# WARNING: This script is meant to be run as root.

# Create partitions
# Boot needs to be 500 MBs and root takes extra
echo -e "\nCreating partitions..."
cfdisk /dev/sda
echo -e "Done\n"

# Format partitions to FAT and EXT4
echo -e "\nFormatting partitions to FAT and EXT4..."
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
echo -e "Done\n"

# Mount partitions
echo -e "\nMounting partitions..."
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot
echo -e "Done\n"

# Install Arch-Linux
echo -e "\nInstalling Arch-Linux..."
pacstrap -K /mnt linux linux-firmware base git
echo -e "Done\n"

# Generate File System Tabs
echo -e "\nGenerating File System Tabs..."
genfstab -U /mnt >> /mnt/etc/fstab
echo -e "Done\n"

# Change root to Arch
echo -e "\nChanging root to Arch..."
arch-chroot /mnt