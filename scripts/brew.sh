#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=scripts/lib.sh
source "$(dirname "$0")/lib.sh"

if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew"
  run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  ok "Homebrew present: $(brew --version | head -1)"
fi

info "Installing packages from Brewfile"
run brew bundle --file="$DOTFILES_DIR/Brewfile"
ok "Brew bundle complete"
