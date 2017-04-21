# Windows Setup

* map caps to left-ctrl using https://sharpkeys.codeplex.com/
* install git for Windows

* symlink dotfiles to ~/.dotfiles with `cmd //c 'mklink .dotfiles drive:\path\to\dotfiles'`
* symlink files in the dotfiles windows folder using `cmd //c 'mklink .some-file .dotfiles\some-file'`
* symlink appropriate files in the root dotfiles directory
  * ignore all zsh files
  * don't symlink .vim folder because Plugged will fail to install the plugins. Just make a copy.

## Setting up Cygwin

* can create symlinks to dotfiles using the git bash shell. The cygwin home directory
  is likely going to be `C:\cygwin\home\<username>`.

## Setting up Clojure

* Install Lein: https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein.bat
