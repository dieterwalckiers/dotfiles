# md2rich -- markdown to rich text on the clipboard

Wanted a CLI to paste markdown into Google Docs and other WYSIWYG editors as
formatted text.

## What was added

`~/dotfiles/md2rich/` (installed to `~/.local/bin` via `install.sh`):

- `md2rich` -- bash wrapper. Takes markdown from the clipboard (default), a
  file, stdin, or `$EDITOR` via `-e`. Renders with pandoc.
- `richclip` -- GTK4 python helper that owns the clipboard.

Installed pandoc 3.11 through homebrew. xclip was already present.

## Why a GTK4 helper instead of xclip

`xclip -t text/html` advertises only that one target, so plain-text fields
paste raw HTML tags. Serving both `text/html` and `text/plain` needs a real
multi-format clipboard owner.

Two dead ends before GTK4:

- `Gtk.Clipboard.set_with_data` (GTK3) is not introspectable in PyGObject --
  `AttributeError: 'Clipboard' object has no attribute 'set_with_data'`.
- copyq would work but wants a resident daemon.

GTK4's `Gdk.ContentProvider.new_union([...])` is introspectable and does the
job in ~20 lines. Note both `Gtk` *and* `Gdk` need `gi.require_version`,
otherwise Gdk silently loads 4.0 and clashes.

## Gotchas found while testing

- `richclip` must read its input files *before* it daemonizes, otherwise it
  races the caller's temp-file cleanup.
- Pandoc's syntax highlighting emits class-only spans plus empty `<a>`
  line-anchors. Editors strip the classes and keep the stray links, so
  `--syntax-highlighting=none` gives a cleaner paste.
- Task list `<input type=checkbox>` elements are dropped by editors; they get
  substituted for ☒ / ☐ glyphs.

## Not verified

Actual in-app paste into Google Docs -- the Chrome extension was not
connected. Verified at the X11 layer instead: TARGETS advertises `text/html`
alongside the text targets, and both return the right payload.

---

# rich2md (same day)

Added the reverse direction. Directory renamed `md2rich/` ->
`markdown-clipboard/` now that it holds a pair of tools.

`pandoc -f html -t gfm` on a Google Docs paste is useless -- the spans come
through as raw HTML rather than being stripped. Four fixes, all verified
against a fixture reduced from real Docs clipboard output:

- `-f html+native_spans` keeps spans as AST nodes so a Lua filter can read
  their `style` and emit Strong/Emph/Strikeout. Without native_spans the
  styling is simply lost.
- Docs wraps everything in `<b style="font-weight:normal" id="docs-internal-
  guid-...">`, which would bold the whole document. Stripping just the opening
  tag with sed is enough -- pandoc's tagsoup reader ignores the orphaned
  `</b>`, so no HTML parser is needed.
- Links are rewritten to `google.com/url?q=...`; the filter unwraps them.
  Careful: percent-decoding turns `%20` into a literal space and breaks the
  link target, so spaces get re-encoded afterwards.
- Pasted tables have no `<thead>`; pandoc invents an empty header and demotes
  the real one. The filter promotes it back.

Output goes to the clipboard on a tty, stdout when redirected.

`md2rich sample.md | rich2md` round trips byte-for-byte, ☒/☐ glyphs included.

## Gotcha while writing it

Escaped `\$#` inside a *quoted* heredoc leaves the backslash literal, so the
arg parser was born broken. Quoted heredoc = no expansion, no escaping needed.

---

# dmenu launch fix (same day)

Reported: running the tools from `dmenu_run` (super+space) did nothing; from a
shell they worked.

Cause was mine. A GUI launcher gives the process `/dev/null` as stdin -- not a
tty, but not a pipe either. Both scripts used `[[ ! -t 0 ]]` to mean "something
was piped in", so they read an empty stdin, found nothing, and exited with a
message to a stderr that no terminal was attached to.

    $ setsid --fork sh -c 'md2rich' < /dev/null   # reproduces it
    md2rich: nothing to convert

Fixes:

- Test `[[ -p /dev/stdin || -f /dev/stdin ]]` instead of "not a tty". That
  distinguishes a genuine pipe/redirect from an inherited /dev/null.
- Same for rich2md's stdout, which was writing markdown to nowhere under a GUI
  launch instead of putting it on the clipboard.
- `report()` falls back to `notify-send` when stderr is not a terminal, so GUI
  invocations get visible success and failure feedback. dunst is running.
  Guarded with `|| true` -- under `set -e` a failing notify-send would abort.
- `md2rich -e` now says it needs a terminal rather than failing silently.

Note: status messages moved from stdout to stderr. Keeps stdout clean for
`rich2md > notes.md`.

Verified: dmenu-style launch for both tools, richclip surviving the launcher
exiting, and all four CLI paths (pipe, redirect, file arg, tty).

---

# dmenu, take two: PATH and clipboard targets

The first dmenu fix was necessary but not sufficient. My "dmenu simulation"
(`setsid --fork sh -c ... < /dev/null`) inherited *my* environment, so it never
reproduced the launcher's PATH. Two further bugs were hiding behind that:

1. **pandoc is not on the i3 PATH.**

       $ tr '\0' '\n' < /proc/$(pgrep -x i3)/environ | grep ^PATH=
       PATH=...:/home/dyte/.local/bin:/usr/bin:...   # no linuxbrew

   dmenu offered `md2rich` (it lives in ~/.local/bin, which *is* on the path)
   but the script then could not find pandoc. Both scripts now append
   /home/linuxbrew/.linuxbrew/bin, /opt/homebrew/bin, /usr/local/bin and
   ~/.local/bin to PATH themselves, so they do not depend on the session env.

2. **`xclip -o` requests the STRING target by default.** An owner advertising
   only UTF8_STRING returns nothing, which is indistinguishable from an empty
   clipboard -- this is what produced "nothing to convert -- the clipboard has
   no text" while the content was plainly there. Reads now walk
   UTF8_STRING -> text/plain;charset=utf-8 -> text/plain -> STRING, and the
   html read walks text/html -> text/html;charset=utf-8.

Lesson: simulate a GUI launch with `env -i` and the launcher's real PATH, taken
from /proc/<pid>/environ. Anything less inherits the shell's environment and
proves nothing.

Verified with i3's actual PATH + DBUS: both tools from dmenu, all four CLI
input paths, and a round trip that is identical once the source's hard wrapping
is normalised (`--wrap=none` output is unwrapped -- semantically equal, not
literally byte-identical as I said earlier).

---

# dmenu, take three: the actual cause was an empty pipe

Two rounds of fixes and it still failed from dmenu. Stopped guessing and
installed a tracing wrapper at ~/.local/bin/md2rich that logged env, fd types,
lookups and a `bash -x` trace, then had the user trigger it once. The trace:

    argv: []   ppid_cmd: /usr/bin/fish
    stdin: not tty
    stdin: pipe                      <-- an EMPTY pipe
    prw------- 1 dyte dyte 0 /dev/stdin
    which pandoc: /home/linuxbrew/.linuxbrew/bin/pandoc   <-- found
    UTF8_STRING -> [### WordPress]                        <-- readable

dmenu runs the command **through fish**, which gives it an empty pipe on stdin
-- not /dev/null. So `[[ -p /dev/stdin ]]` said "something was piped in",
md2rich read the pipe, got EOF, and reported an empty clipboard.

Notably the PATH fix from take two was NOT the cause: fish supplies linuxbrew,
so pandoc resolved fine. That fix is still correct defensively, but it fixed a
problem this setup did not have. Diagnosing by simulation instead of
instrumentation cost two wrong fixes.

**Real fix:** stop trying to classify the file descriptor. An empty pipe is
byte-for-byte indistinguishable from a real one until you read it, so:

    if stdin_is_redirected; then cat > "$md" || true; fi
    if [[ ! -s $md ]]; then clipboard_text "$md" || true; fi

Try stdin; if it yields nothing, use the clipboard. Handles tty, /dev/null,
empty pipe, real pipe and file redirect with no heuristics at all.

For rich2md's *output* there is nothing to try, so stdout now requires `-o` or
a real file (`-f /dev/stdout`); a bare pipe may lead nowhere under a launcher.

Verified: empty pipe (3x, consistent), real pipe still beating the clipboard,
file arg, file redirect, tty, and all four rich2md paths.

Lesson: instrument the failing invocation early. Every simulation I built
passed, because each one inherited something from my shell that dmenu did not
provide.

---

# Simplify pass + reporting fix

Cleanup of the cruft three rounds of patching left behind:

- Each script carried a clipboard reader it never called (`clipboard_html` in
  md2rich, `clipboard_text` in rich2md) because the same block was inserted
  into both. Collapsed the generic `clipboard_to` + two wrappers into a single
  reader per script.
- Trimmed the empty-pipe comments, which had grown to 4-5 lines plus a
  redundant inline restatement. The *why* stays -- the code looks wrong without
  it.
- html-styles.lua: `BulletList`/`OrderedList` had identical bodies, now one
  `tighten_list` assigned to both; `Table`'s `header_blank` flag became an
  early return.

Deliberately kept: `report`/`die` and the PATH block are duplicated across both
scripts. Factoring them into a sourced lib needs runtime path resolution, and a
missing-lib failure before `die()` exists is exactly the launcher-environment
class of bug we just spent three rounds on. Self-contained scripts win here.

**Reporting fix.** `report()` was an either/or -- stderr *or* notify-send -- so
`md2rich foo 2>err.log` left the log empty and only popped a notification. Now
it always writes stderr (guarded with `|| true` against EPIPE) and additionally
notifies when stderr is not a tty.

Verified: 14 behaviour tests, the EPIPE case (`md2rich 2>&1 | head -1` still
converts), and a detached dmenu-style launch of both tools.

Test note: `script -qec` kills the process group on exit, which takes rich2md's
`xclip -i` daemon with it and looks like a lost clipboard. It is a harness
artifact -- under `setsid --fork` (what a launcher actually does) the daemon
survives. md2rich is immune because richclip double-forks and setsid's itself.
