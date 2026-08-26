# azhp2bk-bootstrap

Idempotent workstation bootstrap for **Ubuntu 24.04 + Regolith (X11)**.

```text
./bootstrap.sh
  → install Ansible (+ collections)
  → ansible-playbook site.yml
```

Recommended path: install **Ubuntu Server 24.04** (headless), run this repo, reboot into Regolith X11 on the local display.

## Quick start (Ubuntu Server → Regolith X11)

### 1. Base OS

- Install **Ubuntu Server 24.04 LTS**.
- Create your user, enable **OpenSSH**.
- SSH in: `ssh you@new-host`.

### 2. First login (still headless)

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl

# Passwordless sudo (bootstrap uses become without interactive prompts)
sudo visudo   # add: <you> ALL=(ALL) NOPASSWD:ALL
```

### 3. GitHub SSH (bootstrap + chezmoi)

```bash
ssh-keygen -t ed25519 -C "hp2-regolith" -f ~/.ssh/id_ed25519 -N ""
cat ~/.ssh/id_ed25519.pub
# Add the key on GitHub, then:
ssh -T git@github.com
```

### 4. Run bootstrap

```bash
git clone git@github.com:1adn/azhp2bk-bootstrap.git
cd azhp2bk-bootstrap
./bootstrap.sh
```

Useful flags:

```bash
./bootstrap.sh --tags folders,devtools
./bootstrap.sh --skip-dotfiles          # if GitHub SSH for dotfiles isn’t ready
./bootstrap.sh --inventory-only
./bootstrap.sh --check                  # ansible --check
./bootstrap.sh --skip-tags desktop,desktop_regolith   # pure server, no GUI
```

### 5. Reboot into Regolith (local display)

```bash
sudo reboot
```

At the greeter, select **Regolith** (X11 / flashback — **not** Sway).  
SSH alone will not show the desktop; use the machine’s monitor/KVM after reboot.

### 6. After first GUI login

- Check `~/code/devops/docs/workstation-inventory.md`.
- Populate dots: `chezmoi add …` → push to [`hp2arch-dotfiles`](https://github.com/1adn/hp2arch-dotfiles).
- Clone product repos into `~/code/{saral,anuvarta,devops,mobile}/git/`.
- `az login`, `gh auth login`, and re-login (or `newgrp docker`) for the docker group.

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

## Headless note

Bootstrap **installs** a desktop stack; it does not replace a monitor.  
For a server with no GUI intent, use `--skip-tags desktop,desktop_regolith`.  
For the Regolith migrate, leave desktop enabled and use the physical display after reboot.
