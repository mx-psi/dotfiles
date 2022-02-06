#!/usr/bin/env bash

declare -a DOTFILES=("bashrc" "doom/init.el" "doom/config.el" "doom/packages.el" "gitconfig" "hidden" "inputrc" "profile")

declare -a SU_DOTFILES=("backups/general-backup.py")

declare -A LINK_NAMES=(
["backups/general-backup.py"]="/etc/cron.daily/backup"
["bashrc"]="$HOME/.bashrc"
["gitconfig"]="$HOME/.gitconfig"
["hidden"]="$HOME/.hidden"
["inputrc"]="$HOME/.inputrc"
["profile"]="$HOME/.profile"
["doom/init.el"]="$HOME/.doom.d/init.el"
["doom/config.el"]="$HOME/.doom.d/config.el"
["doom/packages.el"]="$HOME/.doom.d/packages.el"
)

for dotfile in "${SU_DOTFILES[@]}"
do
  sudo ln -sbv "$(pwd)/$dotfile" "${LINK_NAMES[$dotfile]}"
done


for dotfile in "${DOTFILES[@]}"
do
  ln -sbv "$(pwd)/$dotfile" "${LINK_NAMES[$dotfile]}"
done
