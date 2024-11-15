#!/bin/bash
BLUR="5x4"
PICTURE=~/Pictures/Wallpapers/Whatever.png
SCREENSHOT="flameshot full -p $PICTURE"

# Capture the screen and save it to /tmp/i3lock.png
#$SCREENSHOT

# Apply blur to the image using ImageMagick
#magick $PICTURE -blur $BLUR $PICTURE

# Lock the screen with the blurred image
i3lock -i $PICTURE

# Remove the temporary image after locking
#rm $PICTURE
