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

#---------------------------------------------------------------------------------------------------
# API
#---------------------------------------------------------------------------------------------------

expand_path() {
  # Expands a symlink path. If the root folder is the home directory symbol "~" then it'll be
  # replaced by the full home path.
  local ret="$1"

  IFS="/" read -ra parts <<< "$ret"
  if [[ "${parts[0]}" == "~" ]]; then
    ret="$HOME"
    for ((i=1; i < ${#parts[@]}; i++))
    do
      ret="$ret/${parts[$i]}"
    done
  fi

  ret=$(readlink -m "$ret")
  echo $ret
}

windows_path() {
  ret=$1

  if [[ $(is_absolute_unix_path $ret) -eq 1 ]]; then
    ret="${ret/\//}"
    # Fix the drive name, e.g. c\foo becomes c:\foo
    ret=$(sed 's,\([a-zA-Z]*\),\1:,' <<< "$ret")
  fi

  ret="${ret////\\}" # replace unix path with windows path
  echo $ret
}

windows_to_unix_path() {
  ret=$1
  ret="/${ret/:/}"     # Remove drive ':'.
  ret="${ret//\\//}"   # Replace Windows slashes.
  ret="${ret// /\\ }"  # Add a backslash before spaces.
  echo "$ret"
}

move_file() {
  local src="$1"
  local src_path=$(dirname "${src}")
  local src_name=$(basename "${src}")
  local dest=$2
  local src_type=$3 # e.g. "script", "dependency", etc

  if [[ $src_type != '' ]]; then
    src_type="$src_type "
  fi

  if [[ -e "$src" ]]; then
    mkdir -p "$dest"
    mv "$src" "$dest"
    printf "${BOLD}${GREEN}Moved $src_type$src to $dest${NORMAL}\n"
  else
    error "Unable to find $src_type$src!\n"
  fi
}

copy_file() {
  local src="$1"
  local src_path=$(dirname "${src}")
  local src_name=$(basename "${src}")
  local dest=$2
  local src_type=$3 # e.g. "script", "dependency", etc

  if [[ $src_type != '' ]]; then
    src_type="$src_type "
  fi

  if [[ -e "$src" ]]; then
    # @fixme If $dest is a file then strip the file name from the path and mkdir on that instead
    echo "MAKE DIR $src $dest"
    #mkdir -p "$dest"
    cp "$src" "$dest"
    printf "${BOLD}${GREEN}Copied $src_type$src to $dest${NORMAL}\n"
  else
    error "Unable to find $src_type$src!\n"
  fi
}

copy_dir_files() {
  local src="$1"
  local dest=$2

  if [[ -d "$src" ]]; then
    mkdir -p "$dest"
    cp -r $src/* $dest
    printf "${BOLD}${GREEN}Copied contents of $src into $dest${NORMAL}\n"
  else
    error "Unable to find $src!\n"
  fi
}

is_absolute_unix_path() {
  if [[ $1 =~ ^/ ]]; then echo 1; else echo 0; fi
}

is_sym_file() {
  if [[ $1 =~ ^\.{1} ]]; then echo 1; else echo 0; fi
}

# Will return false if the path has no slashes.
is_windows_path() {
  if [[ ! $1 =~ \/+ ]]; then echo 1; else echo 0; fi
}

# Will return false if the path has no slashes.
is_unix_path() {
  echo $(! is_windows_path "$1")
}
