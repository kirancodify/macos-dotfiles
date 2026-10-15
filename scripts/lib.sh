#!/usr/bin/env bash
# Shared helpers: logging, dry-run execution, safe symlinking.
# shellcheck disable=SC2034

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN="${DRY_RUN:-0}"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m ok\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m !!\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m xx\033[0m %s\n' "$*" >&2; }

# run <cmd...> — executes, or prints when DRY_RUN=1
run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '\033[2m[dry-run]\033[0m %s\n' "$*"
  else
    "$@"
  fi
}

# link_file <source-in-repo> <target-in-home>
# Idempotent: skips correct links, backs up real files before replacing.
link_file() {
  local src="$1" dst="$2"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    ok "$dst already linked"
    return 0
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    run mkdir -p "$BACKUP_DIR"
    run mv "$dst" "$BACKUP_DIR/"
    warn "backed up $dst -> $BACKUP_DIR/"
  fi
  run mkdir -p "$(dirname "$dst")"
  run ln -s "$src" "$dst"
  ok "linked $dst -> $src"
}

is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
