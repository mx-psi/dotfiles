#!/usr/bin/env bash

declare -a DOTFILES=("bashrc" "emacs/editorconfig" "emacs/snippets"
          "emacs/init.el" "gitconfig" "hidden" "inputrc")

declare -a SU_DOTFILES=("backup.sh" "nextcloud-backup.py" "pocket-backup.py")

declare -A LINK_NAMES=(
["backup.sh"]="/etc/cron.daily/backup"
["nextcloud-backup.py"]="/etc/cron.monthly/nextcloud-backup"
["pocket-backup.py"]="/etc/cron.daily/pocket-backup"
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
