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

copy_file() {
  local source="$1"
  local target="$2"

  if [[ -L "$target" ]]; then
    backup_path "$target"
  elif [[ -f "$target" ]]; then
    if cmp -s "$source" "$target"; then
      success "$target is up to date"
      return
    fi
    backup_path "$target"
  fi

  mkdir -p "$(dirname "$target")"
  cp "$source" "$target"
  success "Copied $target"
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

info "Copying shell and terminal configs"
copy_file "$ROOT/.zshrc" "$HOME/.zshrc"
copy_file "$ROOT/ghostty/config" "$HOME/.config/ghostty/config"

info "Generating Starship preset"
mkdir -p "$HOME/.config"
backup_path "$HOME/.config/starship.toml"
starship preset catppuccin-powerline -o ~/.config/starship.toml

info "Validating copied Zsh config"
zsh -n "$ROOT/.zshrc"

success "Done. Open a new terminal tab or restart Ghostty."
