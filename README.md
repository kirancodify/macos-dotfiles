# macos-dotfiles

> One command from a fresh Mac to a fully configured platform-engineering workstation.

![CI](https://github.com/kirancodify/macos-dotfiles/actions/workflows/ci.yml/badge.svg)

```bash
curl -fsSL https://raw.githubusercontent.com/kirancodify/macos-dotfiles/main/install.sh | bash
```

Or, the cautious way (read before you run):

```bash
git clone https://github.com/kirancodify/macos-dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make help        # see what's available
make dry-run     # print every action without changing anything
make all         # brew + dotfiles + macOS defaults
```

## What you get

| Area | Details |
|------|---------|
| **Packages** | `Brewfile` with CLI tools, cloud CLIs, Kubernetes tooling, IaC, observability and apps |
| **Shell** | zsh + [starship](https://starship.rs) prompt, `fzf`, `zoxide`, `direnv`, sane history, kube/terraform aliases |
| **Git** | Opinionated `.gitconfig`, global ignore, conditional work/personal identities |
| **macOS** | Dock, Finder, keyboard repeat, screenshots, trackpad — via `defaults write` |
| **SSH** | `~/.ssh/config` template using the 1Password / macOS keychain agent |
| **Editor** | VS Code settings + extension list |
| **Runtimes** | `mise` for Node, Python, Go, Terraform version pinning |

## Layout

```
.
├── install.sh            # bootstrap: Xcode CLT → Homebrew → clone → make all
├── Makefile              # entry point for every task
├── Brewfile              # declarative package list (brew bundle)
├── scripts/
│   ├── lib.sh            # logging, dry-run, idempotent symlink helpers
│   ├── brew.sh           # install Homebrew + bundle
│   ├── link.sh           # symlink dotfiles into $HOME (backs up existing files)
│   ├── macos.sh          # macOS defaults
│   └── doctor.sh         # health check of the setup
├── zsh/                  # .zshrc, aliases, functions
├── git/                  # .gitconfig, global gitignore
├── ssh/                  # ssh config template
├── vscode/               # settings.json, extensions.txt
└── mise.toml             # runtime versions
```

## Design principles

- **Idempotent** – every script can be re-run safely; existing files are backed up to `~/.dotfiles-backup/<timestamp>/`.
- **Dry-run first** – `DRY_RUN=1` prints actions instead of executing them.
- **Declarative** – packages live in `Brewfile`, runtimes in `mise.toml`; drift is detectable with `make doctor`.
- **Secrets never committed** – machine-specific overrides go in `~/.zshrc.local` and `~/.gitconfig.local` (both git-ignored).

## Keeping it in sync

```bash
make update      # brew update/upgrade + bundle cleanup check + mise upgrade
make dump        # regenerate Brewfile from what's currently installed
make doctor      # verify links, tools, and versions
```

## License

MIT
