#!/bin/bash
NIGHT_TEMP=3000
STATE_FILE="/tmp/redshift_state"
AUTO_NIGHT_FILE="/tmp/redshift_auto_night"

# Initialize state file if it doesn't exist
if ! [[ -f $STATE_FILE ]]; then
    echo "day" > $STATE_FILE
fi

CURRENT_STATE=$(cat $STATE_FILE) # Read the current state
HOUR=$(date +%H) # Get the current hour

# Automatically switch to night mode after 18:00 if still in "day" mode and night hasn't been manually disabled
if [ "$CURRENT_STATE" == "day" ] && ([ "$HOUR" -ge 18 ] || [ "$HOUR" -lt 7 ]) && ! [[ -f $AUTO_NIGHT_FILE ]]; then
    redshift -O $NIGHT_TEMP -b 0.8
    echo "night" > $STATE_FILE
    touch $AUTO_NIGHT_FILE
fi

# Determine the icon based on the current state
if [[ "$CURRENT_STATE" == "night" ]]; then
    echo "🌙"
else
    echo "☀️"
fi

# Click handling (button 1 is the left mouse button)
case "$BLOCK_BUTTON" in
    1)
        if [ "$CURRENT_STATE" == "day" ]; then
            redshift -O $NIGHT_TEMP -b 0.8
            echo "night" > $STATE_FILE
        else
            redshift -x
            echo "day" > $STATE_FILE
        fi
        ;;
esac