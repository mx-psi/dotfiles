# dotfiles

My dotfiles, `emacs` configuration and other scripts I use frequently.
The script `setup.sh` creates symbolic links on the necessary locations.

## Backups

I use `backup.sh` to automate backups of certain folders on Dropbox (based on [this](https://www.roussos.cc/2018/03/05/duplicity-gpg-dropbox/)).
The `secrets/duplicity-secrets` file contains the necessary exports for the backup script to work:

```bash
export DPBX_ACCESS_TOKEN="[Dropbox access token]"
export PASSPHRASE="[passphrase for encryption]"
```

Backups can be restored using `restore.sh`.

<!-- I had to run `pip install dropbox --upgrade` for it to work. -->
