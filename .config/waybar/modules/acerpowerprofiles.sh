#!/bin/bash

available_profiles="/sys/firmware/acpi/platform_profile"

profiles=(
    "low-power"
    "quiet"
    "balanced"
    "balanced-performance"
)

get_current() {
    cat "$available_profiles"
}

cycle() {
    current=$(get_current)

    for i in "${!profiles[@]}"; do
    if [[ "${profiles[$i]}" == "$current" ]]; then
      next_index=$(( (i + 1) % ${#profiles[@]} ))
      next="${profiles[$next_index]}"
      echo "$next" | sudo tee "$available_profiles" >/dev/null
      exit
    fi
  done

  echo "balanced" | sudo tee "$available_profiles" >/dev/null
}

print_status() {
  current=$(get_current)

  case "$current" in
    low-power)
      icon="󰌪"
      ;;
    quiet)
      icon=""
      ;;
    balanced)
      icon=""
      ;;
    balanced-performance)
      current="performance"
      icon=""
      ;;
    *)
      icon="?"
      ;;
  esac

  echo "{\"text\": \"$icon\", \"alt\": \"$current\", \"tooltip\": \"$current\"}"
}

case "$1" in
  toggle)
    cycle
    print_status
    ;;
  *)
    print_status
    ;;
esac