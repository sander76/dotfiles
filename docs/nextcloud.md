# ssh login

ssh dietpi@192.168.188.156

update thumbnails. `ncc preview:generate-all`

use systemd to issue update command:
`sudo systemd-run --unit=preview_generation --uid=www-data php /var/www/nextcloud/occ -vv preview:generate-all`

see status:
`sudo journalctl -u preview_generation -f`

reset a failed run:
`sudo systemctl reset-failed`
`sudo systemctl list-units`

dietpi config nextcloud folder
`/var/www/nextcloud/config`


# enable video thumbnails:

https://github.com/yannicklescure/wiki-md/blob/main/nextcloud/enable-video-previews-for-nextcloud-snap.md

## start backgroud task for preview generator

A systemd service is available: `preview-generator`

```
[Unit]
Description=Album preview generator

[Service]
Type=simple
User=www-data
ExecStart=php /var/www/nextcloud/occ -v preview:generate-all

[Install]
WantedBy=default.target
```

to start the service: `sudo systemctl restart preview-generator`
to watch progress: `sudo journalctl -u preview-generator`

create a cronjob to start it periodically:

```
sudo crontab -e

# add this line:
0 1 * * * /usr/bin/systemctl restart preview-generator
```

## external access

install `certbot` on dietpi


## tasks:

create an app account!

## ssh:

### user data folder.
- login using dietpi@...
- switch to su (`su`)
- goto /mnt
- use `ls -la` to view the mount to nextcloud-userdata
- navigate there.
- view total size `du -h --max-depth=1 nextcloud_data`

## how to backup

simple zipping of all files, db dump and copy over to another drive ?

https://docs.nextcloud.com/server/latest/admin_manual/maintenance/backup.html
https://github.com/nextcloud/backup?tab=readme-ov-file#handle-external-storages

https://www.youtube.com/watch?v=gh6ii9sq2Xs&t=606s

https://rclone.org/

## update to new version of nextcloud.

If update fails on the web version, you could try and use the cli which provides more info:

in your ssh session: `sudo -u www-data php /var/www/nextcloud/updater/updater.phar`

## new client version on linux machine

inside your `.config/autostart` folder are `.Desktop` files.
One of them is `Nextcloud.desktop`

```
[Desktop Entry]
Name=Nextcloud
GenericName=File Synchronizer
Exec="/home/sander/bin/Nextcloud-3.16.0-x86_64.AppImage" --background
Terminal=false
Icon=Nextcloud
Categories=Network
Type=Application
StartupNotify=false
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=10
```
