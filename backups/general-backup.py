#! /usr/bin/python3
# Author: Pablo Baeyens
# Inspired by roussos.cc/2018/03/05/duplicity-gpg-dropbox

import os
import yaml
import subprocess
import logging
from logging.handlers import RotatingFileHandler

logger = logging.getLogger("logger")
logger.setLevel(logging.DEBUG)
handler = RotatingFileHandler("/var/log/backups.log", maxBytes=10000, backupCount=10)
handler.setFormatter(
    logging.Formatter(
        fmt="[%(asctime)s] %(levelname)s [%(name)s.%(funcName)s:%(lineno)d] %(message)s"
    )
)
logger.addHandler(handler)

# MODIFIABLE PARAMETERS

# Destination folder
DEST_FOLDER = "dpbx://pablo-XPS159500"  # hostname

# Secret files
LIST_FILE = "/home/pablo/Source/dotfiles/secrets/files-to-sync.dat"
KEYS_FILE = "/home/pablo/Source/dotfiles/secrets/duplicity-secrets.yaml"

# Lifespan of backups
LIFESPAN = "4M"

# Time between full backups
FULL_SPAN = "1M"


def load_secrets(filepath):
    """Load secrets into environment variables that can be used by duplicity."""
    with open(filepath, "r") as data:
        os.environ.update(yaml.safe_load(data.read()))


def run_and_log(arg_list):
    out = subprocess.run(arg_list, capture_output=True)
    if out.stdout:
        logger.info(str(out.stdout, "utf-8"))
    if out.stderr:
        logger.error(str(out.stderr, "utf-8"))


if __name__ == "__main__":
    load_secrets(KEYS_FILE)

    # Remove old files from destination folder
    run_and_log(["duplicity", "remove-older-than", LIFESPAN, "--force", DEST_FOLDER])

    # Backup listed files to destination folder; specify timing of full backups
    run_and_log(
        [
            "duplicity",
            "--full-if-older-than",
            FULL_SPAN,
            "--include-filelist",
            LIST_FILE,
            "/home/pablo",
            DEST_FOLDER,
        ]
    )

    # Cleanup failures
    run_and_log(["duplicity", "cleanup", "--force", DEST_FOLDER])
