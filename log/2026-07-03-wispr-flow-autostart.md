# Autostart Wispr Flow on i3 login

Made the Wispr Flow voice-dictation app (unofficial Linux port, AppImage at
`~/Applications/wispr-flow.AppImage`) launch on every i3 start.

## What

Appended to i3 config (`2-i3/config`, symlinked to `~/.config/i3/config`):

```
# Wispr Flow voice dictation (AppImage; hold-to-dictate hotkey lives in the app)
exec --no-startup-id "~/Applications/wispr-flow.AppImage"
```

`exec` (not `exec_always`) → runs on i3 start/login only, survives reboots but
is not re-launched on config reload. Start it by hand once (`$mod+Shift+r`
reloads config but won't launch this; just run the AppImage the first time).

There's already a `dex --autostart` line, so an XDG `~/.config/autostart/*.desktop`
entry would also have worked — used an explicit `exec` to match the file's style
and keep it visible.

## Context

- Installed via AppImage (not the apt repo) to avoid a permanent third-party
  signed source.
- Hold-to-dictate is built into the app (default Ctrl+Super); no i3 `bindsym`
  needed — the app's Rust helper captures keys globally (zero-config on X11 via
  XInput2).
- Text injection needs `/dev/uinput` write access: udev rule at
  `/usr/lib/udev/rules.d/70-wispr-flow-uinput.rules` (installed by hand; not in
  this repo since it lives under `/usr/lib`). `wispr-flow.AppImage --doctor`
  diagnoses it.
- Onboarding demo can't self-complete on Linux/i3 — bypassed by flipping
  `onboardingCompleted`/`pagesCompleted` in `~/.config/Wispr Flow/config.json`.
