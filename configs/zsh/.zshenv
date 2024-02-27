export $(dbus-launch)
export ZELLIJ_START=false
export ZSH="$HOME/.oh-my-zsh"
export OS_ID="$(grep -i -w 'ID=' /etc/os-release | awk -F= '{print $2}')"
export OS="$(grep -i -w "ID=" /etc/os-release | grep -oP '(?<=")[^"]*')"
export NEKORAY_PATH=/opt/nekoray/nekoray
export CODE_PATH=/opt/vscode/code
export DOTFILES=$HOME/.dots-hyprland
export VOID_PACKAGES_PATH=$HOME/.local/pkgs/void-packages
export DNS_CHANGER=$HOME/.shell/dns-changer.sh

if [ -d "$HOME/platform-tools" ]; then
    export PATH="$HOME/platform-tools:$PATH"
fi

export DENO_INSTALL="/home/$USER/.deno"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="$DENO_INSTALL/bin:$PATH"

. "$HOME/.cargo/env"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

[ -s "/home/$USER/.bun/_bun" ] && source "/home/$USER/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
