#!/bin/bash

# Define directories for the windows
BACK_DIR="$HOME/Projects/Learning-management-system/lms-backend/" # Replace with your "Back" directory path
FRONT_DIR="$HOME/Projects/Learning-management-system/lms-app/"    # Replace with your "Front" directory path

# Create the "Back" window, change to the directory, and open nvim
tmux rename-window -t "$SESSION_NAME:1" "Back"
tmux send-keys -t "$SESSION_NAME:1" "cd $BACK_DIR" C-m
tmux send-keys -t "$SESSION_NAME:1" "nvim" C-m

# Create the "Front" window, change to the directory, and open nvim
tmux new-window -t "$SESSION_NAME"
tmux rename-window -t "$SESSION_NAME:2" "Front"
tmux send-keys -t "$SESSION_NAME:2" "cd $FRONT_DIR" C-m
tmux send-keys -t "$SESSION_NAME:2" "nvim" C-m
