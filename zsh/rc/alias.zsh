# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b $ZRCDir/dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Adding thefuck command fixer
eval $(thefuck --alias fuck)

# Changing the batcat configuration, to remove the plugin and move to shell component
# NOTE: This also detect if no file is provided
alias bat='f() { if [ -z "$1" ]; then echo "no text/file was provided not running batcat"; else batcat --color always --decorations never "$1"; fi; }; f'
