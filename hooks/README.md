# Git hooks

This folder includes git hooks I sometimes use.

## `text-linter.py`

Makes sensible replacements and suggestions on Markdown files.

This is a very incomplete and rudimentary linter, please check [`proselint`](http://proselint.com/) first.

## `yapf-hook.py`

Applies `yapf` linter to Python files on the given directory.

Can be easily modified to use other linters, provided there is a way to check for changes.

You need `yapf` and `patch`.
