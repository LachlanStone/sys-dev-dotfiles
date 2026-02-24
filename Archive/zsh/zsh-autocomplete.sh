#!/usr/bin/bash
export ZLocalDir="$HOME/.config/zsh"
export ZRCDir="$HOME/.config/zsh/rc"


if [ -d "$HOME/.config/oh-my-zsh" ]; then
    if [ -d "$HOME/.config/oh-my-zsh/completions" ]; then
    echo "Folder Exists" >> /dev/null
    else
        mkdir "$HOME"/.config/oh-my-zsh/completions
    fi
fi

# This will auto overwrite the files each time, setting up both due to use Oh-My-ZSH, but also want to define under .zshrc config file
tenv completion zsh > "$ZLocalDir"/completions/.tenv.completion.zsh
tenv completion zsh > "$HOME"/.config/oh-my-zsh/completions/_tenv
