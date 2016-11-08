# Setup Windows

* map caps to left-ctrl using https://sharpkeys.codeplex.com/
* install git for windows
* edit ~/.profile and add `source ~/.bashrc`
* after installing dotfiles, edit ~/.gitconfig and change the editor to be `vim` instead of `/usr/bin/vim`

# Setup Arch

* Lots to do but unfortunately I didn't write it all down!
* Fix fonts by placing the following XML into `/etc/fonts/conf.avail/29-prettify.conf`
  and then symlinking: `ln -s /etc/fonts/conf.avail/29-prettify.conf /etc/fonts/conf.d/29-prettify.conf`

  ```
  <?xml version="1.0"?>
   <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
   <fontconfig>
   <match target="font" >
     <edit mode="assign" name="rgba" >
       <const>rgb</const>
     </edit>
   </match>
   <match target="font" >
     <edit mode="assign" name="hinting" >
       <bool>true</bool>
     </edit>
   </match>
   <match target="font" >
     <edit mode="assign" name="hintstyle" >
       <const>hintslight</const>
     </edit>
   </match>
   <match target="font" >
     <edit mode="assign" name="antialias" >
       <bool>true</bool>
     </edit>
   </match>
   <match target="font">
     <edit mode="assign" name="lcdfilter">
       <const>lcddefault</const>
     </edit>
   </match>
  </fontconfig>
  ```

## Map caps to left-ctrl

* Most promising method

  * Install `xorg-xmodmap`
  * Map `linux/home/Xmodmap` to ~/
  * The above taken from https://wiki.archlinux.org/index.php/xmodmap

* Second method: map caps key to left-ctrl (see https://wiki.archlinux.org/index.php/Map_scancodes_to_keycodes for details)
  * edit `/etc/udev/hwdb.d/10-my-modifiers.hwdb`
  * add:

  ```
  evdev:atkbd:dmi:*            # built-in keyboard: match all AT keyboards for now
   KEYBOARD_KEY_3a=leftctrl     # bind capslock to leftctrl
  ```

  * run `udevadm hwdb --update` then reboot

## Install clipboard getter

* `pi xsel`
* Now we can grab clipboard content in vim using `:read !xsel --clipboard --output`


# Setting up Ruby

* Install rvm
* Install bundler
* Install Ruby Docs
  gem install rdoc-data
  rdoc-data --install
  # to regenerate all gem docs
  gem rdoc --all --overwrite


# Setup Vim

Map <CapsLock> to <Ctrl> in System Preferences -> Keyboard -> Modifier Keys. Now <caps-c> can leave insert mode.


# Setup Git

Vim might not work properly when writing commit messages. To fix, run:

    $ git config --global core.editor /usr/bin/vim



