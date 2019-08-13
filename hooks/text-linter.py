#!/usr/bin/python3
# pre-commit hook for text linter

import subprocess
import re


def get_modified_files():
    """Get a list of modified files."""
    output = subprocess.run(["git", "diff", "--cached", "--name-only"],
                            stdout=subprocess.PIPE,
                            universal_newlines=True)
    return output.stdout.splitlines()


def replace_lint(original, replacement):
    """Linter for replacing words."""

    def linter(contents):
        return contents.replace(original, replacement)

    return linter


def print_warning(match, message, contents):
    """Print warning including lineno"""
    _, end = match.span()
    lineno = contents.count("\n", 0, end) + 1
    print("[{}]".format(lineno), message.format(match))


def warn(pattern, message):

    def linter(contents):
        matches = re.finditer(pattern, contents)
        any_match = False

        for match in matches:
            any_match = True
            print_warning(match, message, contents)

        return any_match

    return linter


def lint(contents):
    """Lint a file."""
    modifiers = [replace_lint("...", "…")]
    original = contents

    for linter in modifiers:
        contents = linter(contents)

    warnings = [
        warn(r"^[ \t]*\-.*[^,ydro\.]$", "Lists are enumerations.\n\t{}"),
        warn(r"[^y]\s+significant\b",
             "Add adverb before 'significant' (statistically?)"),
        warn(
            r"!\s+\[",
            "Are you trying to insert an image? (Add comment between '!' and '[' to disable)"
        )
    ]

    problems = original != contents
    for f in warnings:
        problems |= f(contents)

    return contents, problems


if __name__ == "__main__":
    files = get_modified_files()

    for filepath in files:
        with open(filepath, 'r+') as modified:
            linted, changed = lint(modified.read())
            if changed:
                modified.seek(0)
                modified.write(linted)
                print("Aborting commit due to '{}'.".format(filepath))
                exit(-1)
