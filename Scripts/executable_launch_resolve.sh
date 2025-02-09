#!/bin/bash

notify-send "Warning!" "This is currently disabled" -u critical -a "disabled script" 
exit 0

# notify-send "Resolve Launcher" "Launching DaVinci Resolve 18" -i /home/d7om/.local/share/applications/graphics/DV_Resolve.png
# distrobox-enter Resolve-Fedora-39 -- bash -c 'export __GLX_VENDOR_LIBRARY_NAME=nvidia && exec /opt/resolve/bin/resolve' >/dev/null 2>&1 &
