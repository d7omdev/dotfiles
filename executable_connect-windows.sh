#!/bin/bash

# Variables
VM_NAME="win11"
IP_ADDRESS="192.168.122.172"
USERNAME="d7om"
PASSWORD="1313"
LOG_FILE="$HOME/win11_vm.log"

# Log the start of the process
echo "[$(date)] Starting the Windows 11 VM process" >>"$LOG_FILE"

# Notify starting QEMU
notify-send "Starting QEMU" "Initializing the virtual machine..."

# Start the VM in the background and detach
if
    virsh --connect qemu:///system start "$VM_NAME" >>"$LOG_FILE" 2>/dev/null &
    disown
then
    notify-send "QEMU Started" "Windows 11 VM is booting..."
    echo "[$(date)] QEMU started for VM: $VM_NAME" >>"$LOG_FILE"
else
    notify-send "Failed to start QEMU" "Please check the VM status."
    echo "[$(date)] Failed to start QEMU for VM: $VM_NAME" >>"$LOG_FILE"
    exit 1
fi

# Wait for the VM to boot
sleep 30

# Notify Windows booting
notify-send "Windows 11 Booting" "Please wait, Windows is starting..."

# Notify running
notify-send "Windows 11 is running" "Windows 11 is now running!"
echo "[$(date)] Windows 11 VM is running" >>"$LOG_FILE"

# Connect to the VM with xfreerdp3 and enable sound in the background and detach
if
    ! xfreerdp3 -grab-keyboard /v:"$IP_ADDRESS" /u:"$USERNAME" /p:"$PASSWORD" /size:100% /d: /dynamic-resolution +sound /sound:sys:alsa >>"$LOG_FILE" 2>/dev/null &
    disown
then
    notify-send "Failed to connect to Windows 11" "Please check the connection."
    echo "[$(date)] Failed to connect to Windows 11 at $IP_ADDRESS" >>"$LOG_FILE"
    exit 1
else
    notify-send "Connected to Windows 11" "Enjoy your session with sound!"
    echo "[$(date)] Successfully connected to Windows 11 at $IP_ADDRESS" >>"$LOG_FILE"
fi
