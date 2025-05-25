#!/bin/bash

# This script is used to configure the system and its root user and create a new user.
# WARNING: THIS SCRIPT IS MEANT TO BE RUN AS ROOT.

set -e
set -o pipefail

###############################################################################
# Configure System Basics
###############################################################################

echo "Setting up root and other users..."

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Set the root password, username, and hostname
read -p "Enter the hostname you want to use: " hostname
read -sp "Enter the password for root: " root_password
read -p "Enter the username you want to create: " username
read -sp "Enter the password for ${username}: " user_password

# Set the time zone
echo "This command will guide you through selecting your region and city."
timezone=$(/sbin/tzselect)
ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime
hwclock --systohc

# Set the locale
sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >/etc/locale.conf

# Set accounts
echo "root:${root_password}" | chpasswd
useradd -mG wheel "${username}"
echo "${username}:${user_password}" | chpasswd

# Pacman configuration
sed -i '/#Color/s/^#//' /etc/pacman.conf
sed -i '/#ParallelDownloads/s/^#//' /etc/pacman.conf
if ! grep -q '^ILoveCandy' /etc/pacman.conf; then
    sed -i '/\[options\]/a ILoveCandy' /etc/pacman.conf
fi
pacman -Syy

# Enable sudo
pacman -S --noconfirm --needed sudo
sed -i '/^# %wheel ALL=(ALL:ALL) ALL/s/^# //' /etc/sudoers

# Grub installation
pacman -S --noconfirm --needed grub efibootmgr os-prober
grub-install --verbose --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
sed -i '$ s/^#//' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

###############################################################################
# Configure System Hardware and Install Drivers
###############################################################################

# Ask for swap to file
read -p "Do you want to create a swap file? (Y/n): " swap
if [[ -z "${swap}" || "${swap}" =~ ^[Yy]$ ]]; then
    read -p "Enter the size of the swap file in GB: " swap_size
fi

# Set swap file if wanted
if [[ -z "${swap}" || "${swap}" =~ ^[Yy]$ ]]; then
    mkswap -U clear --size ${swap_size}G --file /swapfile
    swapon /swapfile
    echo -e '/swapfile none swap defaults 0 0\n' >> /etc/fstab
fi

# Hardware detection and conditional package installation
if grep "VBOX" /proc/scsi/scsi; then
    pacman -S --needed --noconfirm virtualbox-guest-utils
    systemctl enable vboxservice.service
elif grep "QEMU" /proc/scsi/scsi; then
    pacman -S --needed --noconfirm qemu-guest-agent
else
    cpu_info=$(grep -m 1 'model name' /proc/cpuinfo)
    if echo "${cpu_info}" | grep -iq "intel"; then
        pacman -S --needed --noconfirm intel-ucode
    elif echo "${cpu_info}" | grep -iq "amd"; then
        pacman -S --needed --noconfirm amd-ucode
    fi

    IFS=$'\n'
    for gpu_info in $(lspci | grep -E "VGA|3D|2D"); do
        if echo "${gpu_info}" | grep -iq "nvidia"; then
            pacman -S --needed --noconfirm mesa nvidia-open nvidia-utils nvidia-settings
        elif echo "${gpu_info}" | grep -iq "amd"; then
            pacman -S --needed --noconfirm mesa vulkan-radeon vulkan-tools
        elif echo "${gpu_info}" | grep -iq "intel"; then
            pacman -S --needed --noconfirm mesa vulkan-intel vulkan-tools
        fi
    done
    IFS=' '
fi

# Network configuration
echo "${hostname}" >/etc/hostname
echo "127.0.0.1 localhost
::1       localhost
127.0.1.1 ${hostname}.localhost ${hostname}" | tee /etc/hosts >/dev/null
pacman -S --noconfirm --needed networkmanager
systemctl enable NetworkManager.service

# Audio configuration
pacman -S --noconfirm --needed alsa-firmware pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack wireplumber

# Bluetooth configuration
pacman -S --noconfirm --needed bluez bluez-utils
systemctl enable bluetooth.service

# Set ownership of the arch-install folder
chown -R ${username} /opt/arch-install

###############################################################################
# Install Essential Packages
###############################################################################

# Install useful packages
pacman -S --needed --noconfirm fastfetch kitty neovim openssh gnupg cmatrix

# Start daemons
sudo systemctl enable sshd

# Install KDE Plasma
#pacman -S --noconfirm --needed plasma-meta
#systemctl enable sddm.service

fastfetch