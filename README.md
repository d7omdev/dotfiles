# dotfiles

This repo contains the configuration to setup my machines.

This is using [Chezmoi](https://chezmoi.io), the dotfile manager to setup the install.

This automated setup is for Arch-based systems.

## How to use

Simply run the following command:

- When prompted `BECOME password:` enter your "sudo" password.

```shell
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply d7omdev
```

## What does it do?

<details>
<summary>AUR Packages Installed</summary>

- pika-backup
- mission-center
- timeshift
- grub-btrfs
- timeshift-autosnap
- sesh-bin
- github-cli
- ttf-jetbrains-mono-nerd
- scrcpy
- android-tools
- appimagelauncher
- ttf-amiri
- hyprshot-git
- keyd
- clipse
- base-devel
- kitty-git
</details>

<details>
<summary>Pacman Packages Installed</summary>

- git
- btop
- neovim
- firefox
- gnome-tweaks
- ripgrep
- zsh
- fzf
- tmux
- openssl
- gdbm
- libnsl
- luarocks
- wl-clipboard
- fd
- base-devel
- autoconf
- docker
- docker-compose
</details>

<details>
<summary>Modifications Made</summary>

- Ensures Homebrew is installed
- Updates Homebrew
- Installs Homebrew packages
- Upgrades Homebrew packages
- Changes shell to zsh
- Installs Docker
- Adds Docker group
- Adds user to docker group
- Ensures fonts directory
- Checks if Jetbrains Mono exists
- Downloads Jetbrains mono
- Optional installation of end-4's Hyprland rice
- Optional installation of D7OM's Hyprland and AGS configurations
- Optional installation of D7OM's Neovim configuration
</details>

<details>
<summary>Configurations</summary>

- zsh Configuration
- tmux Configuration
- neovim Configuration (optional)
- Hyprland Configuration (optional)
- AGS Configuration (optional)
- rofi Configuration
  - Refer to [adi1090x/rofi](https://github.com/adi1090x/rofi) for more information
- kitty terminal Configuration
  - Refer to [kitty README](./dot_config/kitty/executable_README.md) for more information
- fastfetch Configuration
- Bat configuration

**Note**: run `cat ~/.aliasesrc` to see the aliases that are configured
</details>

---

This script uses Ansible, a configuration management tool.

Ansible is used to automate the process of setting up a machine with the specified applications, packages, and configurations.
