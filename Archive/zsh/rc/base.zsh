### HISTORY CONFIG ###
# History file for zsh
HISTFILE=~/.config/zsh_history
HIST_STAMPS="mm/dd/yyyy"
# How many commands to store in history
HISTSIZE=100000
SAVEHIST=100000
HISTORY_IGNORE="(ls|cd|pwd|zsh|exit|cd ..)"
# Optimize history sharing and behavior
setopt SHARE_HISTORY        # Share history across all sessions
setopt INC_APPEND_HISTORY   # Immediately append commands to the history file
setopt HIST_IGNORE_ALL_DUPS # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks before recording entry
setopt HIST_VERIFY          # Show command with history expansion before running

### System Fixes / Component Setup
# Setup the Editor for my systems (pick the first available)
for _e in nvim vim vi nano; do
  if command -v "$_e" >/dev/null 2>&1; then
    export EDITOR="$_e"
    break
  fi
done
: "${EDITOR:=vi}"
export GIT_EDITOR=$EDITOR

# Terminal Update: ensure 256-color for known terminals
case "$TERM_PROGRAM" in
    ghostty|alacritty) export TERM=xterm-256color ;;
esac
