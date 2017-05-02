#!/bin/sh

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

printf "Installing Homebrew..."
if [ ! -d "/usr/local/Homebrew" ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  printf "${YELLOW}already installed!${NORMAL}\n"
fi

brew tap homebrew/core

printf "Installing xquartz..."
brew cask install xquartz

brew_packages=(
  'tree'
  'openssl'
  'xclip'
  'rlwrap'
  'cmake'
  'rust')

for package in "${brew_packages[@]}"
do
  printf "Installing $package..."
  ret=$(brew list | awk /$package/)
  if [[ $ret == $package ]]; then
    printf "${YELLOW}already installed!${NORMAL}\n"
  else
    eval "brew install $package"
    printf \n
  fi
done
