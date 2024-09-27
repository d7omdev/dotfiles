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
    # Detect Linux distribution and install appropriate packages
    if [ -f /etc/fedora-release ]; then
        echo "Detected Fedora-based system. Installing packages..."
        sudo dnf install -y ansible git
    elif [ -f /etc/arch-release ]; then
        echo "Detected Arch-based system. Installing packages..."
        sudo pacman -Syu --noconfirm ansible git
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
    ;;
Darwin*)
    # For macOS, install using Homebrew
    if ! command -v brew &>/dev/null; then
        echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh"
        exit 1
    fi
    brew install ansible git
    ;;
*)
    echo "Unsupported operating system: ${OS}"
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

# Run the appropriate Ansible playbook based on the system
if [ -f /etc/arch-release ]; then
    ansible-playbook ~/.bootstrap/setup-arch.yml --ask-become-pass
else
    ansible-playbook ~/.bootstrap/setup.yml --ask-become-pass
fi

# Display a message when finished
if command -v figlet &>/dev/null; then
    figlet -t -c Finished -f larry3d
else
    echo "Finished"
fi

# End with a link to the user's website
echo "Visit: https://d7om.dev"
