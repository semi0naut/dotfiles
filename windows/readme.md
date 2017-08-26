# Windows Setup

## Configure Shell
* Install [MSYS2 w/ MinGW-w64](http://www.msys2.org/) to `C:\msys64`
  * Open `C:\msys64\mingw64.exe`
  * Run `pacman -S base-devel mingw-w64-x86_64-toolchain git bc`
  * Use `C:\Users\<user>` as the terminal $HOME by editting `C:\msys64\etc\nsswitch.conf` and
    changing the `db_home` value to `windows`.
* You may need to work around an issue with envsubst.exe - you'll know there's a bug if git
  displays "': not a valid identifierline 89: export: dashless" or rebase complains about "new_count".
  * To patch, cd into `/mingw64/bin` and run `mv envsubst.exe envsubst.exe_backup`. Now run `pacman -S gettext`
    and verify that `which envsubst` reports back `/usr/bin/envsubst`.
  * Bug report is at https://github.com/Alexpux/MSYS2-packages/issues/735
* Map caps to left-ctrl using https://sharpkeys.codeplex.com/
* Symlink dotfiles to ~/.dotfiles with `cmd //c 'mklink .dotfiles drive:\path\to\dotfiles'`
* Symlink files in the dotfiles windows folder using `cmd //c 'mklink .some-file .dotfiles\some-file'`
* Symlink appropriate files in the root dotfiles directory
  * Ignore all zsh files
  * Don't symlink .vim folder because Plugged will fail to install the plugins.
    Just make a copy.

## Setup dev tools

* Download the Windows 2003 Resource Kit in order to get tools like `list.exe` (command line hex
  editor)
  * URL: https://www.microsoft.com/en-us/download/details.aspx?id=17657
  * Installer will display a compatibility warning. Ignore it.
  * Full list of tools can be found here
    https://www.technlg.net/windows/download-windows-resource-kit-tools/


## Compiling Vim

* If for some reason you want to compile Vim on Windows, do the following:
  * Git clone vim from Github
  * `cd vim/src`
  * `make -f Make_ming.mak ARCH=x86-64 OPTIMIZE=MAXSPEED STATIC_STDCPLUS=yes FEATURES=HUGE PYTHON="C:/Python27" PYTHON_VER=27 DYNAMIC_PYTHON=yes PYTHON3="C:/Python3" PYTHON3_VER=361 DYNAMIC_PYTHON=yes`


## Setting up Vim

You have to make a copy of the vim folder. For some unknown reason the Plugged scripts
don't work when running them on a symlinked .vim directory. Can also symlink most of the
directories in the vim folder. You have to symlink using the full path instead of
something like `~\.dotfiles\vim`, otherwise it won't work. The full path is something like
`c:\users\michael\.dotfiles\vim`. Be careful when removing symlinks as it will delete the
linked source as well.


## Setting up Cygwin

* Can create symlinks to dotfiles using the git bash shell. The cygwin home directory
  is likely going to be `C:\cygwin\home\<username>`.
* Build [rlwrap](https://github.com/hanslub42/rlwrap)


## Setting up Clojure

* Install Lein: https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein.bat


