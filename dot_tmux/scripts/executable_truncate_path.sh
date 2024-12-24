#!/bin/sh
path="$1"
path=$(echo "$path" | sed "s|/media/Main/Linux|~|; s|^$HOME|~|")

[ "$path" = "~" ] && echo "~" && exit 0

current_dir=$(basename "$path")
parent_path=$(dirname "$path")

[ "$parent_path" = "~" ] && echo "~/$current_dir" && exit 0

shortened=""
for dir in $(echo "$parent_path" | tr '/' ' '); do
	if [ -z "$shortened" ]; then
		shortened="$dir"
	elif [[ "$dir" =~ ^\..* ]]; then
		shortened="$shortened/$(echo "$dir" | cut -c 2)"
	else
		shortened="$shortened/$(echo "$dir" | cut -c 1)"
	fi
done

echo "$shortened/$current_dir"
