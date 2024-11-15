#!/bin/bash

# Fetch weather data for Cascavel, PR in a custom format
WEATHER_DATA=$(curl -s wttr.in/Toledo-PR?format="%c+🌡️%t+🌬️%w+%m")

# Check for empty response or error indicators
FIRST_WORD="${WEATHER_DATA%% *}"

if [[ -z "$WEATHER_DATA" || "$FIRST_WORD" == "Unknown" || "$WEATHER_DATA" == *"Sorry"* ]]; then
    echo "  Offline"
else
    echo "$WEATHER_DATA"
fi
