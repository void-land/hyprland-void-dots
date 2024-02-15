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
  - [Installation](#installation)

## Requirements

Ensure that your system meets the following requirements before proceeding:

### Package Dependencies

The following packages are required for the proper functioning of Hyprland on Void Linux:

<details>
  <summary><strong>Core Hyprland Components</strong></summary>

  - [Void-Hyprland](https://github.com/Makrennel/hyprland-void)
  - hyprland
  - hyprland-protocols
  - xdg-desktop-portal-hyprland
  - xdg-desktop-portal
</details>

<details>
  <summary><strong>System Components</strong></summary>

  - dbus : service
  - seatd : service
  - elogind : service
  - polkit : service
  - NetworkManager : service
  - polkit-kde-agent
  - [ly](https://github.com/fairyglade/ly) : service
  - mesa-dri
  - pipewire
  - pipewire-pulse
  - pipewire-devel
  - stow
</details>

<details>
  <summary><strong>User Interface Components</strong></summary>

  - waybar
  - swaybg
  - animated bg [swww](https://github.com/LGFae/swww)
  - swaylock or [swaylock-effects](https://github.com/mortie/swaylock-effects)
  - grim
  - slurp
  - jq
  - wl-clipboard
  - libnotify
  - dunst
  - swayidle
  - swappy
  - cliphist
  - rofi
  - wlogout
  - font-awesome-pro-6
</details>

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