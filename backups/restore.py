#! /usr/bin/python3
# Author: Pablo Baeyens
# Inspired by roussos.cc/2018/03/05/duplicity-gpg-dropbox

import os
import yaml
import subprocess
import platform
import getpass

# MODIFIABLE PARAMETERS

# Destination folder
USER = getpass.getuser()
ORIGIN_FOLDER = "dpbx://pablo-W740SU"  # hostname
RESTORE_FOLDER = "/home/{whoami}/Backups".format(whoami=USER)

# Secret files
KEYS_FILE = "/home/{whoami}/dotfiles/secrets/duplicity-secrets.yaml".format(
    whoami=USER)


def load_secrets(filepath):
    """Load secrets into environment variables that can be used by duplicity."""
    with open(filepath, 'r') as data:
        os.environ.update(yaml.load(data.read()))


if __name__ == "__main__":
    load_secrets(KEYS_FILE)
    print("Restoring into " + RESTORE_FOLDER)
    subprocess.run(["duplicity", ORIGIN_FOLDER, RESTORE_FOLDER])
