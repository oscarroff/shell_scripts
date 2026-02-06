#!/bin/bash

# Get screen size
SIZE=$(xdpyinfo | awk '/dimensions:/ {print $2}')
WIDTH=$(echo "$SIZE" | cut -d 'x' -f1)
HEIGHT=$(echo "$SIZE" | cut -d 'x' -f2)
HALF=$((WIDTH / 2))

move_window() {
    local wid="$1"
    local x="$2"
    local y="$3"
    local width="$4"
    local height="$5"

    wmctrl -i -r "$wid" -e "0,$x,$y,$width,$height"
}

# Get window ID by name
get_window_id() {
    local name="$1"
    xwininfo -root -tree | grep "$name" | grep -oP '0x[0-9a-f]+' | head -1
}

flatpak run org.mozilla.firefox 2>/dev/null &
sleep 3

# Get window IDs
TERM_ID="$WINDOWID"
FF_ID=$(get_window_id "Firefox")

# Position them
if [ -n "$TERM_ID" ]; then
    move_window "$TERM_ID" 0 0 "$HALF" "$HEIGHT"
fi

if [ -n "$FF_ID" ]; then
    move_window "$FF_ID" "$HALF" 0 "$HALF" "$HEIGHT"
fi
