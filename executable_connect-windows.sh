#!/bin/bash

# Variables
VM_NAME="win11"
IP_ADDRESS="192.168.122.172"
USERNAME="d7om"
PASSWORD="1313"
LOG_FILE="$HOME/win11_vm.log"

# Check for errors in starting the VM
if
    virsh --connect qemu:///system start "$VM_NAME" >>"$LOG_FILE" 2>/dev/null
then
    echo "[$(date)] QEMU started for VM: $VM_NAME"
    notify-send "QEMU Started" "Windows 11 VM is booting..."
else
    echo "[$(date)] Failed to start QEMU for VM: $VM_NAME"
    notify-send "Failed to start QEMU" "Please check the VM status."
    echo "[$(date)] Failed to start QEMU for VM: $VM_NAME" >>"$LOG_FILE"
    echo "Errors found in the log file: $LOG_FILE"
    exit 1
fi

# Wait for the VM to boot
sleep 30

# Connect to the VM with xfreerdp3 in the background and detach
if
    ! xfreerdp3 -grab-keyboard /v:"$IP_ADDRESS" /u:"$USERNAME" /p:"$PASSWORD" /size:100% /d: /dynamic-resolution +sound /sound:sys:alsa >>"$LOG_FILE" 2>/dev/null
then
    echo "[$(date)] Failed to connect to Windows 11 at $IP_ADDRESS"
    notify-send "Failed to connect to Windows 11" "Please check the connection."
    echo "[$(date)] Failed to connect to Windows 11 at $IP_ADDRESS" >>"$LOG_FILE"
    echo "Errors found in the log file: $LOG_FILE"
    exit 1
else
    echo "[$(date)] Successfully connected to Windows 11 at $IP_ADDRESS"
    notify-send "Connected to Windows 11" "Enjoy your session!"
fi
