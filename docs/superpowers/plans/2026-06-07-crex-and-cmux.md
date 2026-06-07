# Add crex and Remove cmux Initialization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `drolosoft/tap/crex` to Brewfile/profile and remove `cmux` initialization from `.zshrc`.

**Architecture:** We will declare `drolosoft/tap` tap and `crex` formula in the `Brewfile` (which manages package profile configuration), update tests and README accordingly, and clean up the `cmux` loading code from `.zshrc`.

**Tech Stack:** Homebrew, Zsh scripting, Bash testing.

---

### Task 1: Update `.zshrc` to remove cmux shell initialization

**Files:**
- Modify: `.zshrc:130`

- [ ] **Step 1: Edit .zshrc to remove cmux shell hook**

Remove line 130 in `.zshrc`:
```bash
command -v cmux >/dev/null 2>&1 && eval "$(cmux shell zsh)"
```

- [ ] **Step 2: Verify syntax of modified .zshrc**

Run: `zsh -n .zshrc`
Expected: Exits with status 0 (no syntax errors).

- [ ] **Step 3: Commit**

Run:
```bash
git add .zshrc
git commit -m "style: remove cmux shell initialization from zshrc"
```

---

### Task 2: Update `Brewfile` to add `drolosoft/tap` and `crex`

**Files:**
- Modify: `Brewfile:29-30`

- [ ] **Step 1: Add tap and formula to Brewfile**

Modify `Brewfile` around line 29:
```diff
 zsh-syntax-highlighting
 brew "zsh-completions"
 
+tap "drolosoft/tap"
+brew "crex"
+
 tap "manaflow-ai/cmux"
 cask "cmux"
```

- [ ] **Step 2: Commit**

Run:
```bash
git add Brewfile
git commit -m "feat: add drolosoft/tap and crex to Brewfile"
```

---

### Task 3: Update `tests/test-repo.sh` to include `crex` assertions

**Files:**
- Modify: `tests/test-repo.sh:30-36`

- [ ] **Step 1: Add crex to list of expected Brewfile packages**

Modify `tests/test-repo.sh`:
```diff
 for formula in \
   eza bat fd ripgrep fzf zoxide atuin starship gh git-delta lazygit yazi \
   jq yq mise direnv bottom dust duf hyperfine zellij just uv ast-grep gum \
-  zsh-autosuggestions zsh-syntax-highlighting zsh-completions
+  zsh-autosuggestions zsh-syntax-highlighting zsh-completions crex
 do
   assert_contains Brewfile "brew \"$formula\""
 done
```

- [ ] **Step 2: Verify tests fail temporarily due to README not updated yet**

Run: `bash tests/test-repo.sh`
Expected: Passes tests up to the README validation, or passes if README isn't asserting `crex` yet (it doesn't look like `test-repo.sh` checks the full packages list in `README.md`, but it's good to check).

- [ ] **Step 3: Commit**

Run:
```bash
git add tests/test-repo.sh
git commit -m "test: assert crex presence in Brewfile"
```

---

### Task 4: Update `README.md` to document `crex`

**Files:**
- Modify: `README.md:104-105`, `README.md:115-116`

- [ ] **Step 1: Add drolosoft/tap/crex to manual installation list in README.md**

Modify `README.md` around line 104:
```diff
   zsh-autosuggestions \
   zsh-syntax-highlighting \
-  zsh-completions
+  zsh-completions \
+  drolosoft/tap/crex
```

- [ ] **Step 2: Add crex to the package reference list in README.md**

Modify `README.md` around line 115:
```diff
 | Type | Packages |
 | --- | --- |
-| Formulae | `eza`, `bat`, `fd`, `ripgrep`, `fzf`, `zoxide`, `atuin`, `starship`, `gh`, `git-delta`, `lazygit`, `yazi`, `jq`, `yq`, `mise`, `direnv`, `bottom`, `dust`, `duf`, `hyperfine`, `zellij`, `just`, `uv`, `ast-grep`, `gum`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions` |
+| Formulae | `eza`, `bat`, `fd`, `ripgrep`, `fzf`, `zoxide`, `atuin`, `starship`, `gh`, `git-delta`, `lazygit`, `yazi`, `jq`, `yq`, `mise`, `direnv`, `bottom`, `dust`, `duf`, `hyperfine`, `zellij`, `just`, `uv`, `ast-grep`, `gum`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`, `crex` |
```

- [ ] **Step 3: Commit**

Run:
```bash
git add README.md
git commit -m "docs: add crex package information to README"
```

---

### Task 5: Final Validation

**Files:**
- Run: `bash tests/test-repo.sh`

- [ ] **Step 1: Run complete repository validation test suite**

Run: `bash tests/test-repo.sh`
Expected: Exits with code 0 (all checks pass).
