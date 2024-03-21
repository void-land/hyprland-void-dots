# shell to zsh : chsh -s $(which zsh)

source ~/.zshlogin
source ~/.zshenv

ZSH_THEME="nebirhos"
# zsh-syntax-highlighting: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
# zsh-autosuggestions: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
plugins=(zsh-syntax-highlighting zsh-autosuggestions git themes jsontools)

if [[ "$OS" = void ]]; then
    source ~/.zsh/os/void.zsh
elif [[ "$OS" = debian ]]; then
    source ~/.zsh/os/debian.zsh
else
    echo "Unsupported operating system: $OS"
fi

source $ZSH/oh-my-zsh.sh
source ~/.zsh/functions/main.zsh
source ~/.zsh/aliases/main.zsh

eval "$(atuin init zsh)"
