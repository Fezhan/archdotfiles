#!/bin/bash

available_profiles="/sys/firmware/acpi/platform_profile"

all_profiles=(
    "low-power"
    "quiet"
    "balanced"
    "balanced-performance"
)

# Detect if on battery
on_battery() {
    # Check AC adapter status
    if grep -q "0" /sys/class/power_supply/AC*/online 2>/dev/null; then
        return 0  # on battery
    else
        return 1  # on AC
    fi
}

get_current() {
    cat "$available_profiles"
}

cycle() {
    current=$(get_current)

    # Decide which profiles to use
    if on_battery; then
        profiles=( "low-power" "balanced" )
    else
        profiles=( "${all_profiles[@]}" )
    fi

    # Cycle through the selected profiles
    for i in "${!profiles[@]}"; do
        if [[ "${profiles[$i]}" == "$current" ]]; then
            next_index=$(( (i + 1) % ${#profiles[@]} ))
            next="${profiles[$next_index]}"
            echo "$next" | sudo tee "$available_profiles" >/dev/null
            exit
        fi
    done

    # Default to balanced if current profile not found
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