#!/bin/bash
notify-send "Resolve Launcher" "Launching DaVinci Resolve 18" -i /home/d7om/.local/share/applications/graphics/DV_Resolve.png
setsid distrobox-enter Resolve-Fedora-39 -- bash -c "__GLX_VENDOR_LIBRARY_NAME=nvidia /opt/resolve/bin/resolve" &>/dev/null 2>&1 &
