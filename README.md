# Install Arch

## A personalized, declarative Arch Linux install

### Description
Arch Linux installer scripts to leverage infrastructure as code and have a declarative, personalized and minimal Linux installation.

### Features
- Minimal Linux installation
- Declarative configuration for users
- Hyprland desktop environment

### Installation

1. Download latest Arch Linux ISO from an [Arch Linux mirror](https://geo.mirror.pkgbuild.com/iso/latest/).
2. Boot into installer via Virtual Machine or USB drive.
3. Run the install-arch.sh script. Remember Arch needs two GPT partitions, one for boot and one for root. The boot partition needs to be at least 500 MBs.
```bash
curl -L -o install-arch.sh https://raw.githubusercontent.com/aguilarcarboni/arch-install/main/install-arch.sh
```
4. Once the script is finished make sure you are in Arch's root and run [setup-root.sh](/setup-root.sh).
```bash
git clone https://github.com/aguilarcarboni/arch-install.git /opt/arch-install
```
5. Exit Arch's root, reboot machine and log in as user.
6. Install user's software and configurations using [install-software.sh](/install-software.sh)

### created by [@aguilarcarboni](https://github.com/aguilarcarboni/)
