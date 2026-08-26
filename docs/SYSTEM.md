# System map — azhp2bk workstation

Intended state for **Ubuntu 24.04 LTS + Regolith Desktop on X11** (same HW class as previous Omarchy/Arch box).

Provisioning: [`bootstrap.sh`](../bootstrap.sh) → Ansible `site.yml`.  
Dotfiles: Chezmoi from [`1adn/hp2arch-dotfiles`](https://github.com/1adn/hp2arch-dotfiles).

## Desktop

| Item | Choice |
|------|--------|
| Session | Regolith **X11** via `regolith-session-flashback` |
| Not default | `regolith-session-sway` (Wayland) |
| Look | `regolith-look-lascaille` (override in vars if desired) |
| Browser | Google Chrome (single browser) |
| Terminal | Alacritty |
| File manager | Thunar |

## Project layout

```text
~/code/
├── saral/{git,docs,local,files}
├── anuvarta/{git,docs,local,files}
├── devops/{git,docs,local,files}
├── mobile/{git,docs,local,files,sdk/…}
├── personal/{git,docs,local,files}
└── archive/{git,docs,local,files}
```

- **No** parallel meta-trees (`black`, `anuv` as second homes).
- Secrets and overlays live in `local/` (gitignored).
- Product git clones are **manual** (or a future tagged role) — not part of default bootstrap.

## Workstreams (day-1 parity)

| Domain | Stack highlights |
|--------|------------------|
| Saral | .NET SDK, Docker, Azure CLI, Node (mise), Ansible |
| Anuvarta | Node/mise, wrangler via npm when needed, Cursor |
| DevOps | Ansible, Azure CLI, Docker, gh |
| Mobile | Flutter under `~/code/mobile/sdk/flutter`, Android cmdline README; Studio optional |

## Ansible roles

| Role | Default | Notes |
|------|---------|--------|
| `base` | yes | apt basics, IST timezone, ufw |
| `desktop_regolith` | yes | Regolith X11 + minimal apps |
| `devtools` | yes | docker, mise, az, gh, dotnet |
| `mobile` | yes | Flutter clone + SDK dirs |
| `folders` | yes | domain tree |
| `dotfiles` | yes | chezmoi init/apply (`--skip-dotfiles` to skip) |
| `inventory` | yes | writes `~/code/devops/docs/workstation-inventory.md` |

Refresh inventory only:

```bash
./bootstrap.sh --inventory-only
```

## Out of scope (by design)

- Cloning private Saral/Anuvarta remotes
- Omarchy / Hyprland config ports
- Snap package sprawl
- Committing secrets into bootstrap or public dotfiles

## Related repos

| Repo | Role |
|------|------|
| `1adn/azhp2bk-bootstrap` | This repo — machine provisioning |
| `1adn/hp2arch-dotfiles` | Chezmoi source state |
