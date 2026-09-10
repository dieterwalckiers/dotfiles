# Browser picker

Registers as the system default browser, then asks -- via a `dmenu` bar --
which of the installed browsers should open each link. Rules can route known
hosts straight through without asking.

## Install

```
./install.sh
```

Needs `dmenu` (`sudo apt install suckless-tools`; already present with i3)
and, for the reminder notification, a notification daemon -- `dunst` here,
with `dunstify` for dismissal.
The script lands in `~/.local/bin/`, the handler in
`~/.local/share/applications/`, and the `@BIN@` placeholder in the `.desktop`
file is rewritten to the real `$HOME` path at install time.

## Browsers

Edit the `browsers` array in `browser-picker`. Order there is menu order.

```
browsers=(
  "firefox|firefox"
  "chrome|/usr/bin/google-chrome-stable"
  ...
)
```

Launch browsers by binary path, never through `xdg-open` -- that would come
straight back to the picker and loop.

## Rules

The `case $host in` block routes hosts that always go the same place. Patterns
match the **bare host only** -- no scheme, no path, no trailing slash. A
pattern like `*.whatsapp.com/` never matches anything.

`*.proton.me` does not cover bare `proton.me`; list both when you want both.

## Reminder notification

Links opened by a background app can put the dmenu bar somewhere easy to miss.
If the menu sits unanswered for `nag_after` seconds (default 5) a desktop
notification says a link is waiting; picking or pressing Esc dismisses it.

Tune it with `nag_after` in the script, or per-run:

```
BROWSER_PICKER_NAG_AFTER=15 browser-picker https://example.com
```

`dunstify` is used when present so the notification can be *closed* again on a
fixed id (`nag_id`); repeat nags replace rather than stack. Without it the code
falls back to `notify-send` with a 20s timeout and no early dismissal.

Rule-matched hosts never arm the nag -- they never show a menu.

## Revert

```
xdg-settings set default-web-browser firefox.desktop
```

## Gotchas

- Apps that read the default at startup (Slack, Electron things) keep using the
  old handler until restarted.
- Firefox offers to make itself default again on launch -- decline, or it takes
  the handler back.
- `setsid -f` in the launch line keeps the browser alive when the app you
  clicked the link in quits.
- Everything in `nag_stop` is `|| true`-guarded. Once the nag has fired its
  background job is gone, and a failing `kill` under `set -e` would take the
  script down before the browser ever opened.
