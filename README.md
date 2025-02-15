# Laserfocus OS

## A customized Arch Linux distribution for enhanced productivity

### Description
Laserfocus OS is a specialized Arch Linux-based operating system using infrastructure as code to make it easy to create, deploy and manage a Nebula node inside the Nebula network from scratch.

Laserfocus OS can also be used as a base OS as a type of clean and minimal Linux installation.

### Features
- Minimal Linux installation
- Declarative configuration for users
- Preinstalled with developer tools (Docker, Node, Python, etc.)
- Hyprland desktop environment
- Nebula node management
- Automatic Vault 111 mounting for backups and data persistence (coming soon!)

### Installation
0. Download latest Arch Linux ISO from an [Arch Linux mirror](https://geo.mirror.pkgbuild.com/iso/latest/) and create bootable media

1. Boot into installer using latest Arch Linux Installer ISO
2. Install Arch Linux using [install-arch.sh](/install-arch.sh)

```bash
curl -L -o install-arch.sh https://raw.githubusercontent.com/aguilarcarboni/laserfocus-os/main/install-arch.sh
```

3. Once in Arch's root, clone repository from Github into /opt directory

```bash
git clone https://github.com/aguilarcarboni/laserfocus-os.git /opt/laserfocus-os
```

4. Install necessary packages using [configure.sh](/configure.sh)
5. Reboot machine and log in as user
6. Set up basic user configurations and any type of Nebula node using [setup-node.sh](/setup-node.sh)

### Contact
For questions and support, please reach out to [@aguilarcarboni](https://github.com/aguilarcarboni/)

---
Created by [@aguilarcarboni](https://github.com/aguilarcarboni/)