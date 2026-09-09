# markdown-clipboard

`md2rich` and `rich2md` -- markdown to rich text and back.

## md2rich

Markdown in, rich text on the clipboard. Paste straight into Google Docs,
Gmail, Slack, Notion, Confluence or any other WYSIWYG editor.

```
md2rich                 convert the markdown already in the clipboard
md2rich notes.md        convert a file
cat notes.md | md2rich  convert stdin
md2rich -c              convert the last Claude Code /copy output
md2rich -e              open $EDITOR to paste/write markdown, convert on save
```

The everyday loop is: copy some markdown, run `md2rich`, press ctrl+v.

## How it works

`pandoc` renders the markdown to HTML, then `richclip` (a small GTK4 helper)
takes ownership of the X11 CLIPBOARD selection and offers **two** flavours:

| target       | what you get                        |
|--------------|-------------------------------------|
| `text/html`  | the rich text, used by WYSIWYG apps |
| `text/plain` | the original markdown source        |

That second one matters. `xclip -t text/html` can only advertise a single
target, so pasting into a plain text field gives you raw HTML tags. Serving
both means the same clipboard does the right thing everywhere.

`richclip` backgrounds itself and holds the selection until you copy
something else, exactly like `xclip` does.

## Notes

- Input is parsed as GitHub Flavored Markdown: tables, task lists,
  strikethrough and autolinks all work.
- Task list checkboxes are rendered as ☒ / ☐ glyphs, because editors strip
  `<input>` elements and would otherwise silently drop them.
- Syntax highlighting is off. Pandoc styles code with CSS classes that
  WYSIWYG editors discard, leaving only the empty line-anchors behind.
- Images referenced by local path will not travel with the paste.

## Install

```sh
./install.sh
```

Needs `pandoc`, `xclip` and python3 GTK4 bindings (`python3-gi`,
`gir1.2-gtk-4.0`). X11 only -- on Wayland `wl-copy --type text/html` covers
the same ground natively.


# rich2md

The mirror image: rich text on the clipboard, markdown out. Copy from Google
Docs, Gmail or a web page, then run it.

```
rich2md                 convert the clipboard, and put the markdown back on it
rich2md page.html       convert a file
cat page.html | rich2md convert stdin
rich2md > notes.md      redirect, and the clipboard is left alone
rich2md -o              print instead of touching the clipboard
```

## Why this needs more than `pandoc -f html`

Pandoc's HTML reader only understands semantic tags, but rich editors emit
presentation. Straight conversion of a Google Docs paste gives you a wall of
`<span style="...">` passed through as raw HTML. Four things get fixed:

- **Emphasis is inline CSS.** `font-weight:700` and `font-style:italic` become
  real `**bold**` and `*italic*`, via `html+native_spans` plus a Lua filter.
- **A `<b>` that is not bold.** Docs wraps the whole fragment in
  `<b style="font-weight:normal" id="docs-internal-guid-...">`. Left alone it
  turns the entire document bold. Stripping the opening tag is enough --
  pandoc shrugs off the orphaned `</b>`.
- **Links behind a redirector.** Docs rewrites every link to
  `google.com/url?q=<real target>`. The filter unwraps them.
- **Tables with no header.** A pasted table has no `<thead>`, so pandoc invents
  an empty header and demotes the real one into the body. The filter promotes
  it back.

Lists also get tightened, since editors wrap each item's text in a `<p>`.

`md2rich | rich2md` round trips cleanly, task list checkboxes included.

## Launching from dmenu / an i3 binding

Both tools work from `dmenu_run` (super+space) as well as a shell. That needed
care: a GUI launcher hands the process `/dev/null` on stdin, which is *not* a
tty but is also not a pipe. Testing `[[ ! -t 0 ]]` to mean "something was piped
in" therefore read an empty stdin and converted nothing -- silently, since
there is no terminal to print the error to.

So the test is `[[ -p /dev/stdin || -f /dev/stdin ]]` (a real pipe or
redirected file) rather than "not a tty".

Progress always goes to stderr, so a redirected log never comes out empty; when
stderr is not a terminal it *additionally* raises a `notify-send` notification,
which is the only feedback a GUI launch can give.

`md2rich -e` is the exception: it needs a terminal for `$EDITOR`, and says so
rather than failing silently.

Two more things a GUI launch exposed:

- **PATH.** dmenu inherits i3's PATH, which has no `/home/linuxbrew/.linuxbrew/bin`
  -- so `md2rich` was found but `pandoc` was not. Both scripts now append the
  usual package-manager prefixes themselves rather than relying on the session
  PATH. (Fixing it in your i3 config would work too, but this way the tools are
  self-contained.)
- **Clipboard targets.** `xclip -o` asks for `STRING` by default, and an owner
  that only advertises `UTF8_STRING` hands back nothing -- indistinguishable
  from an empty clipboard. Reads now try `UTF8_STRING`,
  `text/plain;charset=utf-8`, `text/plain` and `STRING` in turn.
- **Empty pipes.** dmenu here runs commands through fish, which hands them an
  *empty pipe* on stdin -- byte for byte indistinguishable from
  `cat notes.md | md2rich` until you read it. So md2rich tries stdin and falls
  back to the clipboard when it yields nothing, rather than trusting any
  file-descriptor test. rich2md does the same, and only writes to stdout for
  `-o` or a real file, since a bare pipe may lead nowhere.


## Claude Code's `/copy` (`md2rich -c`)

`/copy` reports success but the text never reaches the clipboard here. It writes
an OSC 52 terminal escape, and **gnome-terminal ignores OSC 52** -- verified by
emitting one by hand and watching the clipboard stay untouched:

    payload=$(printf 'OSC52-WORKED' | base64 -w0)
    gnome-terminal --wait -- bash -c "printf '\033]52;c;%s\a' '$payload'"
    xclip -selection clipboard -o     # unchanged

Nothing in `/copy` can detect that, so it reports a success that did not happen.

`/copy` also writes the response to `/tmp/claude-<uid>/response.md`, and that is
what `md2rich -c` reads. It reports the file's age, so a stale one is obvious:

    md2rich: 64 words on the clipboard as rich text -- paste away. (from /copy, 12s ago)

Two caveats worth knowing:

- That path has no session id, so concurrent Claude sessions share one file --
  the most recent `/copy` wins. Fine in practice, since you run `/copy` and then
  `md2rich -c` straight after.
- If the response is *entirely* one fenced markdown block, `-c` unwraps it;
  converting that to a code block is never what you want. Only for a
  markdown-tagged fence, and only when it wraps the whole file, so a ```python
  block stays code.

The real fix is a terminal that honours OSC 52 (kitty, alacritty, wezterm,
foot) -- then `/copy` populates the clipboard directly and plain `md2rich`
works with no flag.
