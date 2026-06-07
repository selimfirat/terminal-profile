# Design Spec: Add crex and remove cmux initialization

## Goal
Add `drolosoft/tap/crex` to profile (Brewfile) and remove cmux initialization from `.zshrc`.

## Proposed Changes

### 1. Brewfile
- Add the tap and formula:
  ```ruby
  tap "drolosoft/tap"
  brew "crex"
  ```
- Keep the existing `cmux` tap and cask.

### 2. .zshrc
- Remove:
  ```bash
  command -v cmux >/dev/null 2>&1 && eval "$(cmux shell zsh)"
  ```

### 3. README.md
- Add `crex` to the manual Homebrew installation command list.
- Add `crex` to the "Package Reference" section.

### 4. tests/test-repo.sh
- Add `crex` to the list of formulae that `test-repo.sh` asserts are in the `Brewfile`.

## Verification
- Run `bash tests/test-repo.sh` to ensure the repository state is correct and zsh config syntax is valid.
