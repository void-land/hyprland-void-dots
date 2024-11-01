package main

import (
	"flag"
	"fmt"
	"hyprland-setup/utils"
	"os"
	"path/filepath"
)

const (
	installHyprland bool   = true
	installPipewire bool   = true
	updateXbps      bool   = false
	updatePkgs      bool   = false
	clearCache      bool   = false
	disableGrubMenu bool   = false
	ttfFontsDir     string = "host/ui/fonts/TTF"
	hyprlandRepo    string = "https://github.com/void-land/hyprland-void-packages/releases/latest/download/"
)

var packages = map[string][]string{
	"VOID_REPOS":                 {"void-repo-multilib2", "void-repo-nonfree"},
	"CONTAINER_PACKAGES":         {"podman", "podman-compose", "catatonit"},
	"BASE_PACKAGES":              {"gperftools", "gperftools-32bit", "libspa-bluetooth", "fontconfig", "fontconfig-32bit", "inetutils", "v4l2loopback", "bind-utils", "zellij", "bat", "dust", "aria2", "fzf", "neofetch", "bat", "zsh", "fish-shell", "brightnessctl", "bluez", "cronie", "git", "stow", "eza", "dbus", "seatd", "elogind", "polkit", "NetworkManager", "gnome-keyring", "polkit-gnome", "pipewire", "wireplumber", "playerctl", "inotify-tools", "xorg", "gnome-keyring", "polkit-gnome", "mtpfs", "ffmpeg", "libnotify"},
	"DEVEL_PACKAGES":             {"cmake", "glib", "pango-devel", "gdk-pixbuf-devel", "libdbusmenu-gtk3-devel", "glib-devel", "gtk+3-devel", "gtk-layer-shell-devel", "base-devel", "startup-notification-devel", "cairo-devel", "xcb-util-devel", "xcb-util-cursor-devel", "xcb-util-xrm-devel", "xcb-util-wm-devel"},
	"AMD_DRIVERS":                {"opencl2-headers", "mesa-32bit", "mesa-dri", "mesa-vaapi", "mesa-dri-32bit", "mesa-vaapi-32bit", "libglvnd-32bit", "libglapi-32bit", "opencv", "Vulkan-Headers", "Vulkan-Tools", "Vulkan-ValidationLayers-32bit", "mesa-vulkan-radeon", "mesa-vulkan-radeon-32bit", "vulkan-loader", "vulkan-loader-32bit", "libspa-vulkan", "libspa-vulkan-32bit", "amdvlk"},
	"HYPRLAND_REQUIRED_PACKAGES": {"qt5-wayland", "qt6-wayland", "qt6ct", "qt5ct", "noto-fonts-emoji", "ddcutil", "socat", "eww", "nerd-fonts-symbols-ttf", "Waybar", "avizo", "dunst", "swaybg", "mpvpaper", "grim", "jq", "slurp", "cliphist", "wl-clipboard", "swayidle", "pavucontrol", "nemo", "eog", "pavucontrol", "evince", "xorg-server-xwayland", "xdg-desktop-portal-gtk", "xdg-desktop-portal-wlr", "xdg-utils", "xdg-user-dirs", "xdg-user-dirs-gtk", "qt5-x11extras"},
	"SYSTEM_APPS":                {"alacritty", "octoxbps", "blueman", "wifish", "wpa_gui", "glow"},
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

		// updateSystem()

		// clearPackagesCache()

		// setupHyprlandRepo()

		// syncXbps()

		setupPackages()

		// addUserToGroups()

		// setupServices()

		setupPipewire()

		disableGrubMenuFunc()

		utils.LogColoredMessage("Setup is done, please log out and log in", utils.ColorGreen)
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

func clearPackagesCache() {
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

func setupHyprlandRepo() {
	utils.LogColoredMessage("Installing hyprland repo \n")

	filePath := "/etc/xbps.d/hyprland-packages.conf"

	content := fmt.Sprintf("repository=%s", hyprlandRepo)

	err := utils.WriteToFile(filePath, content)

	if err != nil {
		fmt.Println("Error:", err)
	} else {
		utils.LogColoredMessage(fmt.Sprintf("Repo added to %s \n", filePath), utils.ColorGreen)
	}
}

func syncXbps() {
	utils.LogColoredMessage("Syncing repos \n")

	utils.RunCommand("sudo", "xbps-install", "-S")
}

func setupPackages() {
	utils.LogColoredMessage("Installing required packages \n")

	for _, packageList := range packages {
		args := append([]string{"xbps-install", "-y"}, packageList...)

		utils.RunCommand("sudo", args...)
	}
}

func addUserToGroups() {
	utils.LogMessage("Add user to needed groups \n")

	utils.RunCommand("sudo", "usermod", "-a", os.Getenv("USER"), "-G", "_seatd")
	utils.RunCommand("sudo", "usermod", "-a", os.Getenv("USER"), "-G", "bluetooth")

	utils.LogMessage("User added to needed groups \n")
}

func setupServices() {
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

func setupPipewire() {
	if installPipewire {
		utils.LogMessage("Setup pipwire \n")

		utils.RunCommand("sudo", "ln", "-sf", "/usr/share/applications/pipewire.desktop", "/etc/xdg/autostart")
		utils.RunCommand("sudo", "ln", "-sf", "/usr/share/applications/pipewire-pulse.desktop", "/etc/xdg/autostart")
		utils.RunCommand("sudo", "ln", "-sf", "/usr/share/applications/wireplumber.desktop", "/etc/xdg/autostart")
	} else {
		utils.LogColoredMessage("Skipping pipewire setup \n", utils.ColorRed)
	}
}

func disableGrubMenuFunc() {
	if disableGrubMenu {
		utils.LogMessage("Disable grub menu")

		utils.AppendToFile("/etc/default/grub", "GRUB_TIMEOUT=0")
		utils.AppendToFile("/etc/default/grub", "GRUB_TIMEOUT_STYLE=hidden")
		utils.AppendToFile("/etc/default/grub", `GRUB_CMDLINE_LINUX_DEFAULT="loglevel=1 quiet splash"`)

		utils.RunCommand("sudo", "update-grub")

		utils.LogMessage("Grub menu disabled")
	} else {
		utils.LogColoredMessage("Skipping grub menu disable \n", utils.ColorRed)
	}
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
