#!/bin/bash
notify-send "Resolve Launcher" "Launching DaVinci Resolve 18" -i /home/d7om/.local/share/applications/graphics/DV_Resolve.png
distrobox-enter Resolve-Fedora-39 -- bash -c 'export __GLX_VENDOR_LIBRARY_NAME=nvidia && exec /opt/resolve/bin/resolve'
