platform=`uname -s`
kernel_release=`uname -r`

# Unbreak broken, non-colored terminal
export TERM=xterm-256color

# Use vim as the editor
export EDITOR=vim

# Grep tweaks
export GREP_OPTIONS="-nRi --color --exclude-dir=.git  --exclude-dir=tmp --exclude-dir=log --exclude-dir=node_modules --exclude-dir=bower_components --exclude-dir=coverage --exclude-dir=.bundle --exclude=*.csv --exclude=*.pdf --exclude-dir=vendor --exclude-dir=rdoc --exclude-dir=target --exclude-dir=personal --exclude-dir=resources/public/js/*.*" # --exclude-dir=images --exclude-dir=coverage

export RBENV_PATH="$HOME/.rbenv"

export RUBY_HEAP_MIN_SLOTS=1000000 # for < 2.1.1, will raise warning when using 2.1.1
export RUBY_GC_HEAP_INIT_SLOTS=1000000 # for 2.1.1
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000

# Setup Ansible
ANSIBLE_DIR=$HOME/.personal-files/open-source/ansible
export PYTHONPATH=${ANSIBLE_DIR}/lib:${PYTHONPATH}
export ANSIBLE_LIBRARY=${ANSIBLE_DIR}/library
export ANSIBLE_HOSTS=~/.ansible_hosts
export LEIN_FAST_TRAMPOLINE=y
export ANDROID_HOME=/usr/local/opt/android-sdk

if [[ $platform == 'Linux' ]]; then
  export LD_LIBRARY_PATH="/usr/lib/jvm/java-8-openjdk/jre/lib/amd64"
  export LOLCOMMITS_ANIMATE=4
  export LOLCOMMITS_FORK=true
  export LOLCOMMITS_STEALTH=true
  export LOLCOMMITS_DIR="/shared/Dev/lolcommits"
fi

# TODO setup a .personal-files bin directory and soft link contents to /usr/bin during setup

#export PATH=/usr/local/sbin:/usr/local/bin:${PATH}
path=($HOME/bin $HOME/.dotfiles/bin ${ANSIBLE_DIR}/bin ${RBENV_PATH}/bin $HOME/.vim/scripts $path)

if [[ $platform == 'Darwin' ]]; then
  source $HOME/.cargo/env
  path=($HOME/Qt/5.8/clang_64/bin $path)
fi

# Start rbenv
eval "$(rbenv init -)"

# Start the SSH agent
eval "$(ssh-agent -s)" > /dev/null
