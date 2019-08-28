* change shell scripts to use new platform.sh and core.sh. Can even have an all.sh that sources all
  of the types.

#in pdot:
* main installer should verify that the expected ~/.dotfiles ~/.dev, .private-files etc exist
* Test that the `sym` script exists. Will use it to link files.
* Test that c:\msys64 is present. Can move this into platform.sh

* change the paths of the shell scripts to use %HOMEPATH% with dotfiles. Did this in marvin. Do it in
others.

* have a windows common installer that takes the path to visual studio.
    * print steps explaining how to change sim linked shell scripts.
    * Can then generate the c-shell-64 and c-shell-32 file in the selected computer's directory.
      Replace any pre-existing shell bat files.

* After all machine file generation, symlink shell scripts to .dev and whatever else needs to be
  done for you.

#in dotfiles/windows

* write an install script that sets things up.
* Can even download msys using curl.
* add link to visual studio 2015 source.

* automate ~/bin setup -- can do this via computer install script too?

* add tree program to dev tools on s3. Set it in the install script.
