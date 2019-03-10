#!/usr/bin/env bash
# https://www.roussos.cc/2018/03/05/duplicity-gpg-dropbox
set -e

# Dropbox configuration variables
DROPBOX_FOLDER=`hostname`
source /home/pablo/dotfiles/secrets/duplicity-secrets

# Folders to backup
DOCUMENTS="/home/pablo/Documentos/"
SYNCTHING="/home/pablo/Sync/"
ZOTERO="/home/pablo/Zotero/"
DOTFILES="/home/pablo/dotfiles/"

# Remove files older than 1 year from Dropbox
duplicity remove-older-than 1Y --force dpbx://${DROPBOX_FOLDER}
# Sync everything to Dropbox; full backup each month
duplicity  --full-if-older-than 1M --include=${DOCUMENTS} --include=${SYNCTHING} --include=${ZOTERO} --include=${DOTFILES} --exclude='**' /home/pablo/ dpbx://${DROPBOX_FOLDER}
# Cleanup failures
duplicity cleanup --force dpbx://${DROPBOX_FOLDER}

unset DPBX_ACCESS_TOKEN
unset PASSPHRASE
