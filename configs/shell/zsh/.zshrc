# shell to zsh : chsh -s $(which zsh)

ZSH_THEME="nebirhos"
# zsh-syntax-highlighting: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
# zsh-autosuggestions: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
plugins=(zsh-syntax-highlighting zsh-autosuggestions git themes jsontools)

source $ZSH/oh-my-zsh.sh
source ~/.zsh/functions/main.zsh
source ~/.zsh/aliases/export.zsh
source ~/.zsh/os/export.zsh

eval "$(atuin init zsh --disable-up-arrow)"
