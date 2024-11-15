#!/bin/bash

ICON_STATE_FILE="/tmp/i3blocks_icon_state"

CURRENT_STATE=$(cat "$ICON_STATE_FILE" 2>/dev/null || echo 1)

if [[ $CURRENT_STATE -eq 2 ]]; then
    redshift -l 24.7335773514906:-53.71932206893908 -o -P &
fi
