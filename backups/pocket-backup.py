#! /usr/bin/python3

import yaml
import requests
import os.path
import datetime
import shutil

POCKET_SECRETS = "/home/pablo/dotfiles/secrets/pocket-secrets.yaml"


def load_yaml(filepath):
    """Gets the credentials from secret YAML file."""
    with open(filepath, 'r') as f:
        return yaml.load(f.read())


def store_yaml(filepath, contents):
    """Stores secrets to YAML."""
    with open(filepath, 'w') as f:
        f.write(yaml.dump(contents, default_flow_style=False))


def get_new_favorites():
    """Gets new favourites from Pocket."""

    # Get API keys
    pocket_login = load_yaml(POCKET_SECRETS)

    # See: getpocket.com/developer/docs/v3/retrieve
    params = pocket_login.copy()
    params["state"] = "all"
    params["favorite"] = 1

    # JSON format, please
    headers = {"Content-Type": "application/json"}

    answer = requests.post("https://getpocket.com/v3/get",
                           params=params,
                           headers=headers)

    if answer.status_code == 200:
        # Update last time we checked
        pocket_login["since"] = int(
            datetime.datetime.timestamp(datetime.datetime.now()))
        store_yaml(POCKET_SECRETS, pocket_login)

        # if there are no new items a list is returned, else it's a dictionary (?)
        items = answer.json()["list"]
        return items.values() if items else []
    else:
        return []  # Silently fail


if __name__ == "__main__":
    # Store in the log
    log_path = "/home/pablo/Documentos/codual/_log/{today.year}/m{today.month:02d}.md".format(
        today=datetime.date.today())

    with open(log_path, 'a') as log_file:
        favourites = get_new_favorites()
        for favourite in favourites:
            log_file.write("- [{name}]({url})\n".format(
                name=favourite["resolved_title"],  # FIXME: broken for PDFs
                url=favourite["resolved_url"]))
    shutil.chown(log_path, user="pablo")
