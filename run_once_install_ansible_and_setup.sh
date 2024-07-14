#!/bin/bash

install_on_fedora() {
    sudo dnf install -y ansible
}

install_on_ubuntu() {
    sudo apt-get update
    sudo apt-get install -y ansible
}

install_on_mac() {
    brew install ansible
}

OS="$(uname -s)"
case "${OS}" in
Linux*)
    if [ -f /etc/fedora-release ]; then
        install_on_fedora
    elif [ -f /etc/lsb-release ]; then
        install_on_ubuntu
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
    ;;
Darwin*)
    install_on_mac
    ;;
*)
    echo "Unsupported operating system: ${OS}"
    exit 1
    ;;
esac

if ! command -v git &>/dev/null; then
    sudo dnf install git -y
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

ansible-playbook ~/.bootstrap/setup.yml --ask-become-pass

figlet -t -c Finished -f larry3d

echo "https://d7om.dev"
