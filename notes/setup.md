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
