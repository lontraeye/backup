#!/usr/bin/env bash
# Displays the default device, volume, and mute status for i3blocks using PipeWire

AUDIO_HIGH_SYMBOL='  '
AUDIO_MED_SYMBOL='  '
AUDIO_LOW_SYMBOL='  '
AUDIO_MUTED_SYMBOL='  '
AUDIO_DELTA=5

DEFAULT_COLOR="#ffffff"
MUTED_COLOR="#a0a0a0"

LONG_FORMAT='${SYMB} ${VOL}% [${INDEX}:${NAME}]'
SHORT_FORMAT='${SYMB} ${VOL}% [${INDEX}]'

# Function to move all sink inputs to a new default sink
function move_sinks_to_new_default {
    DEFAULT_SINK=$1
    pactl list sink-inputs short | awk '{print $1}' | while read SINK; do
        pactl move-sink-input "$SINK" "$DEFAULT_SINK"
    done
}

# Function to cycle through playback devices
function set_default_playback_device_next {
    inc=${1:-1}
    num_devices=$(pactl list sinks short | wc -l)
    sink_arr=($(pactl list sinks short | awk '{print $1}'))
    default_sink=$(pactl get-default-sink)
    default_sink_index=$(for i in "${!sink_arr[@]}"; do [[ "${sink_arr[$i]}" = "${default_sink}" ]] && echo "$i"; done)
    default_sink_index=$(( (default_sink_index + num_devices + inc) % num_devices ))
    default_sink=${sink_arr[$default_sink_index]}
    pactl set-default-sink "$default_sink"
    move_sinks_to_new_default "$default_sink"
}

# Function to get volume and mute state
function get_volume_info {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -o "[0-9]*%" | head -1 | tr -d '%'
    pactl get-sink-mute @DEFAULT_SINK@ | grep -o "yes\|no"
}

case "$BLOCK_BUTTON" in
    1) set_default_playback_device_next ;;
    2) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    3) set_default_playback_device_next -1 ;;
    4) pactl set-sink-volume @DEFAULT_SINK@ +${AUDIO_DELTA}% ;;
    5) pactl set-sink-volume @DEFAULT_SINK@ -${AUDIO_DELTA}% ;;
esac

function print_block {
    VOL=$(get_volume_info | sed -n '1p')
    MUTED=$(get_volume_info | sed -n '2p')
    SYMB=$AUDIO_HIGH_SYMBOL

    [[ $VOL -le 50 ]] && SYMB=$AUDIO_MED_SYMBOL
    [[ $VOL -le 0 ]] && SYMB=$AUDIO_LOW_SYMBOL
    [[ $MUTED == "yes" ]] && SYMB=$AUDIO_MUTED_SYMBOL

    COLOR=$DEFAULT_COLOR
    [[ $MUTED == "yes" ]] && COLOR=$MUTED_COLOR

    echo "<span color=\"$COLOR\">$SYMB $VOL%</span>"
}

print_block

