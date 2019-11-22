#!/usr/bin/env bash

declare -a DOTFILES=("bashrc" "emacs/editorconfig" "emacs/snippets"
          "emacs/init.el" "gitconfig" "hidden" "inputrc")

declare -a SU_DOTFILES=("backups/general-backup.py" "backups/nextcloud-backup.py" "backups/pocket-backup.py")

declare -A LINK_NAMES=(
["backups/general-backup.py"]="/etc/cron.daily/backup"
["backups/nextcloud-backup.py"]="/etc/cron.monthly/nextcloud-backup"
["backups/pocket-backup.py"]="/etc/cron.daily/pocket-backup"
["bashrc"]="/home/`whoami`/.bashrc"
["emacs/editorconfig"]="/home/`whoami`/.editorconfig"
["emacs/snippets"]="/home/`whoami`/.emacs.d/snippets"
["emacs/init.el"]="/home/`whoami`/.emacs.d/init.el"
["gitconfig"]="/home/`whoami`/.gitconfig"
["hidden"]="/home/`whoami`/.hidden"
["inputrc"]="/home/`whoami`/.inputrc"
)

for dotfile in "${SU_DOTFILES[@]}"
do
  sudo ln -sbv `pwd`/$dotfile ${LINK_NAMES[$dotfile]}
done


for dotfile in "${DOTFILES[@]}"
do
  ln -sbv `pwd`/$dotfile ${LINK_NAMES[$dotfile]}
done
