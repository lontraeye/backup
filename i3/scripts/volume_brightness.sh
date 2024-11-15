#!/bin/bash
# Original source: https://gitlab.com/Nmoleo/i3-volume-brightness-indicator
# Taken from here: https://gitlab.com/Nmoleo/i3-volume-brightness-indicator

# See README.md for usage instructions
BAR_COLOR="#a6da95"
VOLUME_STEP=5
BRIGHTNESS_STEP=5%
MAX_VOLUME=100

# Uses regex to get volume from pactl
function get_volume {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

# Uses regex to get mute status from pactl
function get_mute {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}

# Uses regex to get brightness from xbacklight
function get_brightness {
    brightnessctl g | grep -Po '[0-9]{1,3}' | head -n 1
}

# Returns a mute icon, a volume-low icon, or a volume-high icon, depending on the volume
function get_volume_icon {
    VOLUME=$(get_volume)
    MUTE=$(get_mute)
    
    if [ "$VOLUME" -eq 0 ] || [ "$MUTE" == "yes" ]; then
        VOLUME_ICON="󰸈  "
    elif [ "$VOLUME" -lt 50 ]; then
        VOLUME_ICON="󰕾  "
    else
        VOLUME_ICON="  "
    fi
}

# Always returns the same icon - I couldn't get the brightness-low icon to work with FontAwesome
function get_brightness_icon {
    BRIGHTNESS_ICON="  "
}

# Displays a volume notification using dunstify
function show_volume_notif {
    VOLUME=$(get_volume)
    get_volume_icon
    dunstify -t 1000 -r 2593 -u normal "$VOLUME_ICON $VOLUME%" -h int:value:$VOLUME -h string:hlcolor:$BAR_COLOR
}

# Displays a brightness notification using dunstify
function show_brightness_notif {
    MAXIMA=$(brightnessctl m)
    BRIGHTNESS=$(($(get_brightness) * 100 / $MAXIMA))
    get_brightness_icon
    dunstify -t 1000 -r 2593 -u normal "$BRIGHTNESS_ICON $BRIGHTNESS%" -h int:value:$BRIGHTNESS -h string:hlcolor:$BAR_COLOR
}

# Main function - Takes user input, "volume_up", "volume_down", "brightness_up", or "brightness_down"
case $1 in
    volume_up)
        # Unmutes and increases volume, then displays the notification
        pactl set-sink-mute @DEFAULT_SINK@ 0
        VOLUME=$(get_volume)
        if [ $(("$VOLUME" + "$VOLUME_STEP")) -gt $MAX_VOLUME ]; then
            pactl set-sink-volume @DEFAULT_SINK@ $MAX_VOLUME%
        else
            pactl set-sink-volume @DEFAULT_SINK@ +$VOLUME_STEP%
        fi
        show_volume_notif
        ;;

    volume_down)
        # Decreases volume and displays the notification
        pactl set-sink-volume @DEFAULT_SINK@ -$VOLUME_STEP%
        show_volume_notif
        ;;

    volume_mute)
        # Toggles mute and displays the notification
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        show_volume_notif
        ;;

    brightness_up)
        # Increases brightness and displays the notification
        brightnessctl s +$BRIGHTNESS_STEP
        show_brightness_notif
        ;;

    brightness_down)
        # Decreases brightness and displays the notification
        brightnessctl s $BRIGHTNESS_STEP-
        show_brightness_notif
        ;;
esac