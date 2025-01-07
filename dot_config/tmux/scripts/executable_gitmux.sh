#!/bin/bash
dir=$1

if [ -d "$dir/.git" ]; then
	gitmux_output=$(gitmux -cfg ~/.config/tmux/.gitmux.conf "$dir")
	if [ -z "$gitmux_output" ]; then
		echo ''
	else
		echo "$gitmux_output"
	fi
else
	echo ''
fi
