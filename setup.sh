#!/usr/bin/env bash

declare -a DOTFILES=("bashrc" "emacs/editorconfig" "emacs/snippets"
          "emacs/init.el" "gitconfig" "hidden" "inputrc")

declare -A LINK_NAMES=(
["backup.sh"]="/etc/cron.daily/backup"
["bashrc"]="/home/`whoami`/.bashrc"
["emacs/editorconfig"]="/home/`whoami`/.editorconfig"
["emacs/snippets"]="/home/`whoami`/.emacs.d/snippets"
["emacs/init.el"]="/home/`whoami`/.emacs.d/init.el"
["gitconfig"]="/home/`whoami`/.gitconfig"
["hidden"]="/home/`whoami`/.hidden"
["inputrc"]="/home/`whoami`/.inputrc"
)

sudo ln -sbv `pwd`/backup.sh ${LINK_NAMES['backup.sh']}

for dotfile in "${DOTFILES[@]}"
do
  ln -sbv `pwd`/$dotfile ${LINK_NAMES[$dotfile]}
done
