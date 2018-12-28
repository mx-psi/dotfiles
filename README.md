# dotfiles

My dotfiles, `emacs` configuration and other scripts I use frequently.
The script `setup.sh` creates symbolic links on the necessary locations.

# Non-standard files

I use `backups.sh` to automate backups of certain folders on Dropbox (based on [this](https://www.roussos.cc/2018/03/05/duplicity-gpg-dropbox/)).
There is a `secrets` folder that contains a file with the necessary exports:

```bash
export DPBX_ACCESS_TOKEN="[Dropbox access token]"
export PASSPHRASE="[passphrase for encryption]"
```

<!-- I had to run `pip install dropbox --upgrade` for it to work. -->
