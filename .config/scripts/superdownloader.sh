#!/bin/bash
# ============================================
# yt-dlp interactive wrapper
# Run with no arguments; you'll be prompted.
# - Prompts for URL
# - Prompts for output directory (creates if missing)
# - Prompts for video+audio or audio-only
# - Prompts for output format (mp4, mkv, mp3, etc.)
# - Scans the script's folder for *.txt cookie files and lets you pick by number
#
# Dependencies: yt-dlp (and optionally aria2c for faster downloads)
# ============================================

set -euo pipefail

# Resolve the directory where this script lives
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "=== yt-dlp interactive downloader ==="

# --- Prompt: URL ---
while :; do
  read -r -p "Enter video/playlist URL: " URL
  [[ -n "${URL}" ]] && break
  echo "URL cannot be empty."
done

# --- Prompt: Output directory ---
DEFAULT_OUT="${HOME}/Downloads"
read -r -p "Enter output directory [${DEFAULT_OUT}]: " OUTPUT_DIRECTORY
OUTPUT_DIRECTORY="${OUTPUT_DIRECTORY:-$DEFAULT_OUT}"
mkdir -p -- "$OUTPUT_DIRECTORY"

# --- Prompt: Video or Audio ---
echo
echo "Download type:"
echo "  1) Video + Audio"
echo "  2) Audio only"

while :; do
  read -r -p "Select [1-2]: " MODE
  [[ "$MODE" =~ ^[12]$ ]] && break
  echo "Invalid selection."
done

# --- Prompt: Format ---
if [[ "$MODE" == "1" ]]; then
  echo
  echo "Video formats:"
  echo "  1) mp4"
  echo "  2) mkv"
  echo "  3) webm"

  while :; do
    read -r -p "Choose format [1-3]: " FMT
    case "$FMT" in
      1) FORMAT="mp4"; break ;;
      2) FORMAT="mkv"; break ;;
      3) FORMAT="webm"; break ;;
      *) echo "Invalid selection." ;;
    esac
  done
else
  echo
  echo "Audio formats:"
  echo "  1) mp3"
  echo "  2) m4a"
  echo "  3) opus"
  echo "  4) wav"

  while :; do
    read -r -p "Choose format [1-4]: " FMT
    case "$FMT" in
      1) FORMAT="mp3"; break ;;
      2) FORMAT="m4a"; break ;;
      3) FORMAT="opus"; break ;;
      4) FORMAT="wav"; break ;;
      *) echo "Invalid selection." ;;
    esac
  done
fi

# --- Detect cookie files ---
mapfile -t COOKIE_CANDIDATES < <(find "$SCRIPT_DIR" -maxdepth 1 -type f -name "*.txt" -printf "%f\n" | sort)

echo
echo "Cookie files in script directory: $SCRIPT_DIR"
if [[ ${#COOKIE_CANDIDATES[@]} -eq 0 ]]; then
  echo "  (none found — continuing without cookies)"
  COOKIES_FILE=""
else
  echo "  0) No cookies (skip)"
  for i in "${!COOKIE_CANDIDATES[@]}"; do
    printf "  %d) %s\n" "$((i+1))" "${COOKIE_CANDIDATES[$i]}"
  done

  while :; do
    read -r -p "Select cookies file by number or press Enter to skip: " choice
    if [[ -z "$choice" || "$choice" == "0" ]]; then
      COOKIES_FILE=""
      break
    elif [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#COOKIE_CANDIDATES[@]} )); then
      COOKIES_FILE="$SCRIPT_DIR/${COOKIE_CANDIDATES[$((choice-1))]}"
      break
    else
      echo "Invalid selection."
    fi
  done
fi

echo
echo "=== Summary ==="
echo "URL:              $URL"
echo "Output directory: $OUTPUT_DIRECTORY"
echo "Mode:             $([[ "$MODE" == "1" ]] && echo "Video + Audio" || echo "Audio only")"
echo "Format:           $FORMAT"
[[ -n "${COOKIES_FILE:-}" ]] && echo "Cookies file:     $COOKIES_FILE" || echo "Cookies file:     (none)"
echo

# --- Build yt-dlp command ---
declare -a CMD
CMD=( yt-dlp
      -o "$OUTPUT_DIRECTORY/%(title)s.%(ext)s"
      -N 8
      --external-downloader aria2c
      --external-downloader-args 'aria2c:-x8 -s8 -k1M --auto-file-renaming=false'
)

# Mode-specific flags
if [[ "$MODE" == "1" ]]; then
  CMD+=( -f "bv*+ba/b" --merge-output-format "$FORMAT" )
else
  CMD+=( -x --audio-format "$FORMAT" )
fi

# Cookies
if [[ -n "${COOKIES_FILE:-}" ]]; then
  CMD+=( --cookies "$COOKIES_FILE" )
fi

CMD+=( "$URL" )

# Show and run
echo "Running:"
printf '  %q ' "${CMD[@]}"
echo -e "\n"

"${CMD[@]}"

echo
echo "✅ Download complete!"
echo "Saved to: $OUTPUT_DIRECTORY"

