# azhp2bk-bootstrap

Idempotent workstation bootstrap for **Ubuntu 24.04 + Regolith (X11)**.

```text
./bootstrap.sh
  → install Ansible (+ collections)
  → ansible-playbook site.yml
```

## Quick start

On a fresh Regolith/Ubuntu 24.04 system:

```bash
git clone git@github.com:1adn/azhp2bk-bootstrap.git
cd azhp2bk-bootstrap
./bootstrap.sh
```

Useful flags (passed through to Ansible where noted):

```bash
./bootstrap.sh --tags folders,devtools
./bootstrap.sh --skip-dotfiles
./bootstrap.sh --inventory-only
./bootstrap.sh --check          # ansible --check
```

## What it sets up

| Role | Purpose |
|------|---------|
| `base` | apt basics, timezone, ufw |
| `desktop_regolith` | Regolith **X11** (flashback) session + minimal apps |
| `devtools` | Docker, mise/Node, Azure CLI, gh, .NET SDK, Cursor notes |
| `mobile` | Android cmdline tools + Flutter SDK path (Studio optional) |
| `folders` | `~/code/{saral,anuvarta,devops,mobile,personal,archive}/…` |
| `dotfiles` | Chezmoi → [`hp2arch-dotfiles`](https://github.com/1adn/hp2arch-dotfiles) |
| `inventory` | Writes `~/code/devops/docs/workstation-inventory.md` |

See [`docs/SYSTEM.md`](docs/SYSTEM.md) for the intended system map.

## Layout

```text
bootstrap.sh
ansible.cfg
site.yml
inventory/hosts.yml
group_vars/all.yml
requirements.yml
roles/
docs/SYSTEM.md
```

## Secrets

Do not put API keys, SSH private keys, or `.env` files in this repo.  
Use a password manager, chezmoi age-encryption, or `~/code/<domain>/local/` (gitignored).
