package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"
)

var (
	updatePkgs      bool
	clearCache      bool
	disableGrubMenu bool
	ttfFontsDir     = "host/ui/fonts/TTF"
)

var packages = map[string][]string{
	"VOID_REPOS":         {"void-repo-multilib", "void-repo-nonfree"},
	"CONTAINER_PACKAGES": {"podman", "podman-compose", "catatonit"},
	"BASE_PACKAGES":      {"inetutils", "v4l2loopback", "bind-utils", "zellij", "bat", "dust", "aria2", "fzf", "neofetch", "bat", "zsh", "fish-shell", "brightnessctl", "bluez", "cronie", "git", "stow", "eza", "dbus", "seatd", "elogind", "polkit", "NetworkManager", "gnome-keyring", "polkit-gnome", "pipewire", "wireplumber", "inotify-tools", "xorg", "gnome-keyring", "polkit-gnome", "mtpfs", "ffmpeg", "libnotify"},
	"DEVEL_PACKAGES":     {"glib", "pango-devel", "gdk-pixbuf-devel", "libdbusmenu-gtk3-devel", "glib-devel", "gtk+3-devel", "gtk-layer-shell-devel", "base-devel", "startup-notification-devel", "cairo-devel", "xcb-util-devel", "xcb-util-cursor-devel", "xcb-util-xrm-devel", "xcb-util-wm-devel"},
	"AMD_DRIVERS":        {"opencv", "Vulkan-Headers", "Vulkan-Tools", "Vulkan-ValidationLayers-32bit", "mesa-vulkan-radeon", "mesa-vulkan-radeon-32bit", "vulkan-loader", "vulkan-loader-32bit", "libspa-vulkan", "libspa-vulkan-32bit", "amdvlk", "mesa-dri", "mesa-vaapi"},
	"HYPRLAND_PACKAGES":  {"noto-fonts-emoji", "ddcutil", "socat", "eww", "nerd-fonts-symbols-ttf", "Waybar", "avizo", "dunst", "swaybg", "mpvpaper", "grim", "jq", "slurp", "cliphist", "wl-clipboard", "swayidle", "pavucontrol", "nemo", "eog", "pavucontrol", "evince", "xorg-server-xwayland", "xdg-desktop-portal-gtk", "xdg-desktop-portal-wlr", "xdg-utils", "xdg-user-dirs", "xdg-user-dirs-gtk", "qt5-x11extras", "qt5-wayland", "qt6-wayland"},
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
		checkSudo()

		updateSystem()

		clearPkgsCache()

		installPkgs()

		addUserToGroups()

		enableServices()

		enablePipewire()

		disableGrubMenuFunc()

		log.Println("Setup is done, please log out and log in")
	}

	if *installFonts {
		checkSudo()
		installTtfFonts()
	}
}

func displayHelp() {
	fmt.Println("Usage: [-s | -f] [-h]")
	fmt.Println("  -s   Full install")
	fmt.Println("  -f   Install host fonts")
	fmt.Println("  -h   Show help")
}

func checkSudo() {
	if os.Geteuid() != 0 {
		log.Fatalf("This script must be run as root")
	}
}

func logMessage(message string) {
	fmt.Println(time.Now().Format(time.Kitchen), ":", message)
}

func check(err error, message string) {
	if err != nil {
		log.Fatalf("Error during %s: %v", message, err)
	}
}

func runCommand(cmd string, args ...string) {
	logMessage(fmt.Sprintf("Running command: %s %s", cmd, strings.Join(args, " ")))

	out, err := exec.Command(cmd, args...).CombinedOutput()

	check(err, fmt.Sprintf("%s %s", cmd, strings.Join(args, " ")))

	logMessage(string(out))
}

func updateSystem() {
	logMessage("Update xbps package manager")

	runCommand("sudo", "xbps-install", "-u", "xbps")

	if updatePkgs {
		runCommand("sudo", "xbps-install", "-Syu")

		logMessage("xbps/system updated")
	} else {
		logMessage("Skipping full system update")
	}
}

func clearPkgsCache() {
	if clearCache {
		logMessage("Clear package manager cache")
		runCommand("sudo", "xbps-remove", "-yO")
		runCommand("sudo", "xbps-remove", "-yo")
		runCommand("sudo", "vkpurge", "rm", "all")
		logMessage("Package manager cache cleared")
	} else {
		logMessage("Skipping package manager cache clearance")
	}
}

func pkgsInstaller(logMsg string, packageList []string) {
	logMessage(logMsg)

	args := append([]string{"xbps-install", "-Sy"}, packageList...)

	runCommand("sudo", args...)
}

func installPkgs() {
	logMessage("Installing required packages")

	for _, packageSet := range packages {
		pkgsInstaller(fmt.Sprintf("Installing %s", packageSet), packageSet)

		logMessage(fmt.Sprintf("%s installed", packageSet))
	}
}

func addUserToGroups() {
	logMessage("Add user to needed groups")
	runCommand("sudo", "usermod", "-a", os.Getenv("USER"), "-G", "_seatd")
	runCommand("sudo", "usermod", "-a", os.Getenv("USER"), "-G", "bluetooth")
	logMessage("User added to needed groups")
}

func enableServices() {
	logMessage("Enable services")

	for _, service := range services {
		targetService := filepath.Join("/etc/sv", service)
		if _, err := os.Stat(filepath.Join("/var/service", service)); err == nil {
			logMessage(fmt.Sprintf("Service %s already exists, skipping", targetService))
		} else if _, err := os.Stat(targetService); os.IsNotExist(err) {
			logMessage(fmt.Sprintf("Service %s is not installed", targetService))
		} else {
			runCommand("sudo", "ln", "-s", targetService, "/var/service")
			logMessage(fmt.Sprintf("Service %s enabled", service))
		}
	}
	logMessage("Services enabled")
}

func enablePipewire() {
	logMessage("Enable Pipewire")
	runCommand("sudo", "ln", "-s", "/usr/share/applications/pipewire.desktop", "/etc/xdg/autostart")
	runCommand("sudo", "ln", "-s", "/usr/share/applications/pipewire-pulse.desktop", "/etc/xdg/autostart")
	runCommand("sudo", "ln", "-s", "/usr/share/applications/wireplumber.desktop", "/etc/xdg/autostart")
	logMessage("Pipewire enabled")
}

func disableGrubMenuFunc() {
	if disableGrubMenu {
		logMessage("Disable grub menu")
		appendToFile("/etc/default/grub", "GRUB_TIMEOUT=0")
		appendToFile("/etc/default/grub", "GRUB_TIMEOUT_STYLE=hidden")
		appendToFile("/etc/default/grub", `GRUB_CMDLINE_LINUX_DEFAULT="loglevel=1 quiet splash"`)
		runCommand("sudo", "update-grub")
		logMessage("Grub menu disabled")
	} else {
		logMessage("Skipping grub menu disable")
	}
}

func appendToFile(filename, text string) {
	f, err := os.OpenFile(filename, os.O_APPEND|os.O_WRONLY, 0644)
	check(err, fmt.Sprintf("open file %s", filename))
	defer f.Close()
	_, err = f.WriteString(text + "\n")
	check(err, fmt.Sprintf("write to file %s", filename))
}

func installTtfFonts() {
	files, err := filepath.Glob(filepath.Join(ttfFontsDir, "*"))

	check(err, fmt.Sprintf("glob %s", ttfFontsDir))

	for _, file := range files {
		runCommand("sudo", "cp", file, "/usr/share/fonts/TTF")
	}

	runCommand("sudo", "fc-cache", "-f", "-v")

	logMessage("Fonts installed successfully!")
}
