#!/bin/bash

# Define the executable name and source path
organize_executable="organize"

# Ensure the organize executable is available before moving it
if [ -f "./$organize_executable" ]; then
    sudo mv "./$organize_executable" /usr/local/bin/organize
    if [ $? -ne 0 ]; then
        echo "Failed to move '$organize_executable' to /usr/local/bin"
        exit 1
    fi
    echo "'$organize_executable' moved successfully to /usr/local/bin"
else
    echo "'$organize_executable' not found. Skipping the move."
fi

# Detect the operating system
OS="$(uname -s)"

case "${OS}" in
Linux*)
    # Detect Arch-based Linux distribution and install appropriate packages
    if [ -f /etc/arch-release ]; then
        echo "Detected Arch-based system. Installing packages..."
        sudo pacman -Syu --noconfirm ansible git
    else
        echo "Unsupported Linux distribution. This script only supports Arch-based systems."
        exit 1
    fi
    ;;
*)
    echo "Unsupported operating system: ${OS}. This script only supports Arch-based systems."
    exit 1
    ;;
esac

# Install TPM (Tmux Plugin Manager) if not already installed
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    if [ $? -ne 0 ]; then
        echo "Failed to clone TPM. Check your internet connection."
        exit 1
    fi
    echo "TPM installed successfully."
else
    echo "TPM already installed."
fi

# Run the Ansible playbook for Arch-based systems
ansible-playbook ~/.bootstrap/setup-arch.yml --ask-become-pass

# Check if .cache/setup-pika-backup.sh exists and run it
if [ -f "$HOME/.cache/setup-pika-backup.sh" ]; then
    echo "Running setup-pika-backup.sh..."
    bash "$HOME/.cache/setup-pika-backup.sh"
    if [ $? -ne 0 ]; then
        echo "Failed to execute setup-pika-backup.sh"
        exit 1
    fi
    echo "setup-pika-backup.sh ran successfully."
else
    echo "setup-pika-backup.sh not found in .cache"
fi

# Move the local.conf file to /etc/fonts
sudo mv $HOME/local.conf /etc/fonts/local.conf

# Display a message when finished
if command -v figlet &>/dev/null; then
    figlet -t -c Finished -f larry3d
else
    echo "Finished"
fi

echo "Visit: https://d7om.dev"
