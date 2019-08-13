#!/usr/bin/python3

import yaml
import requests
import datetime
import os.path
import tempfile
import ftplib

NC_SECRETS = os.path.expanduser("~/dotfiles/secrets/nextcloud-secrets.yaml")
FTP_SECRETS = os.path.expanduser("~/dotfiles/secrets/ftp-secrets.yaml")

def load_yaml(filepath):
    """Gets the credentials from secret YAML file."""
    with open(filepath, 'r') as f:
        return yaml.load(f.read())


def backup_name(calendar, parent):
    return  parent + "/Backups/" + calendar + "-" + datetime.date.today().isoformat(
    ) + ".ics"

def upload_to_ftp(ftp, filename, contents):
  with tempfile.TemporaryFile() as temp:
    temp.write(bytes(contents, encoding="utf-8"))
    temp.seek(0)
    ftp.storlines("STOR {}".format(filename), temp)


def backup_calendars(data, ftp_data):
    """Backup the listed calendars."""
    url = "https://{host}/remote.php/dav/calendars/{username}/{calendar}?export"
    with ftplib.FTP(ftp_data["url"]) as ftp:
      ftp.login()
      for calendar in data["calendars"]:
        response = requests.get(url.format(host=data["host"],
                                           username=data["username"],
                                           calendar=calendar),
                                auth=(data["username"], data["password"]))

        if response.status_code != 200:
          continue  # Failed backup
        upload_to_ftp(ftp, backup_name(calendar, ftp_data["folder"]), response.text)


if __name__ == "__main__":
    credentials = load_yaml(NC_SECRETS)
    ftp_data = load_yaml(FTP_SECRETS)
    backup_calendars(credentials, ftp_data)
