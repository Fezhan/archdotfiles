#!/bin/bash

# Check if at least one sink name is provided
if [ $# -lt 1 ]; then
  echo "Usage: $0 <sink1> <sink2> [sink3] ... [sinkN]"
  pactl list sinks short
  exit 1
fi

# Join all the provided sink names with commas
SINKS=$(IFS=,; echo "$*")

# Load the module-combine-sink with the provided sinks
pactl load-module module-combine-sink slaves="$SINKS"

# Check if the command was successful
if [ $? -eq 0 ]; then
  echo "Combined sink created successfully with sinks: $SINKS"
else
  echo "Failed to create combined sink."
  exit 1
fi

