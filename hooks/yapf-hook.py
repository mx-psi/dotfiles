#!/usr/bin/python3
# simple pre-commit hook for yapf

import subprocess
import os


def get_modified_files():
    """Get a list of modified files."""
    output = subprocess.run(
        ["git", "diff", "--cached", "--name-only", "--diff-filter=ACM"],
        stdout=subprocess.PIPE,
        universal_newlines=True)
    return output.stdout.splitlines()


if __name__ == "__main__":
    files = [path for path in get_modified_files() if path.endswith(".py")]

    if files:

        # Get the diff
        diff = subprocess.run(["yapf", "-d", "-p", "--style", "google"] + files,
                              stdout=subprocess.PIPE)

        if diff.stdout:
            subprocess.run(["patch", "-p0"], input=diff.stdout)
            print("Files were changed, aborting commit.")
            exit(-1)
