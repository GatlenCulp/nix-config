#!/bin/bash
# https://github.com/nikitabobko/AeroSpace/issues/139
# Not sure this works
set -e
current_monitor=$(aerospace list-monitors --focused | awk '{print $1}')
current_workspace=$(aerospace list-workspaces --focused)
win_list=$(aerospace list-windows --monitor "$current_monitor" | grep -E "(Picture-in-Picture|Picture in Picture)" | awk '{print $1}')

# echo "$win_list" | while IFS= read -r number; do
#   echo "Processing number: $number"
#   aerospace move-node-to-workspace --window-id "$number" "$current_workspace" < /dev/null
#   echo "continue"
# done

aerospace list-windows --all | grep -E "(Picture-in-Picture|Picture in Picture)" | awk '{print $1}' | while read window_id; do
    if [ -n "$window_id" ]; then
        aerospace move-node-to-workspace --window-id "$window_id" "$current_workspace"
    fi
done