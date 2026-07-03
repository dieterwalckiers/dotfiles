# Wispr Flow (voice dictation) on Linux

Installed 2026-07-03 on Xubuntu 22.04 / X11 / i3.

> [!NOTE]
> **This is a moving target.** Wispr Flow has no official Linux build — this is
> the unofficial community port <https://github.com/wispr-flow-linux/wispr-flow-linux>
> (it repackages the proprietary Windows app + a clean-room Rust helper). Several
> rough edges below (uinput permissions, the stuck onboarding demo) were live
> bugs at install time and may **already be fixed** by the time you read this.
> Check the repo's `docs/` and its `--doctor` output before working around
> anything by hand. Treat this as "what I hit", not "what you must do".

## Install (AppImage route — no repo, no root)

Picked the AppImage over the apt repo to avoid a permanent third-party signed
apt source (`pkg.wispr-flow-linux.dev`).

```bash
mkdir -p ~/Applications
# grab the x86_64 .AppImage from the GitHub Releases page:
#   https://github.com/wispr-flow-linux/wispr-flow-linux/releases
chmod +x ~/Applications/wispr-flow.AppImage
~/Applications/wispr-flow.AppImage --doctor   # diagnoses everything below
```

Needs `libfuse2` (already present on this box; `sudo apt install libfuse2` if not).

## Hold-to-dictate hotkey

Built into the app — **no i3 `bindsym` needed**. The Rust helper captures keys
globally; on true X11 it uses XInput2 (zero-config, no device access). Default
chord is Ctrl+Super, hold to talk / release to inject. Rebind in the app's
Settings → Keyboard.

## Text injection needs /dev/uinput write access

Dictated text is typed via a `/dev/uinput` virtual keyboard, root-only by
default. Fix with a udev rule (already in the `input` group here):

```bash
echo 'KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess", GROUP="input", MODE="0660"' \
  | sudo tee /usr/lib/udev/rules.d/70-wispr-flow-uinput.rules
sudo udevadm control --reload-rules && sudo udevadm trigger
```

(The app's `--install-udev-rules` does the same but needs a real terminal for the
pkexec prompt.) This rule lives under `/usr/lib`, so it's **not** tracked in this
repo.

## Stuck onboarding (the demo that can't finish)

The "Use Flow to send a message" step (`tiy-variant-slack`) can't self-complete
on Linux: Wispr injects into the *last other focused app*, never its own window,
so the demo box gets no text — and it has no skip/close button. Bypass by
editing config while the app is **quit** (`pkill -f wispr`):

`~/.config/Wispr Flow/config.json` → set `prefs.user.onboardingCompleted = true`
and every `prefs.user.pagesCompleted[].completed = true` (plus the
`postOnboarding*` / `personalizationOnboarding*` flags), then relaunch.

## Autostart on i3 login

Added to `2-i3/config` (see `log/2026-07-03-wispr-flow-autostart.md`):

```
exec --no-startup-id "~/Applications/wispr-flow.AppImage"
```
