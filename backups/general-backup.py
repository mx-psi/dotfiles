#! /usr/bin/python3
# Author: Pablo Baeyens
# Inspired by roussos.cc/2018/03/05/duplicity-gpg-dropbox

import os
import yaml
import subprocess
import platform

# MODIFIABLE PARAMETERS

# Destination folder
DEST_FOLDER = "dpbx://pablo-W740SU"  # hostname

# Secret files
LIST_FILE = "/home/pablo/dotfiles/secrets/files-to-sync.dat"
KEYS_FILE = "/home/pablo/dotfiles/secrets/duplicity-secrets.yaml"

# Lifespan of backups
LIFESPAN = "4M"

# Time between full backups
FULL_SPAN = "1M"


def load_secrets(filepath):
    """Load secrets into environment variables that can be used by duplicity."""
    with open(filepath, 'r') as data:
        os.environ.update(yaml.safe_load(data.read()))


if __name__ == "__main__":
    load_secrets(KEYS_FILE)

    # Remove old files from destination folder
    subprocess.run(
        ["duplicity", "remove-older-than", LIFESPAN, "--force", DEST_FOLDER])

    # Backup listed files to destination folder; specify timing of full backups
    subprocess.run([
        "duplicity", "--full-if-older-than", FULL_SPAN, "--include-filelist",
        LIST_FILE, "/home/pablo", DEST_FOLDER
    ])

    # Cleanup failures
    subprocess.run(["duplicity", "cleanup", "--force", DEST_FOLDER])
