# Install Arch

## A personalized, declarative Arch Linux install

### Description
Arch Linux installer scripts to leverage infrastructure as code and have a declarative, personalized and minimal Linux installation.

### Features
- Minimal Linux installation
- Declarative configuration for users
- Preinstalled with developer tools (Docker, Node, Python, etc.)
- Hyprland desktop environment

### Installation

0. Download latest Arch Linux ISO from an [Arch Linux mirror](https://geo.mirror.pkgbuild.com/iso/latest/).
1. Boot into installer using latest Arch Linux Installer ISO.
2. Install Arch Linux using [install-arch.sh](/install-arch.sh).

```bash
curl -L -o install-arch.sh https://raw.githubusercontent.com/aguilarcarboni/arch-install/main/install-arch.sh
```

3. Once in Arch's root, clone repository from Github into /opt directory

```bash
git clone https://github.com/aguilarcarboni/arch-install.git /opt/arch-install
```

4. Install necessary packages using [setup-root.sh](/setup-root.sh)
5. Reboot machine and log in as user
6. Set up basic user configurations and any type of Nebula node using [install-software.sh](/install-software.sh)

### created by [@aguilarcarboni](https://github.com/aguilarcarboni/)
