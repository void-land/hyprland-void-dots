export $(dbus-launch)
export ZELLIJ_START=false
export ZSH=$HOME/.oh-my-zsh
export OS_ID="$(grep -i -w 'ID=' /etc/os-release | awk -F= '{print $2}')"
export OS="$(grep -i -w "ID=" /etc/os-release | grep -oP '(?<=")[^"]*')"
export NEKORAY_PATH=/opt/nekoray/nekoray
export CODE_PATH=/opt/vscode/code
export DOTFILES=$HOME/.dots-hyprland
export VOID_PACKAGES_PATH=$HOME/.local/pkgs/void-packages
export DNS_CHANGER=$HOME/.scripts/dns-changer/main.sh
export STEAM_OS=$HOME/.steam-os/main.sh
export SPEEDTEST_DOWNLOAD_URL="http://185.239.106.174/assets/12mb.png"

if [ -d "/home/$USER/platform-tools" ]; then
    export PATH="$HOME/platform-tools:$PATH"
fi

if [ -d "/home/$USER/.deno" ]; then
    export DENO_INSTALL="/home/$USER/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
fi

if [ -d "/home/$USER/.cargo" ]; then
    . "/home/$USER/.cargo/env"
fi

if [ -d "/home/$USER/.bun" ]; then
    [ -s "/home/$USER/.bun/_bun" ] && source "/home/$USER/.bun/_bun"
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi

if [ -d "/home/$USER/.nvm" ]; then
    export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi
