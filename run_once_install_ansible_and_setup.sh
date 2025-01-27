#!/bin/bash

set -e  # Exit on any error

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check command success
check_command() {
    if [ $? -ne 0 ]; then
        log "Error: $1 failed"
        exit 1
    fi
}

# Define the executable name and source path
organize_executable="organize"

# Ensure the organize executable is available and executable before moving it
if [ -f "./$organize_executable" ]; then
    chmod +x "./$organize_executable"
    check_command "Making organize executable"
    
    # Create destination directory if it doesn't exist
    sudo mkdir -p /usr/local/bin
    check_command "Creating /usr/local/bin directory"
    
    sudo mv "./$organize_executable" /usr/local/bin/organize
    check_command "Moving organize executable"
    log "'$organize_executable' moved successfully to /usr/local/bin"
else
    log "'$organize_executable' not found. Skipping the move."
fi

# Detect the operating system
OS="$(uname -s)"

case "${OS}" in
Linux*)
    # Detect Arch-based Linux distribution and install appropriate packages
    if [ -f /etc/arch-release ]; then
        log "Detected Arch-based system. Installing packages..."
        # Update package database first
        sudo pacman -Sy
        check_command "Updating package database"
        
        # Install required packages
        sudo pacman -S --noconfirm ansible git
        check_command "Package installation"
    else
        log "Unsupported Linux distribution. This script only supports Arch-based systems."
        exit 1
    fi
    ;;
*)
    log "Unsupported operating system: ${OS}. This script only supports Arch-based systems."
    exit 1
    ;;
esac

# Install TPM (Tmux Plugin Manager) if not already installed
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    mkdir -p "$HOME/.config/tmux/plugins"
    check_command "Creating tmux plugins directory"
    
    git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
    check_command "TPM installation"
    log "TPM installed successfully."
else
    log "TPM already installed."
fi

# Check if bootstrap directory exists and create if necessary
if [ ! -d "$HOME/.bootstrap" ]; then
    mkdir -p "$HOME/.bootstrap"
    check_command "Creating bootstrap directory"
    log "Created ~/.bootstrap directory"
fi

# Check for ansible playbook and run it
if [ -f "$HOME/.bootstrap/setup-arch.yml" ]; then
    # Verify ansible is installed before running playbook
    if ! command -v ansible-playbook >/dev/null 2>&1; then
        log "Error: ansible-playbook command not found"
        exit 1
    fi
    
    ansible-playbook "$HOME/.bootstrap/setup-arch.yml" --ask-become-pass
    check_command "Ansible playbook execution"
else
    log "Error: setup-arch.yml not found in ~/.bootstrap/"
    exit 1
fi

# NOTE: Disabled

# Check if .coache/setup-pika-backup.sh exists and run it
# if [ -f "$HOME/.cache/setup-pika-backup.sh" ]; then
#     log "Running setup-pika-backup.sh..."
#     bash "$HOME/.cache/setup-pika-backup.sh"
#     check_command "setup-pika-backup.sh execution"
#     log "setup-pika-backup.sh ran successfully."
# else
#     log "setup-pika-backup.sh not found in .cache"
# fi

# Font configuration
if [ -f "$HOME/.config/fontconfig/fonts.conf" ]; then
    # Create system fonts directory if it doesn't exist
    sudo mkdir -p /etc/fonts/conf.d
    check_command "Creating system fonts directory"
    
    # Copy font configuration instead of moving
    sudo cp "$HOME/.config/fontconfig/fonts.conf" /etc/fonts/conf.d/local.conf
    check_command "Copying font configuration"
    log "Font configuration installed successfully"
    
    # Update font cache
    if command -v fc-cache >/dev/null 2>&1; then
        sudo fc-cache -f
        check_command "Updating font cache"
    fi
else
    log "Warning: Font configuration not found at ~/.config/fontconfig/fonts.conf"
fi

# Display a message when finished
if command -v figlet >/dev/null 2>&1; then
    figlet -t -c Finished -f larry3d
else
    log "Finished"
fi

log "Visit: https://d7om.dev"
