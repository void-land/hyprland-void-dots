# shell to zsh : chsh -s $(which zsh)

# env's :
source $HOME/.zshlogin
source $HOME/.zshenv

# omz configs:
ZSH_THEME="nebirhos"
# zsh-syntax-highlighting: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
# zsh-autosuggestions: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
plugins=(zsh-syntax-highlighting zsh-autosuggestions git themes jsontools)

# os aliases :
if [[ "$OS" = void ]]; then
    source $HOME/.zsh_custom/os/void.zsh
elif [[ "$OS" = debian ]]; then
    source $HOME/.zsh_custom/os/debian.zsh
else
    echo "Unsupported operating system: $OS"
fi

# zellij :
if [ "$ZELLIJ_START" = true ]; then
    eval "$(zellij setup --generate-auto-start zsh)"
fi

# sources list:
source $ZSH/oh-my-zsh.sh
source $HOME/.zsh_custom/aliases.zsh
source $HOME/.zsh_custom/functions.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
