#!/bin/bash

# Exit on error and ensure errors in pipelines are caught
set -e
set -o pipefail

# Check if the script is being run as root
echo -e "\nChecking if you are root..."
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi
echo -e "You are root. Proceeding with installation...\n"

# Set the root password, username, and hostname
read -sp "Enter the password for root: " root_password
echo -e "\n"
read -p "Enter the username you want to create: " username
read -sp "Enter the password for ${username}: " user_password
echo -e "\n"
read -p "Enter the host name: " hostname
echo -e "\n"

# Set the time zone
echo -e "\nTo set the time zone, you will use /sbin/tzselect."
echo "This command will guide you through selecting your region and city."
echo "Running /sbin/tzselect..."
timezone=$(/sbin/tzselect)
echo -e "\nSetting the time zone..."
ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime
hwclock --systohc
echo -e "Time zone set.\n"

# Ask for swap to file
read -p "Do you want to create a swap file? (Y/n): " swap
if [[ -z "${swap}" || "${swap}" =~ ^[Yy]$ ]]; then
    read -p "Enter the size of the swap file in GB: " swap_size
fi

# Set swap file if wanted
if [[ -z "${swap}" || "${swap}" =~ ^[Yy]$ ]]; then
    echo -e "\nCreating swap file..."
    mkswap -U clear --size ${swap_size}G --file /swapfile
    swapon /swapfile
    echo -e '/swapfile none swap defaults 0 0\n' >> /etc/fstab
    echo "Swap file created."
else
    echo -e "Skipping swap file creation.\n"
fi

# Set accounts
echo -e "\nSetting up accounts..."
echo "root:${root_password}" | chpasswd
useradd -mG wheel "${username}"
echo "${username}:${user_password}" | chpasswd
echo "Accounts set."

# Pacman configuration
echo -e "\nConfiguring pacman..."
sed -i '/#Color/s/^#//' /etc/pacman.conf
sed -i '/#ParallelDownloads/s/^#//' /etc/pacman.conf
if ! grep -q '^ILoveCandy' /etc/pacman.conf; then
    sed -i '/\[options\]/a ILoveCandy' /etc/pacman.conf
fi
pacman -Syy
echo "Pacman configured."

# Hardware detection and conditional package installation
echo -e "\nDetecting hardware..."
# Detect Virtual Machine environment
if grep "VBOX" /proc/scsi/scsi; then
    echo "VirtualBox environment detected. Installing VirtualBox Guest Additions..."
    pacman -S --needed --noconfirm virtualbox-guest-utils
    systemctl enable vboxservice.service
    echo "VirtualBox Guest Additions installed."
elif grep "QEMU" /proc/scsi/scsi; then
    echo "QEMU environment detected. Installing QEMU Guest Agent..."
    pacman -S --needed --noconfirm qemu-guest-agent
    echo "QEMU Guest Agent installed."
else
    echo "Physical hardware detected. Checking for specific hardware..."
    cpu_info=$(grep -m 1 'model name' /proc/cpuinfo)
    if echo "${cpu_info}" | grep -iq "intel"; then
        echo "Intel CPU detected. Ensuring intel-ucode is installed..."
        pacman -S --needed --noconfirm intel-ucode
    elif echo "${cpu_info}" | grep -iq "amd"; then
        echo "AMD CPU detected. Installing AMD microcode..."
        pacman -S --needed --noconfirm amd-ucode
    else
        echo "No specific CPU detected. Skipping CPU-specific installations."
    fi

    IFS=$'\n' # Change the Internal Field Separator to newline to correctly iterate over lines
    for gpu_info in $(lspci | grep -E "VGA|3D|2D"); do
        if echo "${gpu_info}" | grep -iq "nvidia"; then
            echo "NVIDIA GPU detected. Installing drivers..."
            pacman -S --needed --noconfirm mesa nvidia-open nvidia-utils nvidia-settings
        elif echo "${gpu_info}" | grep -iq "amd"; then
            echo "AMD GPU detected. Installing drivers..."
            pacman -S --needed --noconfirm mesa vulkan-radeon vulkan-tools
        elif echo "${gpu_info}" | grep -iq "intel"; then
            echo "Intel GPU detected. Installing drivers..."
            pacman -S --needed --noconfirm mesa vulkan-intel vulkan-tools
        else
            echo "No specific GPU detected. Skipping GPU-specific installations."
        fi
    done
    IFS=' ' # Reset the Internal Field Separator to default

    echo "Hardware detected and set up."
fi

# Enable sudo
echo -e "\nEnabling sudo..."
pacman -S --noconfirm --needed sudo
sed -i '/^# %wheel ALL=(ALL:ALL) ALL/s/^# //' /etc/sudoers
echo "Sudo enabled."

# Set the locale
echo -e "\nSetting english UTF-8 locale..."
sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >/etc/locale.conf
echo "Locale set."

# Grub installation
echo -e "\nInstalling GRUB..."
pacman -S --noconfirm --needed grub efibootmgr os-prober
grub-install --verbose --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
echo "GRUB installed."
echo -e "\nGenerating GRUB configuration..."
sed -i '$ s/^#//' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
echo "GRUB configuration generated."

# Network configuration
echo -e "\nConfiguring network..."
echo ${hostname} >/etc/hostname
echo "127.0.0.1 localhost
::1       localhost
127.0.1.1 ${hostname}.localhost ${hostname}" | tee /etc/hosts >/dev/null
pacman -S --noconfirm --needed networkmanager
systemctl enable NetworkManager.service
echo "Network configured."

# Audio configuration
echo -e "\nConfiguring audio..."
pacman -S --noconfirm --needed alsa-firmware pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack wireplumber
echo "Audio configured."

# Bluetooth configuration
echo -e "\nConfiguring Bluetooth..."
pacman -S --noconfirm --needed bluez bluez-utils
systemctl enable bluetooth.service
echo "Bluetooth configured."

# Install useful packages
echo -e "\nInstalling useful packages..."
pacman -S --needed --noconfirm fastfetch kitty python python-virtualenv docker docker-compose nodejs npm neovim openssh
npm install -g yarn
echo -e "Packages installed.\n"

# Start daemons
echo -e "\nEnabling relevant daemons..."
systemctl enable docker.socket
#sudo systemctl start sshd
sudo systemctl enable sshd
echo -e "Enabled relevant daemons.\n"

# Install KDE Plasma
#echo -e "\nInstalling KDE Plasma..."
#pacman -S --noconfirm --needed plasma-meta
#systemctl enable sddm.service

# Add user to docker group so it can run docker without sudo
echo -e "\nAdding user to docker group\n"
gpasswd -a ${username} docker
echo -e "Done\n"

# Run Fastfetch
fastfetch

echo -e "\nInstallation complete."