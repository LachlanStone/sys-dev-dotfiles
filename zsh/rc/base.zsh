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


### System Fixes / Component Setup
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

# Compilation flags
export ARCHFLAGS="-arch $(uname -m)"
export SHELL=/bin/zsh 

# Terminal Update
if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export TERM=xterm-256color
elif [[ "$TERM_PROGRAM" == "alacritty" ]]; then
    export TERM=xterm-256color
fi