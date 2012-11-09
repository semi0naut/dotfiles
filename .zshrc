# Path to your oh-my-zsh configuration.
ZSH=$HOME/.zsh

fpath=($fpath $HOME/.zsh/func)
typeset -U fpath

setopt promptsubst
autoload -U promptinit
promptinit
prompt grb

autoload -U compinit
compinit

# Check for updates on initial load...
if [ "$DISABLE_AUTO_UPDATE" != "true" ]
then
  /usr/bin/env ZSH=$ZSH zsh $ZSH/tools/check_for_upgrade.sh
fi

# Load all of the config files that end in .zsh
for config_file ($ZSH/lib/*.zsh) source $config_file

# Customize to your needs...
export PATH=/usr/local/sbin:/usr/local/bin:${PATH}
#/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/git/bin
export PATH="$HOME/bin:$PATH"

# Unbreak broken, non-colored terminal
alias ls='ls -G'
alias ll='ls -lG'
alias l='ls -laG'
alias duh='du -csh'
export GREP_OPTIONS="--color"

# Unbreak history
export HISTSIZE=10000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

# Alias
alias r=rails
alias g=git
alias gst='git st'
alias gci='git ci'
alias gpom='git push origin master'
alias gf='git fetch'
alias gaa='git add --all'
alias gl='!source ~/.githelpers && pretty_git_log'
alias gdc='git diff --cached'
alias gam='git commit --amend'
alias cls=clear
alias sl=ls # often screw this up
alias history='fc -l 1'
alias ..='cd ../'
alias ...='cd ../..'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias cd/='cd /'


# Misc
activate_virtualenv() {
  if [ -f env/bin/activate ]; then . env/bin/activate;
  elif [ -f ../env/bin/activate ]; then . ../env/bin/activate;
  elif [ -f ../../env/bin/activate ]; then . ../../env/bin/activate;
  elif [ -f ../../../env/bin/activate ]; then . ../../../env/bin/activate;
  fi
}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
