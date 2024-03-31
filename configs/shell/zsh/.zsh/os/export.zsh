if [[ "$OS" = void ]]; then
    source ~/.zsh/os/void/main.zsh
elif [[ "$OS" = debian ]]; then
    source ~/.zsh/os/debian/main.zsh
else
    echo "Unsupported operating system: $OS"
fi
