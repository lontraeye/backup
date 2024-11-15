#!/bin/bash

# File to store the tray toggle state
TRAY_FILE="/tmp/tray"

# Initialize or toggle the tray state
if [[ -f "$TRAY_FILE" ]]; then
    var=$(<"$TRAY_FILE")
else
    var=0
fi

# Toggle state between 0 and 1
if [[ "$var" == 1 ]]; then
    echo 0 > "$TRAY_FILE"
    i3-msg -q "bar mode dock bar-tray"
    i3-msg -q "bar mode invisible bar-primary"
else
    echo 1 > "$TRAY_FILE"
    i3-msg -q "bar mode invisible bar-tray"
    i3-msg -q "bar mode dock bar-primary"
fi