# Void Linux Package Management with XBPS

Void Linux utilizes the X Binary Package System (XBPS) for package management. XBPS is designed to be simple, efficient, and reliable. Here's a quick guide to get you started:

## Install New Package

To install a package, use the following command:

```bash
sudo xbps-install -S <package-name>
sudo xbps-install -S bat
```

Replace `<package-name>` with the name of the package you want to install.

## Install New Package From Local

```bash
sudo xbps-install -S --repository <package-path> <package-full-name>
sudo xbps-install -S --repository host/binpkgs hyprland-0.35.0_1
```

Replace `<package-path>` with the directory of package and Replace `<package-full-name>` with the name of the package you want to install

## Updating Package Database

Before installing or updating packages, it's advisable to refresh the package database:

```bash
sudo xbps-install -Su
```

This command synchronizes the local package database with the remote repositories, ensuring you have the latest package information.

## Upgrading Installed Packages

To upgrade all installed packages to their latest versions, use:

```bash
sudo xbps-install -u
```

This command updates all installed packages to their latest available versions.

## Searching for Packages

To search for a package, you can use:

```bash
xbps-query -Rs <search-term>
```

Replace `<search-term>` with the name or keyword related to the package you're looking for.

## Removing Packages

To remove a package, use:

```bash
sudo xbps-remove -R <package-name>
```

Replace `<package-name>` with the name of the package you want to remove.

## Cleaning Package Cache

To clean the package cache and free up disk space, use:

```bash
sudo xbps-remove -O
```

This command removes old package files from the cache.

## Update Default Apps by xbps-alternative

To set alternative for an app use :

```bash
sudo xbps-alternatives -C <config>
```


## Conclusion

XBPS provides a straightforward and efficient package management system for Void Linux. These basic commands should help you get started with installing, updating, and managing packages on your Void Linux system.