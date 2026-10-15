#!/usr/bin/env bash
# Opinionated macOS defaults. Re-runnable. Review before applying!
set -euo pipefail
# shellcheck source=scripts/lib.sh
source "$(dirname "$0")/lib.sh"

if ! is_macos && [[ "$DRY_RUN" != "1" ]]; then
  warn "Not macOS — skipping defaults"
  exit 0
fi

info "Applying macOS defaults"

# Keyboard: fast repeat, no press-and-hold accents, no autocorrect
run defaults write NSGlobalDomain KeyRepeat -int 2
run defaults write NSGlobalDomain InitialKeyRepeat -int 15
run defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
run defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
run defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
run defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Finder: show hidden files, extensions, path bar, list view, search current folder
run defaults write com.apple.finder AppleShowAllFiles -bool true
run defaults write NSGlobalDomain AppleShowAllExtensions -bool true
run defaults write com.apple.finder ShowPathbar -bool true
run defaults write com.apple.finder ShowStatusBar -bool true
run defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
run defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
run defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
run defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Dock: autohide, small, no recents
run defaults write com.apple.dock autohide -bool true
run defaults write com.apple.dock autohide-delay -float 0
run defaults write com.apple.dock tilesize -int 42
run defaults write com.apple.dock show-recents -bool false
run defaults write com.apple.dock mru-spaces -bool false

# Screenshots: ~/Screenshots, PNG, no shadow
run mkdir -p "$HOME/Screenshots"
run defaults write com.apple.screencapture location -string "$HOME/Screenshots"
run defaults write com.apple.screencapture type -string "png"
run defaults write com.apple.screencapture disable-shadow -bool true

# Trackpad: tap to click
run defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
run defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Security: require password immediately after sleep
run defaults write com.apple.screensaver askForPassword -int 1
run defaults write com.apple.screensaver askForPasswordDelay -int 0

for app in Finder Dock SystemUIServer; do
  run killall "$app" >/dev/null 2>&1 || true
done
ok "macOS defaults applied (some need a logout to take effect)"
