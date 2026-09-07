# Per-link browser picker as default browser

Every clicked link now opens a `dmenu` bar listing the installed browsers;
pick one and the link opens there. Known hosts skip the menu via rules.

## What

New `browser-picker/` folder in this repo:

- `browser-picker` — the script (~30 lines of bash)
- `browser-picker.desktop` — the handler, `@BIN@` placeholder for the path
- `install.sh` — installs both, registers as default browser

Registered with `xdg-settings set default-web-browser browser-picker.desktop`
plus an explicit `xdg-mime default` for the http/https scheme handlers.

Previous default was `userapp-Firefox-PLFV62.desktop` (a Firefox-generated
entry, not `firefox.desktop`).

## Why this shape

Wanted the Finicky/Velja behaviour from macOS: choose per link, with rules for
the boring cases. On Linux the packaged option is **Junction** (GTK, Flathub
only) — skipped it because it would have meant installing the whole flatpak
stack for one small app, and it has no rules engine.

`dmenu` was already installed with i3 and is faster in practice than a
click-target dialog: two letters and Enter, no mouse trip. `zenity --list` is
a drop-in swap if a clickable dialog is ever wanted.

## Gotchas found

- Browsers must be launched **by binary path**. Calling `xdg-open` would route
  back into the picker and loop forever.
- `setsid -f` matters: without it the browser is a child of whatever app the
  link was clicked in, so quitting a mail client takes the browser down too.
- Rule patterns match the **bare host** — `$url` is stripped to `host` before
  the `case`. A trailing slash in a pattern (`*.whatsapp.com/`) silently never
  matches; hit this once already.
- `*.proton.me` does not match bare `proton.me`; both needed listing.
- Apps that cached the old handler at startup (Slack, Electron apps) keep using
  it until restarted, and Firefox will offer to grab the default back.

## Context

Four browsers in play: firefox, google-chrome-stable, microsoft-edge-stable,
ungoogled-chromium. Note `/usr/share/applications` also has snap-flavoured
duplicates (`com.google.Chrome.desktop`, `com.microsoft.Edge.desktop`) — the
picker's browser list is hardcoded, so they don't show up twice.
