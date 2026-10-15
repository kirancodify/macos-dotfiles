#!/usr/bin/env bash
# Verifies the workstation matches what this repo declares.
set -uo pipefail
# shellcheck source=scripts/lib.sh
source "$(dirname "$0")/lib.sh"

failures=0
check() {
  local desc="$1"; shift
  if "$@" >/dev/null 2>&1; then ok "$desc"; else err "$desc"; failures=$((failures + 1)); fi
}

info "Links"
check "$HOME/.zshrc linked" test -L "$HOME/.zshrc"
check "$HOME/.gitconfig linked" test -L "$HOME/.gitconfig"

info "Core tools"
for tool in brew git zsh starship fzf zoxide direnv mise kubectl helm k9s terraform jq yq gh; do
  check "$tool on PATH" command -v "$tool"
done

info "Brewfile drift"
if command -v brew >/dev/null 2>&1; then
  check "brew bundle check" brew bundle check --file="$DOTFILES_DIR/Brewfile"
fi

echo
if (( failures > 0 )); then
  err "$failures check(s) failed"
  exit 1
fi
ok "All checks passed"
