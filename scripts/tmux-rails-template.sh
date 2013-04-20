#!/bin/sh

tmux new -d -s my-awesome-app
tmux new-window -t my-awesome-app:2 -n 'server' 'bundle exec rails server'
tmux new-window -t my-awesome-app:3 -n 'vim' 'vi'
tmux attach -t my-awesome-app
