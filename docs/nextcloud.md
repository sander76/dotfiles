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
