#!/bin/bash

pkill mpvpaper

# Set the path to the wallpapers directory
wallpapersDir="/home/faiyaz/Desktop/wallpapers"

# Get a list of all image files in the wallpapers directory
wallpapers=("$wallpapersDir"/*)

# Check if the wallpapers array is empty
if [ ${#wallpapers[@]} -eq 0 ]; then
    echo "No wallpapers found in the specified directory."
    exit 1
fi

# Run the swww query command to get information about the current wallpaper
queryOutput=$(swww query)

# Extract the first line from the query output
currentWallpaper=$(echo "$queryOutput" | head -n 1)

# Slice off the first 58 characters to get the current wallpaper
currentWallpaper=${currentWallpaper:57}

index=-1
for ((i=0; i<${#wallpapers[@]}; i++)); do
    if [ "${wallpapers[i]}" == "$currentWallpaper" ]; then
        index=$((i+1))
        break
    fi
done

# Check if the current wallpaper was found in the wallpapers array
if [ $index -ne -1 ]; then
    # Update the wallpaper using the swww img command
    swww img """${wallpapers[$index]}""" --transition-fps 60 --transition-type any --transition-duration 1.0
else
    swww img """${wallpapers[0]}""" --transition-fps 60 --transition-type any --transition-duration 1.0
fi
