package main

import (
	"flag"
	"fmt"
	"hyprland-setup/utils"
	"log"
	"os"
	"path/filepath"
)

var (
	updateXbps      bool
	updatePkgs      bool
	clearCache      bool
	disableGrubMenu bool
	ttfFontsDir     = "host/ui/fonts/TTF"
)

var packages = map[string][]string{
	"VOID_REPOS":         {"void-repo-multilib", "void-repo-nonfree"},
	"CONTAINER_PACKAGES": {"podman", "podman-compose", "catatonit"},
	"BASE_PACKAGES":      {"fontconfig", "fontconfig-32bit", "inetutils", "v4l2loopback", "bind-utils", "zellij", "bat", "dust", "aria2", "fzf", "neofetch", "bat", "zsh", "fish-shell", "brightnessctl", "bluez", "cronie", "git", "stow", "eza", "dbus", "seatd", "elogind", "polkit", "NetworkManager", "gnome-keyring", "polkit-gnome", "pipewire", "wireplumber", "inotify-tools", "xorg", "gnome-keyring", "polkit-gnome", "mtpfs", "ffmpeg", "libnotify"},
	"DEVEL_PACKAGES":     {"glib", "pango-devel", "gdk-pixbuf-devel", "libdbusmenu-gtk3-devel", "glib-devel", "gtk+3-devel", "gtk-layer-shell-devel", "base-devel", "startup-notification-devel", "cairo-devel", "xcb-util-devel", "xcb-util-cursor-devel", "xcb-util-xrm-devel", "xcb-util-wm-devel"},
	"AMD_DRIVERS":        {"libglvnd-32bit", "libglapi-32bit", "opencv", "Vulkan-Headers", "Vulkan-Tools", "Vulkan-ValidationLayers-32bit", "mesa-vulkan-radeon", "mesa-vulkan-radeon-32bit", "vulkan-loader", "vulkan-loader-32bit", "libspa-vulkan", "libspa-vulkan-32bit", "amdvlk", "mesa-dri", "mesa-vaapi"},
	"HYPRLAND_PACKAGES":  {"qt5-wayland", "qt6-wayland", "qt6ct", "qt5ct", "noto-fonts-emoji", "ddcutil", "socat", "eww", "nerd-fonts-symbols-ttf", "Waybar", "avizo", "dunst", "swaybg", "mpvpaper", "grim", "jq", "slurp", "cliphist", "wl-clipboard", "swayidle", "pavucontrol", "nemo", "eog", "pavucontrol", "evince", "xorg-server-xwayland", "xdg-desktop-portal-gtk", "xdg-desktop-portal-wlr", "xdg-utils", "xdg-user-dirs", "xdg-user-dirs-gtk", "qt5-x11extras"},
	"SYSTEM_APPS":        {"alacritty", "octoxbps", "blueman", "wifish", "wpa_gui", "glow"},
}

var services = []string{
	"dbus",
	"seatd",
	"elogind",
	"NetworkManager",
	"polkitd",
	"bluetoothd",
	"crond",
}

func main() {
	fullInstall := flag.Bool("s", false, "Full install")
	installFonts := flag.Bool("f", false, "Install host fonts")
	showHelp := flag.Bool("h", false, "Show help")
	flag.Parse()

	if *showHelp || (!*fullInstall && !*installFonts) {
		displayHelp()

		os.Exit(0)
	}

	if *fullInstall {
		utils.CheckSudo()

		updateSystem()

		clearPkgsCache()

		installPackages()

		addUserToGroups()

		enableServices()

		enablePipewire()

		disableGrubMenuFunc()

		log.Println("Setup is done, please log out and log in")
	}

	if *installFonts {
		utils.CheckSudo()

		installTtfFonts()
	}
}

func displayHelp() {
	fmt.Println("Usage: [-s | -f] [-h]")
	fmt.Println("  -s   Full install")
	fmt.Println("  -f   Install host fonts")
	fmt.Println("  -h   Show help")
}

func updateSystem() {
	if updateXbps {
		utils.RunCommand("sudo", "xbps-install", "-u", "xbps")

		utils.LogColoredMessage("xbps updated \n", utils.ColorGreen)
	} else {
		utils.LogColoredMessage("Skipping xbps update \n", utils.ColorRed)
	}

	if updatePkgs {
		utils.RunCommand("sudo", "xbps-install", "-Syu")

		utils.LogColoredMessage("xbps/system updated", utils.ColorGreen)
	} else {
		utils.LogColoredMessage("Skipping full system update \n", utils.ColorRed)
	}
}

func clearPkgsCache() {
	if clearCache {
		utils.LogMessage("Clear package manager cache \n")

		utils.RunCommand("sudo", "xbps-remove", "-yO")
		utils.RunCommand("sudo", "xbps-remove", "-yo")
		utils.RunCommand("sudo", "vkpurge", "rm", "all")

		utils.LogMessage("Package manager cache cleared")
	} else {
		utils.LogColoredMessage("Skipping package manager cache clearance \n", utils.ColorRed)
	}
}

func packagesInstaller(packageList []string) {
	utils.LogColoredMessage(fmt.Sprintf("Installing %s \n", packageList), utils.ColorGreen)

	args := append([]string{"xbps-install", "-Sy"}, packageList...)

	utils.RunCommand("sudo", args...)

	// utils.LogColoredMessage(fmt.Sprintf("%s packages installed", setName), utils.ColorGreen)
}

func installPackages() {
	utils.LogColoredMessage("Installing required packages \n")

	for _, packageSet := range packages {
		packagesInstaller(packageSet)
	}
}

func addUserToGroups() {
	utils.LogMessage("Add user to needed groups")
	utils.RunCommand("sudo", "usermod", "-a", os.Getenv("USER"), "-G", "_seatd")
	utils.RunCommand("sudo", "usermod", "-a", os.Getenv("USER"), "-G", "bluetooth")
	utils.LogMessage("User added to needed groups")
}

func enableServices() {
	utils.LogMessage("Enable services")

	for _, service := range services {
		targetService := filepath.Join("/etc/sv", service)
		if _, err := os.Stat(filepath.Join("/var/service", service)); err == nil {
			utils.LogMessage(fmt.Sprintf("Service %s already exists, skipping", targetService))
		} else if _, err := os.Stat(targetService); os.IsNotExist(err) {
			utils.LogMessage(fmt.Sprintf("Service %s is not installed", targetService))
		} else {
			utils.RunCommand("sudo", "ln", "-s", targetService, "/var/service")
			utils.LogMessage(fmt.Sprintf("Service %s enabled", service))
		}
	}
	utils.LogMessage("Services enabled")
}

func enablePipewire() {
	utils.LogMessage("Enable Pipewire")
	utils.RunCommand("sudo", "ln", "-s", "/usr/share/applications/pipewire.desktop", "/etc/xdg/autostart")
	utils.RunCommand("sudo", "ln", "-s", "/usr/share/applications/pipewire-pulse.desktop", "/etc/xdg/autostart")
	utils.RunCommand("sudo", "ln", "-s", "/usr/share/applications/wireplumber.desktop", "/etc/xdg/autostart")
	utils.LogMessage("Pipewire enabled")
}

func disableGrubMenuFunc() {
	if disableGrubMenu {
		utils.LogMessage("Disable grub menu")
		appendToFile("/etc/default/grub", "GRUB_TIMEOUT=0")
		appendToFile("/etc/default/grub", "GRUB_TIMEOUT_STYLE=hidden")
		appendToFile("/etc/default/grub", `GRUB_CMDLINE_LINUX_DEFAULT="loglevel=1 quiet splash"`)
		utils.RunCommand("sudo", "update-grub")
		utils.LogMessage("Grub menu disabled")
	} else {
		utils.LogMessage("Skipping grub menu disable")
	}
}

func appendToFile(filename, text string) {
	f, err := os.OpenFile(filename, os.O_APPEND|os.O_WRONLY, 0644)
	utils.Check(err, fmt.Sprintf("open file %s", filename))
	defer f.Close()
	_, err = f.WriteString(text + "\n")
	utils.Check(err, fmt.Sprintf("write to file %s", filename))
}

func installTtfFonts() {
	files, err := filepath.Glob(filepath.Join(ttfFontsDir, "*"))

	utils.Check(err, fmt.Sprintf("glob %s", ttfFontsDir))

	for _, file := range files {
		utils.RunCommand("sudo", "cp", file, "/usr/share/fonts/TTF")
	}

	utils.RunCommand("sudo", "fc-cache", "-f", "-v")

	utils.LogMessage("Fonts installed successfully!")
}
