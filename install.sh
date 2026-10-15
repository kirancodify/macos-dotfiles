#!/usr/bin/env bash
# Bootstrap a fresh Mac: Xcode CLT -> Homebrew -> clone repo -> make all
set -euo pipefail

REPO_URL="${DOTFILES_REPO:-https://github.com/kirancodify/macos-dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }

[[ "$(uname -s)" == "Darwin" ]] || fail "This bootstrap only supports macOS."

if ! xcode-select -p >/dev/null 2>&1; then
  info "Installing Xcode Command Line Tools (a dialog will appear)…"
  xcode-select --install || true
  until xcode-select -p >/dev/null 2>&1; do sleep 5; done
fi

if [[ -d "$DOTFILES_DIR/.git" ]]; then
  info "Updating existing checkout in $DOTFILES_DIR"
  git -C "$DOTFILES_DIR" pull --ff-only
else
  info "Cloning $REPO_URL into $DOTFILES_DIR"
  git clone "$REPO_URL" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"
info "Running make all"
make all
info "Done. Open a new terminal to load your shell config."
