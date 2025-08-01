# Hyprland and Dots Configuration for Arch/Void Linux

![Hyprland Logo](./.github/assets/hyprland-v2.png)

## Overview

This repository contains instructions and configurations for setting up Hyprland on Arch/Void Linux. Hyprland is a powerful Tiling compositor.

## Table of Contents

- [Hyprland and Dots Configuration for Void Linux](#hyprland-and-dots-configuration-for-void-linux)
  - [Overview](#overview)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
    - [Package Dependencies](#package-dependencies)
  - [Installation](#installation)
  - [Keybindings](#keybindings)
    - [Hyprland](#hyprland)
    - [Rofi](#rofi)
    - [Apps](#apps)

## Requirements

Ensure that your system meets the following requirements before proceeding:

### Package Dependencies

The following packages are required for the proper functioning of Hyprland on Void Linux:

<details>
  <summary><strong>Core Hyprland Components</strong></summary>

- [Void-Hyprland](https://github.com/Makrennel/hyprland-void) : ```hyprland hyprland-protocols xorg-server-xwayland xdg-desktop-portal-hyprland xdg-desktop-portal xdg-utils wayland wayland-protocols xdg-desktop-portal-wlr xdg-desktop-portal-gtk```

</details>

<details>
  <summary><strong>System Components</strong></summary>

- Repos : ```void-repo-multilib void-repo-nonfree```
- Services : ```dbus seatd elogind polkit bluez sddm cronie```
- Network : ```wpa_supplicant wifish wpa-cute wpa_gui - NetworkManager nmtui```
- Base : ```xorg gnome-keyring polkit-gnome mtpfs inotify-tools ffmpeg libnotify```
- Dev tools : ```git base-devel```
- Amd Drivers : ```Vulkan-Headers Vulkan-Tools Vulkan-ValidationLayers-32bit mesa-vulkan-radeon mesa-vulkan-radeon-32bit vulkan-loader vulkan-loader-32bit libspa-vulkan libspa-vulkan-32bit amdvlk mesa-dri```
- [Audio and Video](https://docs.voidlinux.org/config/media/pipewire.html) : ```pipewire wireplumber```

</details>

<details>
  <summary><strong>User Interface Components</strong></summary>

- Ui Components : ```Waybar avizo font-awesome-6 swaylock dunst``` [rofi](https://github.com/lbonn/rofi/blob/wayland/INSTALL.md)
- Wallpaper Daemons : ```swaybg mpvpaper``` [swww](https:i//github.com/LGFae/swww)
- Utilities : ```grim jq slurp playerctl cliphist wl-clipboard swayidle swappy pavucontrol```

</details>

## Installation

Follow these steps to install Hyprland on your Void Linux system:

1. Clone this repository:

   ```bash
   git clone https://github.com/void-land/hyprland-void-dots.git ~/.dots --recursive

   cd ~/.dots
   
   git submodule foreach --recursive "git checkout main"
   ```

2. Change into the repository directory:

   ```bash
   cd ~/.dots
   ```

   > ! Warning: Before executing the following command to sync configurations, ensure you have backed up your data to prevent any unintended loss.

3. Run this command to sync configs:

   ```bash
   ./stow.sh -s
   ```

## Keybindings

### Hyprland

|                                  Keys | Action                          |
| ------------------------------------: | :------------------------------ |
|                  <kbd>SUPER + C</kbd> | Close window                    |
|                  <kbd>SUPER + K</kbd> | Toggle Waybar                   |
|                  <kbd>SUPER + P</kbd> | Toggle pseudo-tiling            |
|                  <kbd>SUPER + D</kbd> | Toggle split                    |
|                        <kbd>F11</kbd> | Fullscreen                      |
|                  <kbd>SUPER + F</kbd> | Maximize                        |
|  <kbd>SUPER + Arrows or H,J,K,L</kbd> | Move window focus               |
|       <kbd>SUPER + ALT + Arrows</kbd> | Move tiled window               |
|       <kbd>SUPER + ALT + Arrows</kbd> | Resize window                   |
|           <kbd>SUPER + [1-9][0]</kbd> | Change workspace [1-10]         |
|   <kbd>SUPER + SHIFT + [1-9][0]</kbd> | Move window to workspace [1-10] |
|  <kbd>CTRL + SUPER + ARROW LEFT</kbd> | Go to previous workspace        |
| <kbd>CTRL + SUPER + ARROW RIGHT</kbd> | Go to next workspace            |
|         <kbd>SUPER + Left Click</kbd> | Drag window                     |
|        <kbd>SUPER + Right Click</kbd> | Drag resize window              |
|                  <kbd>SUPER + Y</kbd> | Random wallpaper                |

### Rofi

|                 Keys | Action            |
| -------------------: | :---------------- |
| <kbd>SUPER + R</kbd> | App launcher      |
| <kbd>SUPER + V</kbd> | Clipboard manager |
| <kbd>SUPER + L</kbd> | Logout menu       |
| <kbd>SUPER + U</kbd> | Wallpaper menu    |
| <kbd>SUPER + X</kbd> | Screenshot applet |

### Apps

|                 Keys | Action               |
| -------------------: | :------------------- |
| <kbd>SUPER + Q</kbd> | Terminal             |
| <kbd>SUPER + W</kbd> | Terminal with zellij |
| <kbd>SUPER + E</kbd> | File manager         |
| <kbd>SUPER + N</kbd> | Network manager      |
