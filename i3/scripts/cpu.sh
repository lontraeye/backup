#!/bin/bash
# Open htop in kitty terminal if the left mouse button is clicked (BLOCK_BUTTON=1)
if [[ "$BLOCK_BUTTON" == 1 ]]; then
    kitty -e htop
fi

# Calculate CPU usage and display it as a percentage
cpu_usage=$((100 - $(vmstat 1 2 | tail -1 | awk '{print $15}')))
echo " ${cpu_usage}%"