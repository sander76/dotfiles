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

create a systemd service (only do this once.):
`sudo systemd-run --unit=preview_generation --uid=www-data php /var/www/nextcloud/occ -vv preview:generate-all`

start the service:
`sudo systemctl start preview_generation`

watch progress:
`sudo journalctl -y preview_generation -f`


## external access

install `certbot` on dietpi
