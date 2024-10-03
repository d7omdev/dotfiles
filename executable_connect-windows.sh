#!/bin/bash

# Variables
VM_NAME="win11"
IP_ADDRESS="192.168.122.172"
USERNAME="d7om"
PASSWORD="1313"

# Notify starting
notify-send "Starting Windows 11" "Please wait..."

# Start the VM
if virsh --connect qemu:///system start "$VM_NAME"; then
    notify-send "Windows 11 is starting" "Please wait..."
else
    notify-send "Failed to start Windows 11" "Please check the VM status."
    exit 1
fi

# Wait for the VM to boot
sleep 30

# Notify running
notify-send "Windows 11 is running" "Enjoy!"

# Connect to the VM
if ! xfreerdp3 -grab-keyboard /v:"$IP_ADDRESS" /u:"$USERNAME" /p:"$PASSWORD" /size:100% /d: /dynamic-resolution; then
    notify-send "Failed to connect to Windows 11" "Please check the connection."
    exit 1
fi
