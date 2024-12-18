# Laserfocus OS

## A customized Arch Linux distribution for enhanced productivity

### Description
Laserfocus OS is a specialized Arch Linux-based operating system designed for [brief description of target users/use case].

### Installation

Cloud installation
1. Boot into installer using Arch Linux Installer ISO
2. Copy prepare script from GitHub into machine's root directory

```bash
curl -L -o prepare.sh https://raw.githubusercontent.com/aguilarcarboni/laserfocus-os/main/prepare.sh
```
3. Install base Arch Linux using prepare.sh
4. Once in Arch's root, clone repository from Github into /opt directory

```bash
git clone https://github.com/aguilarcarboni/laserfocus-os.git /opt/laserfocus-os
```

5. Install necessary packages using install.sh
6. Reboot machine and log in as user
7. Set up basic user configurations and any type of Nebula node using setup-node.sh

### Features
- Preinstalled with developer tools (Docker, Node, Python, etc.)
- Hyprland desktop environment

### Contact
For questions and support, please reach out to [@aguilarcarboni](https://github.com/aguilarcarboni/)

---
Created by [@aguilarcarboni](https://github.com/aguilarcarboni/)