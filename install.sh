#!/bin/bash
#
# Creates symlinks in $HOME for each file and directory.

cd $(dirname "$0")
DOTFILES="$(pwd)"

dotfiles-link() {
  local name=$(basename "$1")
  local src="${DOTFILES}/${name}"
  local dest="${HOME}/.${name}"

  if [[ -e "$dest" ]]; then
    echo " - skipping $name"
  else
    echo " + linking $name"
    ln -s "$src" "$dest"
  fi
}

if [[ -n "$1" ]]; then
  dotfiles-link "$1"
else
  ls "${DOTFILES}" | while read f; do
    dotfiles-link "$f"
  done
fi
