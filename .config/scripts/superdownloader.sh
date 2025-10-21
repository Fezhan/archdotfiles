#!/bin/bash
# ============================================
# yt-dlp interactive wrapper
# Run with no arguments; you'll be prompted.
# - Prompts for URL
# - Prompts for output directory (creates if missing)
# - Scans the script's folder for *.txt cookie files and lets you pick by number
#
# Dependencies: yt-dlp (and optionally aria2c for faster downloads)
# ============================================

set -euo pipefail

# Resolve the directory where this script lives (handles symlinks/sourced calls)
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "=== yt-dlp interactive downloader ==="

# --- Prompt: URL ---
while :; do
  read -r -p "Enter video/playlist URL: " URL
  [[ -n "${URL}" ]] && break
  echo "URL cannot be empty."
done

# --- Prompt: Output directory ---
DEFAULT_OUT="${HOME}/Videos"
read -r -p "Enter output directory [${DEFAULT_OUT}]: " OUTPUT_DIRECTORY
OUTPUT_DIRECTORY="${OUTPUT_DIRECTORY:-$DEFAULT_OUT}"

# Create output directory if needed
mkdir -p -- "$OUTPUT_DIRECTORY"

# --- Prompt: Cookies file selection from script dir ---
# Build the list of .txt files in the script's directory
mapfile -t COOKIE_CANDIDATES < <(find "$SCRIPT_DIR" -maxdepth 1 -type f -name "*.txt" -printf "%f\n" | sort)

echo
echo "Cookie files in script directory: $SCRIPT_DIR"
if [[ ${#COOKIE_CANDIDATES[@]} -eq 0 ]]; then
  echo "  (none found)"
  echo "You can proceed without cookies or place a cookies export (*.txt) next to this script."
  COOKIES_FILE=""
else
  echo "  0) No cookies"
  for i in "${!COOKIE_CANDIDATES[@]}"; do
    printf "  %d) %s\n" "$((i+1))" "${COOKIE_CANDIDATES[$i]}"
  done

  while :; do
    read -r -p "Select cookies file by number (0 for none): " choice
    if [[ "$choice" =~ ^[0-9]+$ ]]; then
      if (( choice == 0 )); then
        COOKIES_FILE=""
        break
      elif (( choice >= 1 && choice <= ${#COOKIE_CANDIDATES[@]} )); then
        COOKIES_FILE="$SCRIPT_DIR/${COOKIE_CANDIDATES[$((choice-1))]}"
        break
      fi
    fi
    echo "Invalid selection. Try again."
  done
fi

echo
echo "=== Summary ==="
echo "URL:              $URL"
echo "Output directory: $OUTPUT_DIRECTORY"
if [[ -n "${COOKIES_FILE:-}" ]]; then
  echo "Cookies file:     $COOKIES_FILE"
else
  echo "Cookies file:     (none)"
fi
echo

# --- Build yt-dlp command ---
# Common args
declare -a CMD
CMD=( yt-dlp
      -o "$OUTPUT_DIRECTORY/%(title)s.%(ext)s"
      -f "bv*+ba/b"
      --merge-output-format mp4
      -N 8
      --external-downloader aria2c
      --external-downloader-args 'aria2c:-x8 -s8 -k1M --auto-file-renaming=false'
)

# Add cookies if provided
if [[ -n "${COOKIES_FILE:-}" ]]; then
  CMD+=( --cookies "$COOKIES_FILE" )
fi

# Finally, add the URL
CMD+=( "$URL" )

# Show and run
echo "Running:"
printf '  %q ' "${CMD[@]}"
echo
echo

"${CMD[@]}"

echo
echo "✅ Download complete!"
echo "Saved to: $OUTPUT_DIRECTORY"

