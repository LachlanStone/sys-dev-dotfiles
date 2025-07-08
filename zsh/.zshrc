# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH="$HOME/.config/tfenv/bin:$PATH"
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
plugins=(git z zsh-syntax-highlighting zsh-autosuggestions) # Plugins that will be used
source $ZSH/oh-my-zsh.sh                                    # Start the Plugins

### My Customizations within the enviroment
source $ZRCDir/base.zsh
source $ZRCDir/alias.zsh
source $ZRCDir/completion.zsh
autoload -Uz compinit
compinit
sour

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

#Setup Cargo Directory
. "$HOME/.cargo/env"
