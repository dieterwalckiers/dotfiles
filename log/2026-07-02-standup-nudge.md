# Stand-up nudge every 30 min

Added a recurring "stand up" desktop notification for i3/XFCE.

## What

Appended to i3 config (`2-i3/config`, symlinked to `~/.config/i3/config`):

```
# stand-up nudge every 30 min
exec --no-startup-id sh -c 'while sleep 30m; do notify-send -u critical "🧍 Stand up" "30 min passed"; done'
```

`exec` (not `exec_always`) runs on i3 start only, so it survives reboots/logins
but is *not* re-launched on config reload — start it by hand once when adding it.

Relies on `notify-send` (libnotify) + the running notification daemon
(xfce4-notifyd under XFCE; dunst under bare i3). `-u critical` keeps the
notification sticky until dismissed.

## Why not a tool

Considered stretchly/workrave — overkill for a plain nudge. A one-line shell
loop covers it with zero deps. Reach for a real tool only if enforced breaks /
screen lock are wanted. (Note: `safeeyes` is already autostarted in the i3
config and does break reminders too — this nudge is partly redundant with it.)

---

# Migrated dotfiles from copy → symlink

Same session: the i3 config edit revealed live files and repo copies had
drifted both ways (repo was a stale *copy*, not a symlink). Switched the
user-level configs to symlinks so live == repo from now on.

Live file was treated as source of truth: synced live → repo, then replaced
live with a symlink into the repo. Backup of everything touched:
`~/dotfiles-symlink-backup-20260702-131537`.

Now symlinked (live → repo):

- `~/.config/i3/config`          → `2-i3/config`
- `~/.config/fish/config.fish`   → `3-shell/fish/config.fish`
- `~/.config/fish/functions`     → `3-shell/fish/functions` (whole dir; merged live fns in, dropped a stray vim `.swp`)
- `~/.vimrc`                     → `vim/.vimrc`
- `~/.vim`                       → `vim/.vim` (repo had `syntax/`, `after/` that live lacked)
- `~/.config/picom/picom.conf`   → `cosmetics/picom.conf`

Skipped `.Xmodmap` — repo has it but nothing loads it (i3 uses
`tweakkeyboard.sh` + `setxkbmap`); would've been a dead symlink.

Note: repo's CLAUDE.md / readme still say "copy to ~/...". That guidance is now
stale for these files — they're symlinked. Not yet updated.
