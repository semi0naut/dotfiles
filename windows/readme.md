# Windows Setup

* Turn off hibernation
  * Open admin cmd prompt: `powercfg.exe /hibernate off`

* Install Windows Defender

* Enable clear text

## Enable security updates

If you don't have an antivirus program, or you do but it's not verified by Microsoft, then you will
not receive security updates unless you set a key in the registry. Note that Windows Defender counts
as a valid antivirus program.

Add the following registry key:
Key="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat"
Value="cadca5fe-87d3-4b96-b7fb-a231484277cc" Type="REG_DWORD”
Data="0x00000000”

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

* Use symlink command `cmd //c 'mklink .name-of-dotfile drive:\path\to\file`.
* Symlink `~/.private-files` to the root directory containing `dev/`.
* Symlink `~/.dev` to `~/.private-files/path/to/dev`.
* Symlink `~/.dotfiles` to `~/.dev/path/to/dotfiles`.
* Create `~/bin`.
* Symlink `$HOME/bin/sym` to `$HOME/.dotfiles/windows/symbolic-link.sh`. You can now use this to
  do symlinks.
* Symlink files in the dotfiles windows folder.
* Symlink appropriate files in the root dotfiles directory.
  * Ignore all zsh files.
  * Don't symlink .vim folder because Plugged will fail to install the plugins. Just make a copy.
* Setup private dotfiles. Once done, you should now have `~/bin` and `~/.dotfiles/bin` in your path.

## Configure Private dotfiles
* The most important task is to setup the `c-dev-x64` shortcut for launching a msys shell with appropriate dev environment.
  * Add this to your taskbar and use this for launching a shell.

## Setup dev tools

* Download the Windows 2003 Resource Kit in order to get tools like `list.exe` (command line hex
  editor)
  * URL: https://www.microsoft.com/en-us/download/details.aspx?id=17657
  * Installer will display a compatibility warning. Ignore it.
  * Full list of tools can be found here
    https://www.technlg.net/windows/download-windows-resource-kit-tools/

## Setup Visual Studio

* Use the backed up VS2015 ISO.
* Pick a custom install directory, e.g. /x/programs/VS2015, /c/VS2015, etc.
* Make sure to not do a default install. You must select the C++ language support.

## Setting up Vim

### Compiling

* If for some reason you want to compile Vim on Windows, do the following:
  * Git clone vim from Github
  * `cd vim/src`
  * `make -f Make_ming.mak ARCH=x86-64 OPTIMIZE=MAXSPEED STATIC_STDCPLUS=yes FEATURES=HUGE PYTHON="C:/Python27" PYTHON_VER=27 DYNAMIC_PYTHON=yes PYTHON3="C:/Python3" PYTHON3_VER=361 DYNAMIC_PYTHON=yes`

### Configuring

You have to make a copy of the vim folder. For some unknown reason the Plugged scripts
don't work when running them on a symlinked .vim directory. Can also symlink most of the
directories in the vim folder. You have to symlink using the full path instead of
something like `~\.dotfiles\vim`, otherwise it won't work. The full path is something like
`c:\users\michael\.dotfiles\vim`. Be careful when removing symlinks as it will delete the
linked source as well.

**Search Setup**
The vim search setup requires some setup:
* First install Rusto. See `Setting up Rust` below.
* Setup `ripgrep`:
  * Open an `msvc x64` shell and run `cargo install ripgrep`.
  * Verify it works by running `rg` in a shell.

**ctags**
* Install the latest Universal ctags build: https://github.com/universal-ctags/ctags-win32/releases
* Place it in `~/bin`.

## Setting up Cygwin

* Can create symlinks to dotfiles using the git bash shell. The cygwin home directory
  is likely going to be `C:\cygwin\home\<username>`.
* Build [rlwrap](https://github.com/hanslub42/rlwrap)

## Setting up Rust

* Install `rustup`: https://win.rustup.rs/

## Setting up Go

* Installer: https://golang.org/doc/install

## Setting up Clojure

* Install Lein: https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein.bat

## Setup Xbox stuff

* Install the xbox controller drivers
* Turn off stats collection
  * cmd-r, msconfig.exe, startup tab, uncheck `Microsoft Xbox 360 Accessories`.

## Turn off various startup processes
* cmd-r -> msconfig.exe -> startup tab

## Software

* Install Desktop Restore (http://www.midiox.com/index.htm?http://midiox.com/desktoprestore.htm)

# Firefox
* If you see jaggy fonts then about `about:config` and check the value of
  `gfx.font_rendering.cleartype_params.rendering_mode`. Mine was -1 by default. Setting it to 5
  removed the bad font rendering.
