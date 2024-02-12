# Streamline Your Setup with My Dotfiles ✨

Welcome to my personal dotfiles repository! Harness the power of automation to effortlessly manage your configurations across multiple systems.

## What's Inside

This repository contains my carefully crafted configuration files for various tools and applications, including:

- **Shell:** zsh
- **Terminal:** alacritty
- **...and more!**

## Installation

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/hesam-init/.dotfiles.git ~/.dotfiles
   ```

2. **Install stow:**

   - **Debian:**
     ```bash
     sudo apt install stow
     ```
   - **Void Linux:**
     ```bash
     sudo xbps-install -Sy install stow
     ```
   - **Fedora/Red Hat:**
     ```bash
     sudo dnf install stow
     ```
   - **macOS (Homebrew):**
     ```bash
     brew install stow
     ```

## Set Up Your Configs

1. **Navigate to repository:**

   ```bash
   cd ~/.dotfiles
   ```

2. **Symlink all configurations:**

   ```bash
   stow */
   ```

   To selectively symlink specific configurations:

   ```bash
   stow zsh alacritty zellij
   ```

## Additional Notes

- **Customization:** Feel free to tweak the configurations to match your preferences.
- **Contributions:** Open to suggestions and improvements!
- **Dependencies:** Ensure any required dependencies are installed for the tools you use.

## Enjoy a Smoother Workflow!

I hope this repository streamlines your setup and enhances your productivity. Feel free to explore, customize, and share your feedback!
