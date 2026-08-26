#!/usr/bin/env bash
# Idempotent entrypoint: ensure Ansible, then run site.yml
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

SKIP_DOTFILES=0
INVENTORY_ONLY=0
ANSIBLE_ARGS=()

usage() {
  cat <<'EOF'
Usage: ./bootstrap.sh [options] [-- ansible-args...]

Options:
  --skip-dotfiles    Skip the chezmoi/dotfiles role
  --inventory-only   Only run the inventory role
  --tags TAGS        Ansible --tags (comma-separated)
  --skip-tags TAGS   Ansible --skip-tags
  --check            Ansible check mode
  -h, --help         Show this help

Examples:
  ./bootstrap.sh
  ./bootstrap.sh --tags folders,devtools
  ./bootstrap.sh --skip-dotfiles
  ./bootstrap.sh --inventory-only
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --skip-dotfiles)
      SKIP_DOTFILES=1
      shift
      ;;
    --inventory-only)
      INVENTORY_ONLY=1
      shift
      ;;
    --tags)
      ANSIBLE_ARGS+=(--tags "$2")
      shift 2
      ;;
    --skip-tags)
      ANSIBLE_ARGS+=(--skip-tags "$2")
      shift 2
      ;;
    --check)
      ANSIBLE_ARGS+=(--check)
      shift
      ;;
    --)
      shift
      ANSIBLE_ARGS+=("$@")
      break
      ;;
    *)
      ANSIBLE_ARGS+=("$1")
      shift
      ;;
  esac
done

log() { printf '==> %s\n' "$*"; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

install_ansible() {
  if need_cmd ansible-playbook && need_cmd ansible-galaxy; then
    log "Ansible already present: $(ansible-playbook --version | head -1)"
    return 0
  fi

  if [[ "$(id -u)" -eq 0 ]]; then
    SUDO=""
  else
    SUDO="sudo"
  fi

  log "Installing Ansible via apt"
  $SUDO apt-get update -y
  $SUDO DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ansible python3-pip python3-venv ca-certificates curl gnupg git

  log "Ansible installed: $(ansible-playbook --version | head -1)"
}

install_collections() {
  if [[ -f "$ROOT/requirements.yml" ]]; then
    log "Installing Ansible collections from requirements.yml"
    ansible-galaxy collection install -r "$ROOT/requirements.yml" --upgrade
  fi
}

run_playbook() {
  local extra=()
  if [[ "$INVENTORY_ONLY" -eq 1 ]]; then
    extra+=(--tags inventory)
  elif [[ "$SKIP_DOTFILES" -eq 1 ]]; then
    extra+=(--skip-tags dotfiles)
  fi

  log "Running ansible-playbook site.yml"
  ansible-playbook "$ROOT/site.yml" "${extra[@]}" "${ANSIBLE_ARGS[@]}"
}

main() {
  if [[ ! -f /etc/os-release ]] || ! grep -q 'ID=ubuntu' /etc/os-release; then
    log "Warning: this bootstrap targets Ubuntu 24.04 + Regolith X11"
  fi

  install_ansible
  install_collections
  run_playbook
  log "Done. See docs/SYSTEM.md and ~/code/devops/docs/workstation-inventory.md"
}

main
