# Browser picker: notification when the menu goes unanswered

Links opened by a background process put the dmenu bar somewhere easy to miss.
The picker now raises a desktop notification if nothing is picked within 5s.

## What

`browser-picker/browser-picker` gained `nag_start` / `nag_stop`: a backgrounded
`sleep` + notification, armed just before dmenu opens and cleared as soon as a
choice (or Esc) comes back. Delay is `nag_after`, overridable per run with
`BROWSER_PICKER_NAG_AFTER` (handy for testing without waiting 5s).

Uses `dunstify` when available so the notification can be **closed** again --
posted on a fixed id (`nag_id=90210`), so a second nag replaces the first
instead of stacking, and `dunstify -C` dismisses it on pick. Falls back to
plain `notify-send` with a 20s timeout and no early dismissal.

Rule-matched hosts never arm it: they never open a menu.

## Gotcha that cost a bug

First version had `nag_stop` doing a bare `[[ -n $nag_pid ]] && kill "$nag_pid"`.
Once the nag had already fired, the background job was gone, `kill` returned
non-zero as the last command of an `&&` list, and `set -e` killed the whole
script — so the browser never opened. Precisely the slow-pick case the feature
exists for, and invisible in the fast-pick path.

Everything in `nag_stop` is now `|| true`-guarded. Worth remembering for any
cleanup function in a `set -e` script.

## Verified

Stubbed `dmenu`/`dunstify` and drove all four paths: pick under threshold (no
notification, opens), pick over threshold (notification then dismissed, opens),
Esc over threshold (notification then dismissed, nothing opens), Esc under
threshold (nothing). Plus a live `dunstify` fire/close against the running dunst.

## Context

dunst 1.7-era on this box: `dunstctl` has no `count`, and the dbus interface has
no `NotificationListHistory` — can't introspect what was displayed, so live
verification is limited to dunstify's exit code plus watching the screen.
