#!/usr/bin/env bash

PROFILE_FILE="/sys/firmware/acpi/platform_profile"
CHOICES_FILE="/sys/firmware/acpi/platform_profile_choices"

# ------------------------------
# Detect battery state (robust)
# ------------------------------
on_battery() {
    for f in /sys/class/power_supply/*/online; do
        [[ -f "$f" ]] || continue
        if [[ "$(cat "$f")" == "1" ]]; then
            return 1  # AC power connected
        fi
    done
    return 0  # no AC detected -> battery
}

# ------------------------------
# Current profile
# ------------------------------
get_current() {
    cat "$PROFILE_FILE" 2>/dev/null
}

# ------------------------------
# Get firmware supported profiles
# ------------------------------
get_choices() {
    cat "$CHOICES_FILE" 2>/dev/null
}

# ------------------------------
# Cycle profiles
# ------------------------------
cycle() {
    local current next=""
    current="$(get_current)"

    # Read profiles safely (sysfs is whitespace-separated in most cases)
    mapfile -t all_profiles < "$CHOICES_FILE" 2>/dev/null

    # Fallback if mapfile fails
    if [[ ${#all_profiles[@]} -eq 0 ]]; then
        read -r -a all_profiles <<< "$(get_choices)"
    fi

    # Restrict profiles on battery
    local profiles=()

    if on_battery; then
        for p in "${all_profiles[@]}"; do
            if [[ "$p" == "low-power" || "$p" == "balanced" ]]; then
                profiles+=("$p")
            fi
        done
    else
        profiles=("${all_profiles[@]}")
    fi

    # Safety fallback if filtering removed everything
    if [[ ${#profiles[@]} -eq 0 ]]; then
        profiles=("balanced")
    fi

    # Find next profile
    for i in "${!profiles[@]}"; do
        if [[ "${profiles[$i]}" == "$current" ]]; then
            local next_index=$(( (i + 1) % ${#profiles[@]} ))
            next="${profiles[$next_index]}"
            break
        fi
    done

    # Fallback if current not found
    [[ -z "$next" ]] && next="balanced"

    # No-op if same
    [[ "$next" == "$current" ]] && return

    # Retry write (firmware can be stubborn)
    for _ in {1..3}; do
        if echo "$next" | sudo tee "$PROFILE_FILE" >/dev/null 2>&1; then
            break
        fi
        sleep 0.2
    done
}

# ------------------------------
# Waybar output
# ------------------------------
print_status() {
    local current icon

    current="$(get_current)"

    case "$current" in
        low-power)
            icon="󰌪"
            ;;
        balanced)
            icon=""
            ;;
        balanced-performance|performance)
            current="performance"
            icon=""
            ;;
        *)
            icon=""
            ;;
    esac

    printf '{"text":"%s","alt":"%s","tooltip":"%s"}\n' \
        "$icon" "$current" "$current"
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
