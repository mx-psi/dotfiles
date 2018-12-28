#!/usr/bin/env bash
set -e

# Dropbox configuration variables
DROPBOX_FOLDER=`hostname`
RESTORE_FOLDER="/home/pablo/Backups"
source secrets/duplicity-secrets

# Restore
duplicity dpbx://${DROPBOX_FOLDER} ${RESTORE_FOLDER}

unset DPBX_ACCESS_TOKEN
unset PASSPHRASE
