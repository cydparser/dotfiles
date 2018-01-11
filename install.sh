#!/usr/bin/env bash
#
# Creates directories and symlinks in $HOME.
#
# Usage: ./install.sh [REL-PATH]
set -eo pipefail

cd "$(dirname "$0")"

source zshenv

dotfiles-link() {
  local rpath="$1"
  local shallow="$2"
  local dst="$HOME/.$rpath"

  if [[ -d "$rpath" ]]; then
    if [[ -f "$rpath/.dotfiles-visible" ]]; then
      dst="$HOME/$rpath"
    fi
    if [[ -f "$rpath/.dotfiles-if-exists" ]]; then
      if [[ ! -d "$dst" ]]; then
        [[ -z "$DEBUG" ]] || echo " - skipping $rpath (missing $dst)"
        return 0
      fi
      shallow=
    fi
    if [[ -z "$shallow" ]] || [[ -f "$rpath/.dotfiles-deep" ]]; then
      if [[ ! -d "$dst" ]]; then
        echo " + mkdir $rpath"
        mkdir -p "$dst"
      fi
      while read -r f; do
        dotfiles-link "$f" 'shallow' || return 1
      done < <(find -L "$rpath" -mindepth 1 -maxdepth 1)
      return 0
    fi
  fi
  [[ ! "$(basename "$rpath")" =~ ^.dotfiles- ]] || return 0

  if [[ -e "$dst" ]]; then
    if [[ -n "$DEBUG" ]] || [[ ! -L "$dst" ]]; then
      echo " - skipping $rpath"
    fi
  else
    echo " + linking $dst"
    ln -s "$PWD/$rpath" "$dst"
  fi
}

if [[ -n "$1" ]]; then
  dotfiles-link "$1"
else
  _SELF=$(basename "$0")
  for f in *; do
    [[ ! "$f" =~ $_SELF$ ]] || continue
    dotfiles-link "$f" || exit 1
  done
  # TODO: Is this necessary on new machines?
  for f in bash irb pry zsh; do
    touch "$XDG_DATA_HOME/$f/history"
  done
fi
