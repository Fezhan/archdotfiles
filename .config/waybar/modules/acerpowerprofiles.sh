#!/usr/bin/env bash

PROFILE_FILE="/sys/firmware/acpi/platform_profile"
CHOICES_FILE="/sys/firmware/acpi/platform_profile_choices"

# ------------------------------
# Detect battery state (Optimized & Fast)
# ------------------------------
on_battery() {
    # If any online file reports 1, we are on AC power
    grep -q "1" /sys/class/power_supply/*/online 2>/dev/null && return 1
    return 0  # No online AC source found -> Battery
}

# ------------------------------
# Current profile
# ------------------------------
get_current() {
    cat "$PROFILE_FILE" 2>/dev/null || echo "balanced"
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

    # Fix: Safely parse space-separated list into an array
    local -a all_profiles
    read -r -a all_profiles <<< "$(get_choices)"

    # Restrict profiles on battery (And completely drop broken "quiet" profile)
    local -a profiles=()
    if on_battery; then
        for p in "${all_profiles[@]}"; do
            if [[ "$p" == "low-power" || "$p" == "balanced" ]]; then
                profiles+=("$p")
            fi
        done
    else
        for p in "${all_profiles[@]}"; do
            if [[ "$p" != "quiet" ]]; then
                profiles+=("$p")
            fi
        done
    fi

    # Safety fallback if filtering removed everything
    [[ ${#profiles[@]} -eq 0 ]] && profiles=("balanced")

    # Find next profile
    for i in "${!profiles[@]}"; do
        if [[ "${profiles[$i]}" == "$current" ]]; then
            local next_index=$(( (i + 1) % ${#profiles[@]} ))
            next="${profiles[$next_index]}"
            break
        fi
    done

    # Fallback if current not found
    [[ -z "$next" ]] && next="${profiles[0]}"

    # No-op if same
    [[ "$next" == "$current" ]] && return

    # Retry write using pkexec (Wayland background execution safe)
    for _ in {1..3}; do
        if echo "$next" | pkexec tee "$PROFILE_FILE" >/dev/null 2>&1; then
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
