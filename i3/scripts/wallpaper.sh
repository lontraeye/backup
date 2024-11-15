#!/bin/bash
WALLPAPER_PATH=~/Pictures/Wallpapers # Wallpaper path
CURRENT_INDEX_PATH=~/Pictures/Wallpapers/current-index # Current index path
CURRENT_WALLPAPER_PATH=~/Pictures/Wallpapers/current-wallpaper # Current wallpaper path
CURRENT_INDEX=$(cat "$CURRENT_INDEX_PATH")

if [ "$BLOCK_BUTTON" == 1 ]; then
    NEW_INDEX=$((CURRENT_INDEX + 1))
    if [ $NEW_INDEX -eq 24 ]; then
        NEW_INDEX=0
    fi
fi

if [ "$BLOCK_BUTTON" == 3 ]; then
    NEW_INDEX=$((CURRENT_INDEX - 1))
    if [ $NEW_INDEX -eq -1 ]; then
        NEW_INDEX=23
    fi
fi

cp $WALLPAPER_PATH/$NEW_INDEX.* "$CURRENT_WALLPAPER_PATH"
echo $NEW_INDEX > $CURRENT_INDEX_PATH
feh --bg-fill "$CURRENT_WALLPAPER_PATH"
