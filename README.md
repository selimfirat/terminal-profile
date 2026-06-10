# Terminal Profile

[![CI](https://img.shields.io/github/actions/workflow/status/selimfirat/terminal-profile/ci.yml?branch=main&style=for-the-badge&label=CI)](https://github.com/selimfirat/terminal-profile/actions/workflows/ci.yml)
[![macOS](https://img.shields.io/badge/macOS-ready-111827?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![License](https://img.shields.io/github/license/selimfirat/terminal-profile?style=for-the-badge&color=111827)](LICENSE)

A compact macOS terminal profile for Zsh and Ghostty. It installs a modern CLI toolkit with Homebrew, copies the tracked configs into your home directory, and backs up anything it would replace.

## Quick Start

Install Homebrew first if it is not already available:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then clone and install this profile:

```bash
git clone https://github.com/selimfirat/terminal-profile.git ~/terminal-profile
cd ~/terminal-profile
./install.sh
```

Restart Ghostty or open a new terminal tab after installation.

## What The Installer Changes

`install.sh` is intentionally small and explicit:

1. Runs `brew update`.
2. Installs everything in `Brewfile` with `brew bundle --file`.
3. Backs up existing files into `~/.dotfiles-backup/<timestamp>/`.
4. Copies `.zshrc` to `~/.zshrc`.
5. Copies `ghostty/config` to `~/.config/ghostty/config`.
6. Generates `~/.config/starship.toml` with the Catppuccin Powerline preset.
7. Validates the Zsh config with `zsh -n`.

## What's Included

| Area | Tools |
| --- | --- |
| Shell | Zsh, completions, autosuggestions, syntax highlighting |
| Prompt | Starship |
| Terminal | Ghostty, JetBrains Mono Nerd Font |
| Navigation | FZF, Zoxide, Yazi |
| History | Atuin |
| Developer workflow | GitHub CLI, Lazygit, Git Delta, Just, Mise, Direnv, uv |
| Search and code | Ripgrep, fd, ast-grep, jq, yq |
| System utilities | bottom, htop, dust, duf, hyperfine, watch |
| Friendly CLI output | eza, bat, gum |
| Multiplexing | Zellij |

## Config Files

| Repository file | Installed location |
| --- | --- |
| `.zshrc` | `~/.zshrc` |
| `ghostty/config` | `~/.config/ghostty/config` |

The installer also generates `~/.config/starship.toml` with:

```bash
starship preset catppuccin-powerline -o ~/.config/starship.toml
```

Existing files are moved into `~/.dotfiles-backup/<timestamp>/` before copies are made.

## Manual Homebrew Commands

The installer runs these commands through `brew bundle`, but the equivalent manual commands are:

```bash
brew update

brew install \
  eza \
  bat \
  fd \
  ripgrep \
  fzf \
  zoxide \
  atuin \
  starship \
  gh \
  git-delta \
  lazygit \
  yazi \
  jq \
  yq \
  mise \
  direnv \
  bottom \
  htop \
  dust \
  duf \
  hyperfine \
  zellij \
  just \
  uv \
  ast-grep \
  gum \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zsh-completions \
  watch \
  drolosoft/tap/crex

brew install --cask \
  ghostty \
  font-jetbrains-mono-nerd-font
```

## Package Reference

| Type | Packages |
| --- | --- |
| Formulae | `eza`, `bat`, `fd`, `ripgrep`, `fzf`, `zoxide`, `atuin`, `starship`, `gh`, `git-delta`, `lazygit`, `yazi`, `jq`, `yq`, `mise`, `direnv`, `bottom`, `htop`, `dust`, `duf`, `hyperfine`, `zellij`, `just`, `uv`, `ast-grep`, `gum`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`, `crex`, `watch` |
| Casks | `ghostty`, `font-jetbrains-mono-nerd-font` |

## Benchmark

Measured on this machine with the currently installed `~/.zshrc`:

```text
hyperfine 'zsh -i -c exit'
Time (mean +/- sigma): 83.2 ms +/- 25.8 ms [User: 40.5 ms, System: 30.1 ms]
Range (min ... max): 61.9 ms ... 152.7 ms, 19 runs
```

Measured against this repository's checked-in `.zshrc` after the first cache-building run:

```text
hyperfine 'ZDOTDIR="$PWD" zsh -i -c exit'
Time (mean +/- sigma): 91.8 ms +/- 11.6 ms [User: 48.7 ms, System: 34.9 ms]
Range (min ... max): 82.9 ms ... 125.6 ms, 25 runs
```

## License

MIT License. See [LICENSE](LICENSE).
