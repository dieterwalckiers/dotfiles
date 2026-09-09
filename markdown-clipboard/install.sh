#!/usr/bin/env bash
# Install md2rich / rich2md into ~/.local/bin.
set -euo pipefail
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

command -v pandoc >/dev/null || {
  echo "pandoc not found -- brew install pandoc (or sudo apt install pandoc)" >&2; exit 1; }
command -v xclip >/dev/null || {
  echo "xclip not found -- sudo apt install xclip" >&2; exit 1; }
python3 -c 'import gi; gi.require_version("Gtk", "4.0"); from gi.repository import Gtk' 2>/dev/null || {
  echo "python3 GTK4 bindings missing -- sudo apt install python3-gi gir1.2-gtk-4.0" >&2; exit 1; }

mkdir -p ~/.local/bin
install -m 755 "$here/md2rich"  ~/.local/bin/md2rich
install -m 755 "$here/richclip" ~/.local/bin/richclip
install -m 755 "$here/rich2md"  ~/.local/bin/rich2md
mkdir -p ~/.local/share/markdown-clipboard
install -m 644 "$here/html-styles.lua" ~/.local/share/markdown-clipboard/html-styles.lua

echo "installed: $(command -v md2rich) $(command -v rich2md)"
