#!/bin/bash

# Wait for swaync to be ready
until pgrep -x swaync >/dev/null; do
    sleep 1
done

# Now run the event loop
swaync-client --mode event | while read -r line; do
    if [[ "$line" == *"notify::new-notification"* ]]; then
        paplay /usr/share/sounds/freedesktop/stereo/message.oga
    fi
done
