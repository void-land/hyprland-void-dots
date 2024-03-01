#!/bin/bash

get_username() {
  fullname=$(getent passwd "$(whoami)" | cut -d ':' -f 5 | cut -d ',' -f 1 | tr -d "\n")
  if [ -z "$fullname" ]; then
    username="$(whoami)"
  else
    username="${fullname%% *}"
  fi

  # Transforma todo o texto em maiúsculas
  username="${username^}"

  echo "@$username"
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

get_uptime() {
  echo "$(uptime -p | sed -e 's/up //g')"
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
    "--uptime")
      get_uptime
      ;;
    *)
      echo "Usage: $0 {--name|--kernel|--os|--pkgs|--wm|--uptime}"
      exit 1
      ;;
  esac
}

# Call the main function with the provided arguments
main "$@"
