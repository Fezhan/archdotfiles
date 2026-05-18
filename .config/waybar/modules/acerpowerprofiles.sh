#!/usr/bin/env bash

PROFILE_FILE="/sys/firmware/acpi/platform_profile"
CHOICES_FILE="/sys/firmware/acpi/platform_profile_choices"

# ------------------------------
# Detect battery state
# ------------------------------
on_battery() {
    if grep -q "0" /sys/class/power_supply/AC*/online 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# ------------------------------
# Current profile
# ------------------------------
get_current() {
    cat "$PROFILE_FILE"
}

# ------------------------------
# Get firmware supported profiles
# ------------------------------
get_choices() {
    cat "$CHOICES_FILE"
}

# ------------------------------
# Cycle profiles
# ------------------------------
cycle() {

    current=$(get_current)

    # read supported profiles
    read -ra all_profiles <<< "$(get_choices)"

    # restrict on battery
    if on_battery; then
        profiles=()
        for p in "${all_profiles[@]}"; do
            if [[ "$p" == "low-power" || "$p" == "balanced" ]]; then
                profiles+=("$p")
            fi
        done
    else
        profiles=("${all_profiles[@]}")
    fi

    # find next profile
    for i in "${!profiles[@]}"; do
        if [[ "${profiles[$i]}" == "$current" ]]; then
            next_index=$(( (i + 1) % ${#profiles[@]} ))
            next="${profiles[$next_index]}"
            break
        fi
    done

    # fallback
    [[ -z "$next" ]] && next="balanced"

    # don't rewrite same profile
    if [[ "$next" == "$current" ]]; then
        return
    fi

    # retry firmware write (Acer sometimes refuses first attempt)
    for i in {1..3}; do
        if echo "$next" | sudo tee /sys/firmware/acpi/platform_profile >/dev/null 2>&1; then
            break
        fi
        sleep 0.2
    done
}

# ------------------------------
# Waybar output
# ------------------------------
print_status() {

    current=$(get_current)

    case "$current" in
        low-power)
            icon="󰌪"
            ;;
        balanced)
            icon=""
            ;;
        balanced-performance)
            current="performance"
            icon=""
            ;;
        *)
            icon=""
            ;;
    esac

    echo "{\"text\":\"$icon\",\"alt\":\"$current\",\"tooltip\":\"$current\"}"
}

# ------------------------------
# Entry point
# ------------------------------
case "$1" in
    toggle)
        cycle
        print_status
        ;;
    *)
        print_status
        ;;
esac
