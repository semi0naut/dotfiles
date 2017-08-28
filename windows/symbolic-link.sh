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

abort() {
  error "\nAborting...\n"
  exit 1
}

is_drive_path() {
  if [[ $1 =~ ^/ ]]; then
    echo 1
  else
    echo 0
  fi
}

is_symbolic_path() {
if [[ $1 =~ ^\.{1} ]]; then
    echo 1
  else
    echo 0
  fi
}

is_valid_sym_path() {
  path=$1
  valid=0
  if [[ $(is_drive_path $path) -eq 1 ]]; then
    valid=1
  elif [[ $(is_symbolic_path $path) -eq 1 ]]; then
    valid=1
  elif [[ ! $path =~ \/+ ]]; then
    valid=1
  fi

  echo $valid
}

windows_path() {
  ret=$1

  if [[ $(is_drive_path $ret) -eq 1 ]]; then
    ret="${ret/\//}"
    # Fix the drive name, e.g. c\foo becomes c:\foo
    ret=$(sed 's,\([a-zA-Z]*\),\1:,' <<< "$ret")
  fi

  ret="${ret////\\}" # replace unix path with windows path

  echo $ret
}

set -e

cwd=$PWD
platform=`uname` # 'Linux', 'Darwin', etc

printf "${BOLD}What's the link file's path and name?\n${YELLOW}> ${NORMAL}"
read -e link_name
if [[ $(is_valid_sym_path $link_name) -eq 0 ]]; then
  error "This path is invalid. Only symbolic and absolute paths and allowed."
  abort
fi

test -d "$link_name" && error "That is an existing folder!" && abort
test -e "$link_name" && error "That file already exists!" && abort
link_name=$(windows_path $link_name)

printf "${BOLD}Where should it point to?\n${YELLOW}> ${NORMAL}"
read -e link_path
if [[ $(is_valid_sym_path $link_path) -eq 0 ]]; then
  error "This path is invalid. Only symbolic and absolute paths are allowed."
  abort
fi
! test -d "$link_path" && ! test -e "$link_path" && error "That path doesn't exist!" && abort
link_path=$(windows_path $link_path)

cmd="cmd //c 'mklink  $link_name $link_path'"

printf "\n${BOLD}${BLUE}About to link ${GREEN}$link_name${BLUE} to ${GREEN}$link_path${NORMAL}\n"
printf "\n${BOLD}Enter 1 to proceed\n${YELLOW}> ${NORMAL}"
read confirm

if [[ $confirm == 1 ]]; then
  eval "$cmd"
else
  abort
fi
