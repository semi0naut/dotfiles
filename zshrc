platform='uname'

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.zsh

setopt promptsubst
autoload -U promptinit
promptinit
prompt grb

if [[ $platform == 'Linux' ]]; then
  zstyle :compinstall filename `$HOME/.zshrc`
fi

autoload -Uz compinit
compinit

# Never know when you're gonna need to popd!
setopt AUTO_PUSHD

# Allow completing of the remainder of a command
bindkey "^N" insert-last-word

# Show contents of directory after cd-ing into it
chpwd() {
  if [[ $platform == 'Linux' ]]; then
    ls -lrthG --color
  elif [[ $platform == 'Darwin' ]]; then
    ls -lG
  fi
}

# Save a ton of history
export HISTSIZE=20000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
setopt appendhistory autocd
bindkey -e

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Load all of the config files in ~/.zsh that end in .zsh
source $ZSH/lib/*.zsh

# Source my custom files after oh-my-zsh so I can override things.
source $HOME/.dotfiles/zsh/aliases
source $HOME/.dotfiles/zsh/functions
