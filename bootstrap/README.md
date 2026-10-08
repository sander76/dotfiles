# Bootstrap

Cross-platform machine setup using [mise](https://mise.jdx.dev/bootstrap.html).

## What it sets up

- **zsh** as the login shell (system package)
- **starship** prompt (mise-managed tool)
- **git** (system package)
- **curl** (system package)
- **Arimo Nerd Font** (brew on macOS, pacman on Arch, manual download on other Linux)
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

| Package | Linux | macOS |
|---------|-------|-------|
| git | apt/dnf/pacman/apk | brew |
| zsh | apt/dnf/pacman/apk | brew |
| curl | apt/dnf/pacman/apk | brew |
| Arimo Nerd Font | pacman or manual download | brew (`font-arimo-nerd-font`) |
| starship | mise (aqua) | mise (aqua) |
