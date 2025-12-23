# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:/snap/bin/:$PATH
export PATH="$HOME/.tfenv/bin:$PATH"

# System Exports
export XDG_CONFIG_HOME="$HOME/.config"

# Other ZSH Paths that I user
export ZLocalDir="$HOME/.config/zsh"
export ZRCDir="$HOME/.config/zsh/rc"

### oh-my-ZSH Configuration Files ###
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"
zstyle ':omz:update' mode reminder # just remind me to update when it's time

### ZSH Settings ###
ZSH_THEME="fwalch"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

### Plugins
plugins=(git z zsh-syntax-highlighting zsh-autosuggestions direnv talosctl) # Plugins that will be used
source $ZSH/oh-my-zsh.sh                                    # Start the Plugins
eval "$(direnv hook zsh)"
### My Customizations within the enviroment
source $ZRCDir/base.zsh
source $ZRCDir/alia.zsh
source $ZRCDir/completion.zsh

## Completions of Packages for ZSH
source "$ZLocalDir"/completions/.tenv.completion.zsh
autoload -Uz compinit
compinit

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

#Setup Cargo Directory
. "$HOME/.cargo/env"
source <(kubectl completion zsh)
