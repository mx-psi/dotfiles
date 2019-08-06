#!/usr/bin/python3

import yaml
import requests
import datetime
import os.path


def get_credentials(filepath):
    """Gets the credentials from secret YAML file."""
    with open(filepath, 'r') as f:
        return yaml.load(f.read())


def backup_name(calendar, parent):
    return parent + "/" + calendar + "-" + datetime.date.today().isoformat(
    ) + ".ics"


def backup_calendars(data, dst):
    """Backup the listed calendars."""
    url = "https://{host}/remote.php/dav/calendars/{username}/{calendar}?export"
    for calendar in data["calendars"]:
        response = requests.get(url.format(host=data["host"],
                                           username=data["username"],
                                           calendar=calendar),
                                auth=(data["username"], data["password"]))

        if response.status_code != 200:
            continue  # Failed backup

        with open(backup_name(calendar, dst), 'w+') as f:
            f.write(response.text)


if __name__ == "__main__":
    credentials = get_credentials(os.path.expanduser("~/dotfiles/secrets/nextcloud-secrets.yaml"))
    backup_calendars(credentials, dst=os.path.expanduser("~/Backups"))
