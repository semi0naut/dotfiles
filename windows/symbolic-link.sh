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
  ret="${ret////\\}" # Replace Unix path with Windows path.
  echo $ret
}

set -e

cwd=$PWD
platform=`uname` # 'Linux', 'Darwin', etc

printf "${BOLD}${YELLOW}Enter full path to source file/dir:\n${NORMAL}"
read -e source_path
if [[ $(is_valid_sym_path $source_path) -eq 0 ]]; then
  error "This path is invalid. Only symbolic and absolute paths are allowed."
  abort
fi
! test -d "$source_path" && ! test -e "$source_path" && error "That path doesn't exist!" && abort
source_path=$(windows_path $source_path)


printf "${BOLD}${YELLOW}Enter full path to symlink destination:\n${NORMAL}"
read -e link_dest
if [[ $(is_valid_sym_path $link_dest) -eq 0 ]]; then
  error "This path is invalid. Only symbolic and absolute paths and allowed."
  abort
fi
test -d "$link_dest" && error "That is an existing folder!" && abort
test -e "$link_dest" && error "That file already exists!" && abort
link_dest=$(windows_path $link_dest)

cmd="cmd //c 'mklink  $link_dest $source_path'"

echo "${BOLD}${BLUE}About to create link ${GREEN}$link_dest${BLUE} to source ${GREEN}$source_path${NORMAL}"
printf "\n${BOLD}Enter 1 to proceed\n${YELLOW}> ${NORMAL}"
read confirm

if [[ $confirm == 1 ]]; then
  eval "$cmd"
else
  abort
fi
