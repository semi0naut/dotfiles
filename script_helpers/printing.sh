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

error() {
  printf "${BOLD}${RED}$1${NORMAL}"
}

log() {
  msg="$1"
  value="$2"
  printf "@log ${BOLD}${YELLOW}$msg${GREEN}$value${NORMAL}\n"
}
