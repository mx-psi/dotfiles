#!/usr/bin/env bash

declare -a DOTFILES=("bashrc" "emacs/editorconfig" "emacs/snippets"
          "emacs/init.el" "gitconfig" "hidden" "inputrc" "profile")

declare -a SU_DOTFILES=("backups/general-backup.py" "backups/nextcloud-backup.py" "backups/pocket-backup.py")

declare -A LINK_NAMES=(
["backups/general-backup.py"]="/etc/cron.daily/backup"
["backups/nextcloud-backup.py"]="/etc/cron.monthly/nextcloud-backup"
["backups/pocket-backup.py"]="/etc/cron.daily/pocket-backup"
["bashrc"]="$HOME/.bashrc"
["emacs/editorconfig"]="$HOME/.editorconfig"
["emacs/snippets"]="$HOME/.emacs.d/snippets"
["emacs/init.el"]="$HOME/.emacs.d/init.el"
["gitconfig"]="$HOME/.gitconfig"
["hidden"]="$HOME/.hidden"
["inputrc"]="$HOME/.inputrc"
["profile"]="$HOME/.profile"
)

for dotfile in "${SU_DOTFILES[@]}"
do
  sudo ln -sbv "$(pwd)/$dotfile" "${LINK_NAMES[$dotfile]}"
done


for dotfile in "${DOTFILES[@]}"
do
  ln -sbv "$(pwd)/$dotfile" "${LINK_NAMES[$dotfile]}"
done
