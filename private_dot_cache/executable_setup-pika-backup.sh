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
# OPTION 1: Let the system decide when to run the task daily:
# Use 'OnCalendar=daily' if you want the system to run the task once a day at a time it decides.
# This is the default option if no OnCalendar is specified.
# Comment the following line to use another option:
OnCalendar=daily

# OPTION 2: Set a specific time to run the task, e.g., 3:00 AM daily:
# OnCalendar format: Year-Month-Day Hour:Minute:Second
# Explanation:
#  - Year (*): Any year
#  - Month (*): Any month
#  - Day (*): Any day of the month
#  - Hour (03): At exactly 3 AM
#  - Minute (00): At 00 minutes of the hour
#  - Second (00): At 00 seconds of the minute
# Uncomment the following line to set the time to 3:00 AM:
# OnCalendar=*-*-* 03:00:00

Persistent=true

[Install]
WantedBy=timers.target
EOF

# Enable lingering for the user to ensure the service starts after reboot
sudo loginctl enable-linger $USER

# Reload the systemd user manager
systemctl --user daemon-reload

# Enable and start the timer
systemctl --user enable pika-backup.timer
systemctl --user start pika-backup.timer

# Verify the timer is active
systemctl --user status pika-backup.timer
