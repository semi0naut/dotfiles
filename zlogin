# go to saved path if there is one
if [[ -f ~/.current_path~ ]]; then
  cd `cat ~/.current_path~`
  rm ~/.current_path~
fi

# Need to edit the path again here so that we can get the homebrew bin folder ahead of
# everything else. This is necessary because zsh is modifying the path in zshrc, and
# that causes us to run out of /usr/bin for programs that we want to use from homebrew's
# bin
path=($HOME/homebrew/opt/openssl/bin $HOME/homebrew/sbin $HOME/homebrew/bin $path)
