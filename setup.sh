#!/usr/bin/env bash

declare -a DOTFILES=("bashrc" "emacs/editorconfig" "emacs/snippets"
          "emacs/init.el" "gitconfig" "hidden" "inputrc")

declare -A LINK_NAMES=(
["backup.sh"]="/etc/cron.daily/backup"
["bashrc"]="/home/pablo/.bashrc"
["emacs/editorconfig"]="/home/pablo/.editorconfig"
["emacs/snippets"]="/home/pablo/.emacs.d/snippets"
["emacs/init.el"]="/home/pablo/.emacs.d/init.el"
["gitconfig"]="/home/pablo/.gitconfig"
["hidden"]="/home/pablo/.hidden"
["inputrc"]="/home/pablo/.inputrc"
)

sudo ln -sbv `pwd`/backup.sh ${LINK_NAMES['backup.sh']}

for dotfile in "${DOTFILES[@]}"
do
  ln -sbv `pwd`/$dotfile ${LINK_NAMES[$dotfile]}
done
