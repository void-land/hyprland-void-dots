#!/bin/bash

get_username() {
  echo "$(whoami)"
}

get_kernel_version() {
  echo "$(uname -r)"
}

get_operating_system() {
  echo "$(cat /etc/os-release | awk 'NR==1' | awk -F '"' '{print $2}')"
}

get_installed_packages() {
  echo "$(yay -Q | wc -l)"
}

get_window_manager() {
  echo "$XDG_CURRENT_DESKTOP"
}

# Main function
main() {
  case "$1" in
    "--name")
      get_username
      ;;
    "--kernel")
      get_kernel_version
      ;;
    "--os")
      get_operating_system
      ;;
    "--pkgs")
      get_installed_packages
      ;;
    "--wm")
      get_window_manager
      ;;
    *)
      echo "Usage: $0 {--name|--kernel|--os|--pkgs|--wm}"
      exit 1
      ;;
  esac
}

# Call the main function with the provided arguments
main "$@"
