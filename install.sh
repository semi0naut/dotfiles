#!/bin/bash

if which tput >/dev/null 2>&1; then
  ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

set -e

cwd=$PWD
platform=`uname`

if [[ $platform != 'Linux' && $platform != 'Darwin' ]]; then
  printf "${RED}This is only supported on Linux or OS X.${NORMAL}\n"
  exit
fi

if [ ! -d "$HOME/.dotfiles" ]; then
  printf "${YELLOW}Creating dotfiles symlink${NORMAL}\n"
  ln -s $cwd $HOME/.dotfiles
fi

printf "Installing zsh..."
TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
  if hash chsh >/dev/null 2>&1; then
    printf "\n${BLUE}Changing the default shell to zsh${NORMAL}\n"
    chsh -s $(grep /zsh$ /etc/shells | tail -1)
  else
    printf "\n${RED}Unable to change the shell because this system does not have chsh.\n"
    printf "${BLUE}If this is Windows then you probably want to run the bash installer.${NORMAL}\n"
  fi
else
    printf "${YELLOW}already installed!${NORMAL}\n"
fi

# ////////////////////////////////////////////////////////////////////////////////////////
# OSX

if [[ $platform == 'Darwin' ]]; then
  printf "\n${BOLD}Running the OS X installer${NORMAL}\n"
  ./osx/install.sh
fi

