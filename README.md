# Hyprland Configuration and Setup Guide for Void Linux

<!-- ![Hyprland Logo](link_to_logo) -->

## Overview

This repository contains instructions and configurations for setting up Hyprland on Void Linux. Hyprland is a powerful Tiling compositor.

## Table of Contents

- [Hyprland Configuration and Setup Guide for Void Linux](#hyprland-configuration-and-setup-guide-for-void-linux)
  - [Overview](#overview)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
    - [Package Dependencies](#package-dependencies)
    - [Core Hyprland Components](#core-hyprland-components)
    - [System Components](#system-components)
    - [User Interface Components](#user-interface-components)
  - [Installation](#installation)

## Requirements

Ensure that your system meets the following requirements before proceeding:

- [List any other general requirements]

### Package Dependencies

The following packages are required for the proper functioning of Hyprland on Void Linux:

### Core Hyprland Components
- hyprland
- hyprland-protocols
- xdg-desktop-portal-hyprland
- xdg-desktop-portal

### System Components
- dbus
- seatd
- polkit
- polkit-kde-agent
- elogind
- mesa-dri
- lightdm
- sddm
- pipewire
- pipewire-pulse
- pipewire-devel
- stow

### User Interface Components
- waybar
- grim
- slurp
- dunst
- swayidle
- swappy
- cliphist
- rofi
- wlogout
- font-awesome

Make sure to install these packages using your package manager before setting up Hyprland.

[Note: Adjust the package names based on your Void Linux distribution and adapt the installation process accordingly.]

## Installation

Follow these steps to install Hyprland on your Void Linux system:

1. Clone this repository:

   ```bash
   git clone https://github.com/hesam-init/.dotfiles.git ~/.dots-hyprland
   ```

2. Change into the repository directory:

   ```bash
   cd ~/.dots-hyprland
   ```

3. Run this command to sync hyprland configs:

   ```bash
   stow hyprland
   ```