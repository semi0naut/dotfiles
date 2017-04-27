# Windows Setup

* Map caps to left-ctrl using https://sharpkeys.codeplex.com/
* Install git for Windows

* Symlink dotfiles to ~/.dotfiles with `cmd //c 'mklink .dotfiles drive:\path\to\dotfiles'`
* Symlink files in the dotfiles windows folder using `cmd //c 'mklink .some-file .dotfiles\some-file'`
* Symlink appropriate files in the root dotfiles directory
  * Ignore all zsh files
  * Don't symlink .vim folder because Plugged will fail to install the plugins.
    Just make a copy.

## Setting up Cygwin

* Can create symlinks to dotfiles using the git bash shell. The cygwin home directory
  is likely going to be `C:\cygwin\home\<username>`.

## Setting up Clojure

* Install Lein: https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein.bat

## Setting up Vim

You have to make a copy of the vim folder. For some unknown reason the Plugged scripts
don't work when running them on a symlinked .vim directory. Can also symlink most of the
directories in the vim folder. You have to symlink using the full path instead of
something like `~\.dotfiles\vim`, otherwise it won't work. The full path is something like
`c:\users\michael\.dotfiles\vim`. Be careful when removing symlinks as it will delete the
linked source as well.
