#!/bin/bash

player_status=$(playerctl status 2> /dev/null)

if [ "$player_status" = "Playing" ]; then
    artist=$(playerctl metadata artist)
    title=$(playerctl metadata title)
    
    if [ -z "$artist" ]; then
        echo "♪ $title"
    else
        echo "♪ $artist - $title"
    fi
elif [ "$player_status" = "Paused" ]; then
    artist=$(playerctl metadata artist)
    title=$(playerctl metadata title)
    
    if [ -z "$artist" ]; then
        echo "⏸️ $title"
    else
        echo "⏸️ $artist - $title"
    fi
else
    echo "No media playing"
fi
