#!/bin/bash
DISPLAY_MODE=0
SCRIPT_PATH="$HOME/.config/i3/scripts/ora.sh"

# Toggle the value of DISPLAY_MODE and update the script file
toggle_display_mode() {
    if [ "$DISPLAY_MODE" -eq 0 ]; then
        sed -i '2d' "$SCRIPT_PATH"
        sed -i '2iDISPLAY_MODE=1' "$SCRIPT_PATH"
        DISPLAY_MODE=1
    else
        sed -i '2d' "$SCRIPT_PATH"
        sed -i '2iDISPLAY_MODE=0' "$SCRIPT_PATH"
        DISPLAY_MODE=0
    fi
}

# Toggle on mouse click (BLOCK_BUTTON 1)
if [ "$BLOCK_BUTTON" -eq 1 ]; then
    toggle_display_mode
fi

# Display date based on DISPLAY_MODE's value
if [ "$DISPLAY_MODE" -eq 0 ]; then
    date '+%a %d %b %H:%M'
else
    date '+%H:%M'
fi
