# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal dotfiles for setting up an Xubuntu workstation. This is a configuration-only repository with no build system or tests - it contains shell configs, window manager settings, and installation guides.

## Structure

- `1-varioustools/` - Initial system setup: apt packages, snap installs, git config
- `2-i3/` - i3 window manager config (copy to `~/.config/i3/config`)
- `3-shell/fish/` - Fish shell config and functions (copy to `~/.config/fish/`)
- `keyboard/` - Key remapping configs (Xmodmap for X11, input-remapper for Wayland)
- `vim/` - Vim config with .tid file syntax highlighting
- `custom-scripts/` - Scripts to copy to `/usr/bin`
- `optionaltweaks/` - System tweaks (inotify limits, swap/earlyoom setup)

## Key Configuration Files

- `2-i3/config` - i3wm keybindings and window rules
- `3-shell/fish/config.fish` - Fish shell environment (thefuck, Go path, 1Password completion)
- `3-shell/fish/functions/` - Fish functions including kubernetes helpers (k, kn, klog, etc.)
- `keyboard/keyboard-on-xorg-systems/.Xmodmap` - AZERTY keyboard remapping for Mac-like symbols

## Setup Order

1. Run `1-varioustools/1-install.sh` for base packages
2. Follow `1-varioustools/2-readme.md` for Docker, nvm, kubectl, minikube
3. Install fish shell per `3-shell/fish/readme.md`
4. Copy i3 config and reboot into i3 session
5. Apply keyboard remaps as needed
