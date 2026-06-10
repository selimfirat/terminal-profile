# ------------------------------------------------------------
# Environment
# ------------------------------------------------------------
export LANG=en_US.UTF-8
export EDITOR="${EDITOR:-code --wait}"
export VISUAL="${VISUAL:-$EDITOR}"

typeset -U path PATH fpath FPATH

# ------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------
if [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d /usr/local/Homebrew ]]; then
  export HOMEBREW_PREFIX="/usr/local"
fi

if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  path=(
    "$HOMEBREW_PREFIX/bin"
    "$HOMEBREW_PREFIX/sbin"
    $path
  )

  [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]] &&
    fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

  [[ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]] &&
    fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
fi

path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/.local/share/mise/shims"
  $path
)

# Visual Studio Code
[[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]] &&
  path=("/Applications/Visual Studio Code.app/Contents/Resources/app/bin" $path)

export PATH

# ------------------------------------------------------------
# Shell options
# ------------------------------------------------------------
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
mkdir -p "${HISTFILE:h}"

# ------------------------------------------------------------
# Modern CLI aliases
# ------------------------------------------------------------
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -lh --icons=auto --group-directories-first --git'
  alias la='eza -lah --icons=auto --group-directories-first --git'
  alias lt='eza --tree --icons=auto --group-directories-first --level=2'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

alias g='git'
alias gs='git status --short'
alias gd='git diff'
alias lg='lazygit'
alias yz='yazi'
alias agyd='agy --dangerously-skip-permissions'

# ------------------------------------------------------------
# Completions
# ------------------------------------------------------------
autoload -Uz compinit

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR"

zcompdump="$ZSH_CACHE_DIR/.zcompdump"

if [[ ! -f "$zcompdump" ]]; then
  compinit -d "$zcompdump"
else
  compinit -C -d "$zcompdump"
fi

# ------------------------------------------------------------
# Prompt
# ------------------------------------------------------------
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# ------------------------------------------------------------
# FZF
# ------------------------------------------------------------
if command -v fzf >/dev/null 2>&1; then
  if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
    [[ -r "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]] &&
      source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"

    [[ -r "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ]] &&
      source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
  fi

  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {} 2>/dev/null'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --icons=auto --level=2 {} 2>/dev/null'"
fi

# ------------------------------------------------------------
# Navigation, history, and project environments
# ------------------------------------------------------------
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
  bindkey '^[[A' atuin-up-search
fi

command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"

bindkey -s '^G' 'crex pop\n' # crex-pop-hook

# ------------------------------------------------------------
# Lazy Conda setup
# ------------------------------------------------------------
CONDA_HOME="$HOME/miniconda3"

if [[ -d "$CONDA_HOME/bin" ]]; then
  path=("$CONDA_HOME/bin" $path)
  export PATH
fi

conda() {
  unset -f conda

  if [[ -f "$CONDA_HOME/etc/profile.d/conda.sh" ]]; then
    source "$CONDA_HOME/etc/profile.d/conda.sh"
  elif [[ -x "$CONDA_HOME/bin/conda" ]]; then
    export PATH="$CONDA_HOME/bin:$PATH"
  else
    echo "Conda not found at $CONDA_HOME"
    return 1
  fi

  conda "$@"
}

# ------------------------------------------------------------
# Plugins last
# ------------------------------------------------------------
if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  [[ -r "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

  [[ -r "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
