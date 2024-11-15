#!/bin/bash

LEVEL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1)
UNIT=10
VOLUME=$(($LEVEL / $UNIT))
MUTE=$(pactl get-sink-mute @DEFAULT_SINK@)

if [ "$MUTE" == "Mute: sì" ] || [ "$MUTE" == "Mute: yes" ]; then
    echo " "
    echo ""
    echo "#cdd6f4"
else
    case $VOLUME in
        10)
            echo " "
            echo ""
            echo "#f38ba8"
            ;;
        9)
            echo " "
            echo ""
            echo "#f38ba8"
            ;;
        8)
            echo " "
            echo ""
            echo "#f38ba8"
            ;;
        7)
            echo " "
            echo ""
            echo "#f38ba8"
            ;;
        6)
            echo " "
            echo ""
            echo "#fab387"
            ;;
        5)
            echo " "
            echo ""
            echo "#fab387"
            ;;
        4)
            echo " "
            echo ""
            echo "#a6e3a1"
            ;;
        3)
            echo " "
            echo ""
            echo "#a6e3a1"
            ;;
        2)
            echo " "
            echo ""
            echo "#a6e3a1"
            ;;
        1)
            echo " "
            echo ""
            echo "#a6e3a1"
            ;;
        0)
            if [ "$LEVEL" != 0 ]; then
                echo " "
                echo ""
                echo "#a6e3a1"
            else
                echo " "
                echo ""
                echo "#cdd6f4"
            fi
            ;;
    esac
fi
