#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

info() {
  printf '\033[1;34m==>\033[0m %s\n' "$1"
}

success() {
  printf '\033[1;32mOK\033[0m %s\n' "$1"
}

backup_path() {
  local target="$1"

  if [[ -L "$target" && "$(readlink "$target")" == "$ROOT/"* ]]; then
    rm "$target"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR$(dirname "$target")"
    mv "$target" "$BACKUP_DIR$target"
    success "Backed up $target"
  fi
}

link_file() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"
  backup_path "$target"
  ln -s "$source" "$target"
  success "Linked $target"
}

if ! command -v brew >/dev/null 2>&1; then
  printf 'Homebrew is required before running this installer.\n' >&2
  printf 'Install it from https://brew.sh, then rerun ./install.sh\n' >&2
  exit 1
fi

info "Updating Homebrew"
brew update

info "Installing packages from Brewfile"
brew bundle --file "$ROOT/Brewfile"

info "Linking shell and terminal configs"
link_file "$ROOT/.zshrc" "$HOME/.zshrc"
link_file "$ROOT/ghostty/config" "$HOME/.config/ghostty/config"
link_file "$ROOT/starship.toml" "$HOME/.config/starship.toml"

info "Validating linked Zsh config"
zsh -n "$ROOT/.zshrc"

success "Done. Open a new terminal tab or restart Ghostty."
