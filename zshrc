# Path to your oh-my-zsh configuration.
ZSH=$HOME/.zsh

setopt promptsubst
autoload -U promptinit
promptinit
prompt grb

autoload -U compinit
compinit

# Never know when you're gonna need to popd!
setopt AUTO_PUSHD

# Allow completing of the remainder of a command
bindkey "^N" insert-last-word

# Show contents of directory after cd-ing into it
chpwd() {
  ls -lrthG
}

# Unbreak broken, non-colored terminal
export TERM=xterm-256color

# Use vim as the editor
export EDITOR=vi

# Grep tweaks
export GREP_OPTIONS="-nRi --color --exclude-dir=tmp" # --exclude-dir=public --exclude-dir=log --exclude-dir=vendor/assets --exclude-dir=fonts --exclude-dir=images --exclude-dir=coverage --exclude-dir=rdoc"

# Save a ton of history
export HISTSIZE=20000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

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
for config_file ($ZSH/lib/*.zsh); do
  source $config_file
done

# Source my custom files after oh-my-zsh so I can override things.
source $HOME/.dotfiles/zsh/aliases
source $HOME/.dotfiles/zsh/functions

# Customize to your needs...
export PATH=/usr/local/sbin:/usr/local/bin:${PATH}
PATH=$PATH:$HOME/bin
PATH="/usr/local/heroku/bin:$PATH"

# Initialize RVM
PATH=$PATH:$HOME/.rvm/bin
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
