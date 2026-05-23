# NAS access for agents

Short briefing on how to SSH into the Synology NAS that hosts Patrick, and how to interact with it once you're in. Read this before running anything.

## Connect

```bash
ssh dyte@100.93.48.122
```

- `100.93.48.122` is the NAS's **Tailscale** IP. It is only reachable from devices on the `dieterwalckiers.github` tailnet — there is no public route. If `ssh` hangs, you are not on the tailnet.
- Auth is **key-only** (`~/.ssh/id_ed25519` on the calling workstation). Password auth is off, root SSH is off.
- LAN address `192.168.0.184` also works when on the home LAN, but prefer the Tailscale IP — it works everywhere and matches the rest of the docs.
- DSM UI (if you ever need it, rare for agents): `http://100.93.48.122:5000` or `https://walckickx-cloud.tailc31836.ts.net/`.

## Who you are once you're in

- User: **`dyte`**, `PUID=1026`, `PGID=100` (group `users`).
- `sudo` works (password may be required for some commands; if you don't have it, ask).
- Shell is bash. Home is `/var/services/homes/dyte/`.

## Critical environment facts

These trip people up. Internalize them before running commands.

- **Docker storage lives on `/volume2`, not `/volume1`.** All Patrick services are under `/volume2/docker/<service>/` (e.g. `/volume2/docker/patrick-bridge/`, `/volume2/docker/holyclaude/`). Patrick's Obsidian vault is at `/volume2/patrick-vault/`.
- **Timezone is `Europe/Brussels`.** Host scheduled scripts assume local time; `datetime.now()` returns Brussels time.
- **System Python is 3.8.** No `zoneinfo`, no `match` statements, no walrus-in-comprehension surprises. If you write Python that runs on the host (not in a container), target 3.8.
- **`tailscale` is not on `$PATH`.** Full path: `/var/packages/Tailscale/target/bin/tailscale`.
- **DSM is opinionated about its config.** Do not edit `/etc/ssh/sshd_config`, do not restart `sshd`, do not touch DSM's package directories. DSM updates may already reset `sshd_config` on us — don't make it worse.
- **Don't break SSH.** It is your only way in. No `iptables`, no firewall changes, no user/group edits, no `chsh`. If you'd lock yourself out, stop and ask.

## Docker

- `docker` and `docker compose` work as `dyte` (no sudo needed for the daemon socket, member of the docker group).
- Key containers: **`holyclaude`** (the Claude Code dev env, has `/workspace` mounted), **`patrick-bridge`** (Telegram bridge), **`syncthing`** (vault sync).
- Exec into HolyClaude: `docker exec -it holyclaude bash`. Inside, code is at `/workspace`, vault is at `/vault`.
- Compose files are next to each service: `cd /volume2/docker/patrick-bridge && docker compose ps` etc.
- Logs: `docker logs --tail=200 -f <container>`.

## Patrick bridge HTTP API

If you need to send a Telegram message from a host script:

- URL: `http://127.0.0.1:18080/api/send` (loopback only — not exposed on the LAN).
- Auth: `X-Bridge-Token: <token>`, where the token lives at `/volume2/docker/patrick-bridge/secrets/bridge_api_token` (mode 640; readable as `dyte`).
- Inside the `patrick-net` docker network, containers reach the bridge as `http://patrick-bridge:8080`.

## Where the source of truth lives

- **README** at `/volume2/docker/...` deploy paths — but the canonical repo is the workstation copy at `/home/dyte/source/patrick/` (this repo). The NAS does not hold the git remote.
- `plans/` in this repo holds dated decision logs. If something on the NAS looks weird, there is usually a plan explaining why. Don't "fix" non-obvious config without checking.

## Things to do, things not to do

Do:
- Read files, tail logs, run `docker ps` / `docker logs`, exec into containers, inspect compose files.
- Use absolute paths. Quote paths that contain spaces.
- When changing anything persistent, prefer editing the file at its bind-mount source on the host (under `/volume2/docker/<service>/`) rather than inside the container.

Don't:
- Don't `docker system prune`, `docker volume rm`, or remove any container's named volume.
- Don't `rm -rf` anything under `/volume2/patrick-vault/` or `/volume2/obsidian-vault/` — those are live, syncing vaults.
- Don't restart `syncthing` casually; it has known watcher quirks and re-indexing is slow.
- Don't open any port on the LAN or router. Everything stays tailnet- or loopback-bound.
- Don't run package updates (`synopkg`, DSM update), don't reboot the NAS.

## When in doubt

Stop and report what you were about to do. The NAS is a single-host production environment for Patrick — there is no staging copy.

