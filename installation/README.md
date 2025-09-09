

# New system installation notes.


# install ruff

curl -LsSf https://astral.sh/uv/install.sh | 


## kanata

download binary: https://github.com/jtroo/kanata/releases

create a service (`kanata.service`) inside your `~/.config/systemd/user` folder:
(make it point to the right executable.)


```
[Unit]
Description=Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata

[Service]
Environment=PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:%h/.cargo/bin

#   Uncomment the 4 lines beneath this to increase process priority
#   of Kanata in case you encounter lagginess when resource constrained.
#   WARNING: doing so will require the service to run as an elevated user such as root.
#   Implementing least privilege access is an exercise left to the reader.
#
# CPUSchedulingPolicy=rr
# CPUSchedulingPriority=99
# IOSchedulingClass=realtime
# Nice=-20
Type=simple
ExecStart=/usr/bin/sh -c 'exec $$(which kanata) --cfg $${HOME}/.config/kanata/config.kbd'
Restart=no

[Install]
WantedBy=default.target
```

```
systemctl --user daemon-reload
systemctl --user enable kanata.service
```

to restart:
```
systemctl --user restart kanata.service
```


IMPORTANT: log out and log in again. Otherwise it will not work.

- sudo apt install zsh

- clone autosuggestions: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md




## pcloud drive


## vscode

download `.deb` package

```
sudo dpkg -i vscode
```


## ripgrep

```
sudo apt install ripgrep
```


## snapshot/annotation tool

```
sudo apt install ksnip
```

By default ksnip does not add itself to the 'open with' list when viewing an image.
To enable this:

- open the `/usr/share/applications/org.ksnip.ksnip.desktop` file
- In the `[Desktop Entry]` append ` %F` to the `Exec=ksnip` line.

screenshot tool



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


## gsettings, changing docking hotkeys.

normally <super>1 to 3 will launch application 1 to 3 as they appear on the dock.
These settings remap those to other keys.

for schema definitions: /usr/share/glib-2.0/schemas
ui as a help: dconf-editor

```shell
gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-1 "['<Super>r']"  # terminal
gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-2 "['<Super>f']"  # firefox
gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-3 "['<Super>c']"  # vs code
gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-4 "['<Super>t']"  # teams
gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-5 "['<Super>v']"  # zed editor
gsettings set org.gnome.shell.extensions.dash-to-dock click-action "cycle-windows"
gsettings set org.gnome.shell.extensions.dash-to-dock hotkeys-show-dock "false"

# disable toggle-quick-settings:
gsettings set org.gnome.shell.keybindings toggle-quick-settings '["disabled"]'

```

## disable capslock

install gnome-tweaks

<keyboard><Additional Layout Options>

Find the disable caps-lock.




## export shortcuts

https://gshortcuts.jpinillos.dev/

shortcuts.yaml located at `installation/shortcuts.yaml`


## just
https://github.com/casey/just

uv tool install rust-just

https://github.com/essembeh/gnome-extensions-cli
