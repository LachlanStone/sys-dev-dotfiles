# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Other ZSH Paths that I user
export ZLocalDir="$HOME/.config/zsh"
export ZRCDir="$HOME/.config/zsh/rc"

# Setup the Editor for my systems
if command -v nvim >/dev/null 2>&1; then
    export EDITOR="nvim"
elif command -v vim >/dev/null 2>&1; then
    export EDITOR="vim"
elif command -v vi >/dev/null 2>&1; then
    export EDITOR="vi"
elif command -v nano >/dev/null 2>&1; then
    export EDITOR="nano"
else
    export EDITOR="vi"
fi
export GIT_EDITOR=$EDITOR



### oh-my-ZSH Configuration Files ###
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

### ZSH Settings ###
ZSH_THEME="fwalch"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

### HISTORY CONFIG ###
# History file for zsh
HISTFILE=~/.config/zsh_history
HIST_STAMPS="mm/dd/yyyy"
# How many commands to store in history
HISTSIZE=10000000
SAVEHIST=10000000
HISTORY_IGNORE="(ls|cd|pwd|zsh|exit|cd ..)"
# Optimize history sharing and behavior
setopt SHARE_HISTORY             # Share history across all sessions
setopt INC_APPEND_HISTORY        # Immediately append commands to the history file
setopt HIST_IGNORE_ALL_DUPS      # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry
setopt HIST_VERIFY               # Show command with history expansion before running

### Plugins
plugins=(git z zsh-syntax-highlighting zsh-autosuggestions) # Plugins that will be used
source $ZSH/oh-my-zsh.sh # Start the Plugins

### Completions for autocomplete and stuff
source $ZRCDir/completion.zsh 
autoload -Uz compinit
compinit

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
export ARCHFLAGS="-arch $(uname -m)"
export SHELL=/bin/zsh 

# Terminal Update
if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export TERM=xterm-256color
elif [[ "$TERM_PROGRAM" == "alacritty" ]]; then
    export TERM=xterm-256color
fi

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

# Export Variables that are used within the enviroment
export PATH="$HOME/.config/tfenv/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"

#Setup Cargo Directory
. "$HOME/.cargo/env"
