#!/usr/bin/env bash
# Install the browser picker and make it the system default browser.
set -euo pipefail
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

command -v dmenu >/dev/null || {
  echo "dmenu not found -- sudo apt install suckless-tools" >&2; exit 1; }

mkdir -p ~/.local/bin ~/.local/share/applications

echo "previous default: $(xdg-settings get default-web-browser)"

install -m 755 "$here/browser-picker" ~/.local/bin/browser-picker
sed "s|@BIN@|$HOME/.local/bin/browser-picker|" "$here/browser-picker.desktop" \
  > ~/.local/share/applications/browser-picker.desktop

update-desktop-database ~/.local/share/applications
xdg-settings set default-web-browser browser-picker.desktop
xdg-mime default browser-picker.desktop x-scheme-handler/http x-scheme-handler/https

echo "new default:      $(xdg-settings get default-web-browser)"
