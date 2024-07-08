#!/bin/bash

#Create Folders
for dir in Image_Files Audio_Files Video_Files PDFs_Files Scripts Compressed_Files Fedora Web Torrents CSVs; do
    [ -d "$dir" ] || mkdir "$dir"
done

# Initialize counter
count=0

# Function to move files
move_files() {
    for ext in $1; do
        for file in *.$ext; do
            [ -e "$file" ] || continue
            mv "$file" $2
            ((count++))
        done
    done
}

#Image Files
move_files "png svg jpg jpeg tif tiff bpm gif eps raw" Image_Files

# Audio Files
move_files "mp3 m4a flac aac ogg wav" Audio_Files

# Video Files
move_files "mp4 mov avi mpg mpeg webm mpv mp2 wmv" Video_Files

# PDFs
move_files "pdf docx doc" PDFs_Files

# Scripts
move_files "py rb sh run" Scripts

#Compressed Files
move_files "rar zip xz gz" Compressed_Files

# Mode any .rpm to Fedora Folder
move_files "rpm flatpakref" Fedora

# Web Files
move_files "html json css js" Web

# Torrents
move_files "torrent" Torrents

# CSVs
move_files "csv" CSVs

cd Scripts
mv organize.sh ..
cd ..

# Decrement count after moving the script
((count--))

# Only print the final message if count is greater than 0
if [ $count -gt 0 ]; then
    echo -e "All done organizing your messy messy Folder"
    echo -e "\033[0;32m$count\033[0m files moved."
else
    echo -e "\e[33mNothing to organize.\e[0m"
fi
