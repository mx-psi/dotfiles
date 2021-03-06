# Backups

## General backups

I use `general-backup.py` to automate backups of certain folders to Dropbox (based on [this](https://www.roussos.cc/2018/03/05/duplicity-gpg-dropbox/)).
The `secrets/duplicity-secrets.yaml` file contains the necessary exports for the backup script to work:

```yaml
DPBX_ACCESS_TOKEN: [Dropbox access token]
PASSPHRASE: [passphrase for encryption]
```

The `files-to-sync.dat` file includes the list of files to sync using `duplicity`'s syntax.
Backups can be restored using `restore.py`.

<!-- I had to run `pip install dropbox --upgrade` for it to work. -->

## Pocket backups

Pocket faved articles are stored in CoDual's log for possible inclusion.

This is managed by `pocket-backup.py`.

## NextCloud backups

Quite infrequently I do a backup of calendars stored in a NextCloud instance.
These are then stored on an FTP server.

This process is managed by `nexcloud-backup.py`.
