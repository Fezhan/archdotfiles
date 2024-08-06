#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <YouTube_URL>"
    exit 1
fi

# Set the URL provided as the first argument
url=$1

# Define the download command
download_command="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]' $url -o '/home/faiyaz/Desktop/videowallpaper/%(title)s.%(ext)s'"

# Execute the download command
eval $download_command

# Exit the script
exit 0

