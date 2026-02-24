## enable color support of ls and add handy aliases (use the best dircolors available)
if command -v dircolors >/dev/null 2>&1; then
    if [[ -r "$HOME/.dircolors" ]]; then
        eval "$(dircolors -b "$HOME/.dircolors")"
    elif [[ -r "$ZRCDir/dircolors" ]]; then
        eval "$(dircolors -b "$ZRCDir/dircolors")"
    else
        eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

## optional tools and safe aliases (create only if available)
if command -v thefuck >/dev/null 2>&1; then
    eval "$(thefuck --alias fuck)"
fi
if command -v lazygit >/dev/null 2>&1; then
    alias lg='lazygit'
fi
if [[ -x "${XDG_CONFIG_HOME:-$HOME/.config}/scripts/kube/kubespace.sh" ]]; then
    alias kubespace='sh ${XDG_CONFIG_HOME:-$HOME/.config}/scripts/kube/kubespace.sh'
    alias kn='bash ${XDG_CONFIG_HOME:-$HOME/.config}/scripts/kube/kubespace.sh'
fi



## bat wrapper: use batcat if present, otherwise fallback message
if command -v batcat >/dev/null 2>&1; then
    bat() {
        if (( $# == 0 )); then
            echo "no text/file was provided — not running batcat"
            return 1
        fi
        batcat --color always --decorations never "$@"
    }
fi
