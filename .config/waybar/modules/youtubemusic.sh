#!/bin/bash

# Function to find the Chromium player name
find_chromium_player() {
    playerctl -l
}

# Get the Chromium player name
player=$(find_chromium_player)

if [ "$player" = "No players found" ]; then
    # If no Chromium player found, exit
    echo -e "{\"text\":\"\", \"class\":\"\"}"
    exit 0
fi

class=$(playerctl metadata --player= --format '{{lc(status)}}')
icon="\uf16a "

if [[ $class == "playing" ]]; then
    info=$(playerctl metadata --player= --format '{{title}} - {{artist}}')
    if [[ ${#info} > 40 ]]; then
        info=$(echo "$info" | cut -c1-40)"..."
    fi
    text=$icon"  "$info
elif [[ $class == "paused" ]]; then
    text=$icon"  "$class
elif [[ $class == "stopped" ]]; then
    text=$icon"  "$stopped
fi

echo -e "{\"text\":\""$text"\", \"class\":\""$class"\"}"

