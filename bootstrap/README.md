# Bootstrap

Machine setup for **Ubuntu** and **macOS** using [mise](https://mise.jdx.dev/bootstrap.html).

## What it sets up

- **zsh** as the login shell (system package)
- **starship** prompt (mise-managed tool)
- **git** (system package)
- **curl** (system package)
- **unzip** + **fontconfig** (Ubuntu, for font installation)
- **Arimo Nerd Font** (brew cask on macOS, manual download on Ubuntu)
- **mise shell activation** in zsh startup files
- **dotfiles**: `~/.zshrc`, `~/.zprofile`, `~/.config/starship.toml`

## Usage

### New machine

```bash
# Install mise first (if not already installed)
curl https://mise.run | sh

# Preview what will be done
mise bootstrap --from <this-repo-url> --dry-run

# Apply
mise bootstrap --from <this-repo-url> --yes
```

### Existing machine (adopt into global config)

```bash
mise bootstrap --adopt <this-repo-url>
```

### Re-run after changes

```bash
mise bootstrap
mise bootstrap status
```

## Structure

```
bootstrap/
├── mise.toml           # Main bootstrap configuration
├── dotfiles/           # Source files for [dotfiles] section
│   ├── starship.toml   # → ~/.config/starship.toml
│   ├── zshrc           # → ~/.zshrc
│   └── zprofile        # → ~/.zprofile
└── README.md
```

## Platform notes

| Package | Ubuntu | macOS |
|---------|--------|-------|
| git | apt | brew |
| zsh | apt | brew |
| curl | apt | brew |
| unzip | apt | built-in |
| fontconfig | apt | built-in |
| Arimo Nerd Font | manual download | brew cask (`font-arimo-nerd-font`) |
| starship | mise (aqua) | mise (aqua) |
