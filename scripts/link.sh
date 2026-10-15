#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=scripts/lib.sh
source "$(dirname "$0")/lib.sh"

info "Linking dotfiles from $DOTFILES_DIR"

link_file "$DOTFILES_DIR/zsh/zshrc"            "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zsh/starship.toml"    "$HOME/.config/starship.toml"
link_file "$DOTFILES_DIR/git/gitconfig"        "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/gitignore_global" "$HOME/.config/git/ignore"
link_file "$DOTFILES_DIR/mise.toml"            "$HOME/.config/mise/config.toml"

# SSH config is copied, not linked, so host-specific edits don't dirty the repo.
if [[ ! -f "$HOME/.ssh/config" ]]; then
  run mkdir -p "$HOME/.ssh"
  run cp "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
  run chmod 600 "$HOME/.ssh/config"
  ok "installed ~/.ssh/config template"
fi

if is_macos; then
  vscode_dir="$HOME/Library/Application Support/Code/User"
  link_file "$DOTFILES_DIR/vscode/settings.json" "$vscode_dir/settings.json"
  if command -v code >/dev/null 2>&1; then
    while read -r ext; do
      [[ -z "$ext" || "$ext" == \#* ]] && continue
      run code --install-extension "$ext" --force >/dev/null
    done < "$DOTFILES_DIR/vscode/extensions.txt"
    ok "VS Code extensions installed"
  fi
fi

for f in "$HOME/.zshrc.local" "$HOME/.gitconfig.local"; do
  [[ -f "$f" ]] || { run touch "$f"; ok "created empty $f for machine-specific overrides"; }
done
