# New system installation notes.

Some general notes and instructions on bootstrapping a new linux installation.

```
# add latest upstream git ppa.
sudo add-apt-repository ppa:git-core/ppa

sudo apt update && sudo apt upgrade
sudo apt install git curl build-essential cmake
```

# git delta

git is configured using this tool.

https://github.com/dandavison/delta/releases
sudo dpkg -i git-delta_0.16.5_amd64.deb

## taplo toml formatter

```bash
cargo install taplo-cli --locked
  | gzip -d - | install -m 755 /dev/stdin /usr/local/bin/taplo
```

## github cli

convenient for authenticating with github.

https://github.com/cli/cli/blob/trunk/docs/install_linux.md


### authenticate your workstation with github.

```
gh auth login
```

## import your dotfiles

```
mkdir ~/repos
cd repos
git clone https://github.com/sander76/dotfiles.git
cd dotfiles
./setup.sh

```


## fira nerd font

https://www.nerdfonts.com/

copy FiraCode folder to ~/.local/share/fonts. (~/.local/share/fonts/FiraCode/<all ttf files here>)


## zshell / ohmyzsh

IMPORTANT: log out and log in again. Otherwise it will not work.

- sudo apt install zsh
- https://ohmyz.sh/#install (use curl)
- the alias for the .zshrc file seems to break during this. run setup.sh again from the dotfiles repo
- install plugins:

    ```
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
    ```


## starship shell

```
curl -sS https://starship.rs/install.sh | sh
```

## pcloud drive


## pyenv

https://github.com/pyenv/pyenv-installer?tab=readme-ov-file#installation--update--uninstallation
https://github.com/pyenv/pyenv#set-up-your-shell-environment-for-pyenv

### install python globals:

> Unsure whether I want to switch to pre-compiled binaries.

```
mise ls-remote python
mise install python@3.11

```

### .mise.toml file

put in your local repo folder.

```toml
[tools]
python = [{ version = '3.11', virtualenv = '.venv' },'3.10.13','3.12.1']
```
## vscode

download `.deb` package

```
sudo dpkg -i vscode...
```

## ulauncher, 

https://ulauncher.io/#Download

- make CTRL-CTRL the hotkey
- add opener to plugin: https://github.com/sander76/ulauncher-opener
- add CTRL-SPACE to system wide shortcut (wayland and ulauncher don't play nice together)

## zellij

make sure cargo is installed.

compile zellij using `cargo`: https://zellij.dev/documentation/installation


## tldr 


https://github.com/pepa65/tldr-bash-client#installation

(First run can take a while due to caching.)

## fzf
https://github.com/junegunn/fzf#using-git


## pipx

- download pipx zipfile (.pyx) and copy to `~/bin/` (https://pipx.pypa.io/stable/#using-pipx-without-installing-via-zipapp)
- the alias is already defined. So you should be able to run `pipx` now directly from you terminal.

## ripgrep

```
sudo apt install ripgrep
```

## flatpak

```
sudo apt install flatpak
```

add flathub repository.

https://flathub.org/setup/Ubuntu

## snapshot/annotation tool

```
sudo apt install ksnip
```

By default ksnip does not add itself to the 'open with' list when viewing an image.
To enable this:

- open the `/usr/share/applications/org.ksnip.ksnip.desktop` file
- In the `[Desktop Entry]` append ` %F` to the `Exec=ksnip` line.

screenshot tool


## beekeeper

## Rust
install rustup, https://rustup.rs/

## Freecad

## Prusa slicer

## Superslicer

An alternative to prusa slicer.

## Docker

Install docker engine: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

to run docker without sudo:

```
sudo groupadd docker
newgrp docker
sudo usermod -aG docker $USER
```

## Disable bell sound in shell

uncomment or add `set bell-style none` in the `/etc/inputrc` file.

## vscode

debug configuration:

```
{
  "name": "Python: Debug Tests",
  "type": "debugpy",
  "request": "launch",
  "program": "${file}",
  "purpose": ["debug-test"],
  "console": "integratedTerminal",
  "justMyCode": false
}
```

## run or raise

activate a currently running application using shortcut or start the application.

A gnome shell plugin: https://extensions.gnome.org/extension/1336/run-or-raise/

check `~/.config/run-or-raise/shortcuts.conf` for current shortcuts.

## disable capslock

install gnome-tweaks

<keyboard><Additional Layout Options>

Find the disable caps-lock.
