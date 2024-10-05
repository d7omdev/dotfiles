#!/bin/bash

# First, create the systemd user service file
mkdir -p ~/.config/systemd/user/

cat <<EOF >~/.config/systemd/user/pika-backup.service
[Unit]
Description=Pika Backup Automatic Backup Service
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/pika-backup backup --all

[Install]
WantedBy=default.target
EOF

# Create the timer file
cat <<EOF >~/.config/systemd/user/pika-backup.timer
[Unit]
Description=Run Pika Backup daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Enable and start the timer
systemctl --user enable pika-backup.timer
systemctl --user start pika-backup.timer

# Verify the timer is active
systemctl --user status pika-backup.timer
