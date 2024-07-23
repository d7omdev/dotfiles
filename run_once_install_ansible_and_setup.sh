#!/bin/bash

install_on_fedora() {
    sudo dnf install -y ansible git
}

install_on_ubuntu() {
    sudo apt-get update
    sudo apt-get install -y ansible git
}

install_on_mac() {
    brew install ansible git
}

install_on_arch() {
    sudo pacman -Syu --noconfirm ansible git
}

echo "Please enter your password to add the 'organize' script to the bin "
sudo -S mv executable_organize /usr/local/bin/organize

OS="$(uname -s)"
case "${OS}" in
Linux*)
    if [ -f /etc/fedora-release ]; then
        install_on_fedora
    elif [ -f /etc/lsb-release ]; then
        install_on_ubuntu
    elif [ -f /etc/arch-release ]; then
        install_on_arch
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

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ -f /etc/arch-release ]; then
    ansible-playbook ~/.bootstrap/setup-arch.yml --ask-become-pass
else
    ansible-playbook ~/.bootstrap/setup.yml --ask-become-pass
fi

figlet -t -c Finished -f larry3d

echo "https://d7om.dev"
