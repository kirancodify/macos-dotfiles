SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help all brew link macos mise update dump doctor dry-run lint

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

all: brew link mise macos ## Full setup: packages, dotfiles, runtimes, macOS defaults

brew: ## Install Homebrew and everything in the Brewfile
	@./scripts/brew.sh

link: ## Symlink dotfiles into $HOME (backs up existing files)
	@./scripts/link.sh

mise: ## Install pinned language runtimes via mise
	@command -v mise >/dev/null && mise install || echo "mise not installed yet; run 'make brew' first"

macos: ## Apply macOS system defaults
	@./scripts/macos.sh

update: ## Update brew packages and runtimes
	brew update && brew upgrade && brew bundle check --file=Brewfile || true
	@command -v mise >/dev/null && mise upgrade || true

dump: ## Regenerate Brewfile from installed packages
	brew bundle dump --force --describe --file=Brewfile

doctor: ## Health-check the setup
	@./scripts/doctor.sh

dry-run: ## Print what 'make all' would do without changing anything
	@DRY_RUN=1 ./scripts/brew.sh; DRY_RUN=1 ./scripts/link.sh; DRY_RUN=1 ./scripts/macos.sh

lint: ## Lint shell scripts
	shellcheck install.sh scripts/*.sh
