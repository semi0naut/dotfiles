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

# Source my custom files after oh-my-zsh so I can override things.
source $HOME/.dotfiles/zsh/aliases
source $HOME/.dotfiles/zsh/functions

# Customize to your needs...
export PATH=/usr/local/sbin:/usr/local/bin:${PATH}
PATH=$PATH:$HOME/bin
PATH="/usr/local/heroku/bin:$PATH"
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Alias
alias ls='ls -G'
alias ll='ls -lG'
alias l='ls -laG'
alias duh='du -csh'
alias r=rails
alias g=git
alias gco='git co'
alias gst='git st'
alias gci='git ci'
alias gpff='git pff'
alias gp='git push'
alias gpom='git push origin master'
alias gf='git fetch'
alias gaa='git add --all'
alias ga='git add --update'
alias gr='git reset'
alias grh='git reset --hard'
alias gl="!source ~/.githelpers && pretty_git_log"
alias gdc='git diff --cached'
alias gam='git commit --amend'
alias gre='git remote'
alias cls=clear
alias history='fc -l 1'
alias cd-='cd -'
alias ..='cd ../'
alias ...='cd ../..'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias cd/='cd /'
# easier reload
alias reload='source ~/.zshrc'
alias beg='bundle exec guard'

# Misc
activate_virtualenv() {
  if [ -f env/bin/activate ]; then . env/bin/activate;
  elif [ -f ../env/bin/activate ]; then . ../env/bin/activate;
  elif [ -f ../../env/bin/activate ]; then . ../../env/bin/activate;
  elif [ -f ../../../env/bin/activate ]; then . ../../../env/bin/activate;
  fi
}

### Added by the Heroku Toolbelt

# Shaves about 0.5s off Rails boot time (when using perf patch). Taken from https://gist.github.com/1688857
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000
