#!/bin/bash

set -e

if [ ! -d "~/.vim" ]; then
  echo "Syncing user dictionary" && cp ~/.vim/spell/* ~/.dotfiles/vim/spell/
  echo "Syncing user colors" && cp ~/.vim/colors/* ~/.dotfiles/vim/colors/
fi