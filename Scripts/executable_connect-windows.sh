#!/bin/bash

notify-send "Warning!" "This is currently disabled" -u critical -a "disabled script" 
exit 0


# Variables
VM_NAME="win11"
IP_ADDRESS="192.168.122.172"
USERNAME="d7om"
PASSWORD="1313"
LOG_FILE="$HOME/win11_vm.log"

# Check if the VM is already running
VM_STATUS=$(virsh --connect qemu:///system domstate "$VM_NAME")

if [[ "$VM_STATUS" == "running" ]]; then
    echo "[$(date)] VM: $VM_NAME is already running."
    notify-send "VM Running" "Windows 11 VM is already running, connecting..."
else
    # Check for errors in starting the VM
    if
        virsh --connect qemu:///system start "$VM_NAME" >>"$LOG_FILE" 2>/dev/null &
        disown
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
fi

# Connect to the VM with xfreerdp3 in the background and detach
xfreerdp3 -grab-keyboard /v:"$IP_ADDRESS" /u:"$USERNAME" /p:"$PASSWORD" /size:100% /dynamic-resolution +sound /sound:sys:alsa >>"$LOG_FILE" 2>/dev/null &
FREERDP_PID=$!      # Capture the process ID of the background task
disown $FREERDP_PID # Disown the process to prevent locking the terminal

# Short sleep to give xfreerdp3 time to potentially fail before we check the status
sleep 5

# Check if the xfreerdp3 process has exited (failure)
if ! ps -p $FREERDP_PID >/dev/null; then
    echo "[$(date)] Failed to connect to Windows 11 at $IP_ADDRESS"
    notify-send "Failed to connect to Windows 11" "Please check the connection."
    echo "[$(date)] Failed to connect to Windows 11 at $IP_ADDRESS" >>"$LOG_FILE"
    echo "Errors found in the log file: $LOG_FILE"
    exit 1
if [[ "$VM_STATUS" == "running" ]]; then
return 0
else
    echo "[$(date)] Successfully connected to Windows 11 at $IP_ADDRESS"
    notify-send "Connected to Windows 11" "Enjoy your session!"
fi
