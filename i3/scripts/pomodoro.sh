#!/bin/bash

# Paths and file variables
POMO_TIMER_PATH="/tmp/pomo_timer"
POM_FILE_PATH="/tmp/pomodoro"
BELL_SOUND_PATH="$HOME/.config/i3/scripts/bell.wav"
BELL_END_SOUND_PATH="$HOME/.config/i3/scripts/bell_end.wav"
TIMER_SCRIPT_PATH="$HOME/.config/i3/scripts/timer.sh"

# Configuration variables
WORK_DURATION=2400 # 40 minutes in seconds
BREAK_DURATION=600 # 10 minutes in seconds
MSG_START=" Pom"
WORK_PREFIX=" "
BREAK_PREFIX="󰅶 "
START_COLOR="#cdd6f4"
BREAK_COLOR="#a6e3a1"
WORK_COLOR="#f38ba8"
BREAK_NOTIFICATION="notify-send -t 2500 'Grab a tea'"
WORK_NOTIFICATION="notify-send -t 2500 'Time to work!'"

# Read initial timer state
if [ -f "$POMO_TIMER_PATH" ]; then
    TIMER_STATE=$(cat "$POMO_TIMER_PATH")

    # Toggle timer state on right-click (BLOCK_BUTTON 3)
    case $BLOCK_BUTTON in
        3)
            if [ "$TIMER_STATE" -eq 0 ]; then
                echo "1" > "$POMO_TIMER_PATH"
                TIMER_STATE=1
            else
                echo "0" > "$POMO_TIMER_PATH"
                TIMER_STATE=0
            fi
            ;;
    esac

    if [ "$TIMER_STATE" -eq 0 ]; then
        display_time() {
            MINUTES=$((SECONDS_LEFT / 60))
            SECONDS=$((SECONDS_LEFT % 60))
            MINUTES=$(printf "%02d" "$MINUTES")
            SECONDS=$(printf "%02d" "$SECONDS")

            case $2 in
                w) echo "$WORK_PREFIX$MINUTES:$SECONDS"; echo "$MINUTES:$SECONDS"; echo "$WORK_COLOR" ;;
                b) echo "$BREAK_PREFIX$MINUTES:$SECONDS"; echo "$MINUTES:$SECONDS"; echo "$BREAK_COLOR" ;;
            esac
        }

        # Check and update timer if POM_FILE_PATH exists and has two lines
        if [ -f "$POM_FILE_PATH" ] && [ "$(wc -l < "$POM_FILE_PATH")" -eq 2 ]; then
            START_TIME=$(sed '1d' "$POM_FILE_PATH")  # Time start
            MODE=$(sed '2d' "$POM_FILE_PATH")        # Mode (w or b)
            case $MODE in
                w) DURATION=$WORK_DURATION ;;
                b) DURATION=$BREAK_DURATION ;;
            esac

            CURRENT_TIME=$(date +%s)
            SECONDS_LEFT=$((DURATION - CURRENT_TIME + START_TIME))  # Remaining seconds

            if [ "$SECONDS_LEFT" -le 0 ]; then
                # Switch mode and play notification
                case $MODE in
                    w)
                        echo "b" > "$POM_FILE_PATH"
                        eval "$BREAK_NOTIFICATION"
                        paplay "$BELL_SOUND_PATH"
                        ;;
                    b)
                        echo "w" > "$POM_FILE_PATH"
                        eval "$WORK_NOTIFICATION"
                        paplay "$BELL_END_SOUND_PATH"
                        ;;
                esac
                echo "$CURRENT_TIME" >> "$POM_FILE_PATH"
            fi
            display_time "$SECONDS_LEFT" "$MODE"
        else
            echo "$MSG_START"
            echo "$MSG_START"
            echo "$START_COLOR"
        fi

        # Left-click to start or reset the timer
        case $BLOCK_BUTTON in
            1)
                if [ -f "$POM_FILE_PATH" ]; then
                    rm "$POM_FILE_PATH"
                else
                    echo "w" > "$POM_FILE_PATH"
                    date +%s >> "$POM_FILE_PATH"
                fi
                ;;
        esac
    fi

    # Run the external timer script if TIMER_STATE is set to 1
    if [ "$TIMER_STATE" -eq 1 ]; then
        "$TIMER_SCRIPT_PATH"
    fi
else
    echo "0" > "$POMO_TIMER_PATH"
fi