# Terminal Profile

[![CI](https://img.shields.io/github/actions/workflow/status/selimfirat/terminal-profile/ci.yml?branch=main&style=for-the-badge&label=CI)](https://github.com/selimfirat/terminal-profile/actions/workflows/ci.yml)
[![macOS](https://img.shields.io/badge/macOS-ready-111827?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Zsh](https://img.shields.io/badge/Zsh-fast_shell-0f766e?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.zsh.org/)
[![Ghostty](https://img.shields.io/badge/Ghostty-terminal-7c3aed?style=for-the-badge)](https://ghostty.org/)
[![Homebrew](https://img.shields.io/badge/Homebrew-managed-fbbf24?style=for-the-badge&logo=homebrew&logoColor=111827)](https://brew.sh/)
[![License: MIT](https://img.shields.io/badge/License-MIT-111827?style=for-the-badge)](LICENSE)

A fast, tidy macOS terminal setup for Zsh and Ghostty. It installs the command-line tools with Homebrew, links the tracked configs into your home directory, and backs up anything it would replace.

Repository: [github.com/selimfirat/terminal-profile](https://github.com/selimfirat/terminal-profile)

## Quick Start

```bash
git clone https://github.com/selimfirat/terminal-profile.git ~/terminal-profile
cd ~/terminal-profile
./install.sh
```

Restart Ghostty or open a new terminal tab after installation.

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
| System utilities | bottom, dust, duf, hyperfine |
| Friendly CLI output | eza, bat, gum |
| Multiplexing | Zellij |

## Config Files

| Repository file | Installed location |
| --- | --- |
| `.zshrc` | `~/.zshrc` |
| `ghostty/config` | `~/.config/ghostty/config` |
| `starship.toml` | `~/.config/starship.toml` |

Existing files are moved into `~/.dotfiles-backup/<timestamp>/` before links are created.

## Installer

`install.sh` does four things:

1. Checks that Homebrew is available.
2. Runs `brew update`.
3. Installs packages from `Brewfile` with `brew bundle --file`.
4. Backs up existing config files and symlinks this repo's files into place.

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
  zsh-completions

brew install --cask \
  ghostty \
  font-jetbrains-mono-nerd-font
```

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

## Design Notes

- The `.zshrc` guards Homebrew-specific paths so an unset prefix cannot accidentally produce paths like `/bin` or `/share/...`.
- Ghostty config is installed at `~/.config/ghostty/config`, matching the existing local setup.
- The font is `JetBrainsMono Nerd Font`, because it is installed by the Brewfile.
- Completions use a cached `.zcompdump` and `compinit -C` after the first run for faster shell startup.

## Publishing Notes

Suggested GitHub repository settings:

- Description: `Fast macOS Zsh and Ghostty dotfiles with Homebrew install automation.`
- Topics: `dotfiles`, `zsh`, `ghostty`, `homebrew`, `macos`, `starship`, `fzf`, `atuin`, `zoxide`
- Visibility: public
- Default branch: `main`

## License

MIT License. See [LICENSE](LICENSE).
