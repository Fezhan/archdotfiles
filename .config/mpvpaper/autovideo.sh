#!/bin/bash

# Change to the script directory
cd ~/.config/mpvpaper

pkill mpvpaper

# Directory containing wallpapers
WALLPAPERS="$HOME/Desktop/videowallpaper"
LOGFILE="$HOME/.config/mpvpaper/logfile.txt"

# Create the logfile if it doesn't exist
if [ ! -f "$LOGFILE" ]; then
    touch "$LOGFILE"
fi

# Populate the logfile with filenames if it's empty
if [ ! -s "$LOGFILE" ]; then
    ls "$WALLPAPERS"/* | sed "s|$WALLPAPERS/||" > "$LOGFILE"
fi

# Pick a filename at random from the logfile
FILE_TO_PLAY=$(shuf -n 1 "$LOGFILE")

# Full path of the selected file
FILE_PATH="$WALLPAPERS/$FILE_TO_PLAY"

# Set the wallpaper using mpvpaper
mpvpaper -o "no-audio loop" '*' "$FILE_PATH" --sub-fps=60

# Remove the chosen filename from the logfile
grep -v "^$FILE_TO_PLAY$" "$LOGFILE" > "$LOGFILE.tmp"
mv "$LOGFILE.tmp" "$LOGFILE"

# Check if logfile is empty and refill it if necessary
if [ ! -s "$LOGFILE" ]; then
    # Refill the logfile with all filenames from the directory
    ls "$WALLPAPERS"/* | sed "s|$WALLPAPERS/||" > "$LOGFILE"
fi

# Ensure there is no empty line left in the logfile
sed -i '/^$/d' "$LOGFILE"

exit
