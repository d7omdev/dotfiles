#!/bin/bash

CONSOLE_DIR="$HOME/Projects/Work/Tap/Garlik-console/"
FRONT_DIR="$HOME/Projects/Work/Tap/Garlik_Front/"

# Create the "Back" window, change to the directory, and open nvim
tmux rename-window -t "$SESSION_NAME:1" "Console"
tmux send-keys -t "$SESSION_NAME:1" "cd $CONSOLE_DIR" C-m
tmux send-keys -t "$SESSION_NAME:1" "nvim" C-m

# Create the "Front" window, change to the directory, and open nvim
tmux new-window -t "$SESSION_NAME"
tmux rename-window -t "$SESSION_NAME:2" "Front"
tmux send-keys -t "$SESSION_NAME:2" "cd $FRONT_DIR" C-m
tmux send-keys -t "$SESSION_NAME:2" "nvim" C-m
