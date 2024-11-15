#!/bin/bash

ICON_STATE_FILE="/tmp/i3blocks_icon_state"

if [ ! -f "$ICON_STATE_FILE" ]; then
    echo 1 > "$ICON_STATE_FILE"
fi

CURRENT_STATE=$(cat "$ICON_STATE_FILE")

ICON1="☀️"
ICON2="🌙"
ICON3="🌗"

kill_redshift() {
    pkill -f redshift
}

case $CURRENT_STATE in
    1)
        echo 2 > "$ICON_STATE_FILE"
        echo "$ICON2"

	redshift -O 5000 &
        ;;
    2)
        echo 3 > "$ICON_STATE_FILE"
        echo "$ICON3"

	redshift -l 24.7335773514906:-53.71932206893908 -o &
        ;;
    3)
        echo 1 > "$ICON_STATE_FILE"
        echo "$ICON1"
  	pkill -f redshif
        redshift -x &
        ;;
esac

