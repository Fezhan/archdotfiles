#!/bin/bash

pkill mpvpaper

# Predefined variables
videos_folder="/home/faiyaz/Desktop/videowallpaper"
current_folder="/home/faiyaz/Desktop/currentvideo"
log_file="${current_folder}/wallpaper_log.txt"

# Check if log file directory exists, create it if not
if [ ! -d "$(dirname "$log_file")" ]; then
    mkdir -p "$(dirname "$log_file")"
fi

# Check if log file exists, create it if not
if [ ! -f "$log_file" ]; then
    touch "$log_file"
fi

# Read the current wallpaper index from the log file
current_index=$(cat "$log_file" 2>/dev/null || echo 0)

# Get the total number of wallpapers
wallpapers=("$videos_folder"/*)

total_wallpapers=${#wallpapers[@]}

# Calculate the next wallpaper index
next_index=$(( (current_index + 1) % total_wallpapers ))

# Update log file with the new index
echo "$next_index" > "$log_file"

# Get the next wallpaper file
next_wallpaper="${wallpapers[$next_index]}"

echo $next_wallpaper

# Print the command to set the wallpaper
mpvpaper '*' "$next_wallpaper"

wait

kill $(ps aux | grep mpvpaper | awk '{print $2}')

