#!/bin/bash
# Create a mechanism to change timer mode (modifica)
PATH_TO_TIMER="/tmp/miotimer"

modify() {
    if [ "$BLOCK_BUTTON" == 4 ]; then
        CURRENT=$((CURRENT + 1))
        echo "$MODE" > "$PATH_TO_TIMER"
        echo "$CURRENT" >> "$PATH_TO_TIMER"
    fi

    if [ "$BLOCK_BUTTON" == 5 ] && [ "$CURRENT" != 0 ]; then
        CURRENT=$((CURRENT - 1))
        echo "$MODE" > "$PATH_TO_TIMER"
        echo "$CURRENT" >> "$PATH_TO_TIMER"
    fi

    if [ "$CURRENT" == 0 ]; then
        echo "󰔛 Tmr"
    else
        echo " $(sed '2!d' "$PATH_TO_TIMER") m"
        echo ""
        echo "#f9e2af"
    fi
}

timer() {
    START=$(sed '2!d' "$PATH_TO_TIMER")
    START=$((START * 60))
    NOW=$(date +%s)
    FIRST=$(sed '3!d' "$PATH_TO_TIMER")
    REMAINING=$((START - NOW + FIRST))

    if [ "$REMAINING" != 0 ]; then
        echo "󰄉 $((REMAINING / 60)):$((REMAINING % 60))"
        echo ""
        echo "#a6e3a1"
    else
        echo "󰔛 Tmr"
        notify-send "Timer is over"
        rm "$PATH_TO_TIMER"
    fi
}

if [ -f "$PATH_TO_TIMER" ]; then
    MODE=$(sed '1!d' "$PATH_TO_TIMER")
    CURRENT=$(sed '2!d' "$PATH_TO_TIMER")

    if [ "$BLOCK_BUTTON" == 1 ] && [ "$CURRENT" != 0 ]; then
        if [ "$MODE" == "w" ]; then
            rm "$PATH_TO_TIMER"
            echo "󰔛 Tmr"
            exit
        fi
        MODE="w"
        echo "$MODE" > "$PATH_TO_TIMER"
        echo "$CURRENT" >> "$PATH_TO_TIMER"
        echo "$(date +%s)" >> "$PATH_TO_TIMER"
    fi

    if [ "$MODE" == "m" ]; then
        modify
    fi

    if [ "$MODE" == "w" ]; then
        timer
    fi
else
    echo "m" > "$PATH_TO_TIMER"
    echo "0" >> "$PATH_TO_TIMER"
    echo "󰔛 Tmr"
fi
