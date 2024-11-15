#!/bin/bash
STATE_FILE=/tmp/powerprofile
ICON_ECO="  Eco"
ICON_BALANCED="  Blc"
ICON_PERFORMANCE="  Pro"

# Initialize state file if it doesn't exist
if ! [[ -f $STATE_FILE ]]; then
    echo 2 > $STATE_FILE
    powerprofilesctl set performance
fi

# Read the current profile state
CURRENT_PROFILE=$(cat $STATE_FILE)

# Rotate power profiles if clicked
if [[ $BLOCK_BUTTON == 1 ]]; then
    case $CURRENT_PROFILE in
        0)
            echo 1 > $STATE_FILE
            echo "$ICON_BALANCED"
            powerprofilesctl set balanced
            ;;
        1)
            echo 2 > $STATE_FILE
            echo "$ICON_PERFORMANCE"
            powerprofilesctl set performance
            ;;
        2)
            echo 0 > $STATE_FILE
            echo "$ICON_ECO"
            powerprofilesctl set power-saver
            ;;
    esac
else
    # Display the current profile icon
    case $CURRENT_PROFILE in
        0) echo "$ICON_ECO" ;;
        1) echo "$ICON_BALANCED" ;;
        2) echo "$ICON_PERFORMANCE" ;;
    esac
fi