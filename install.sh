#!/usr/bin/env bash
#
# Creates directories and symlinks in $HOME.
#
# Usage: ./install.sh [REL-PATH]
set -eo pipefail

cd "$(dirname "$0")"

source zshenv

if [[ -n "$DARWIN" ]] && ! grep -q TMUX /etc/{profile,zshenv}; then
  cat <<EOF >&2
Change the following in /etc/profile and /etc/zshenv
  - if [ -x /usr/libexec/path_helper ]; then
  + if [ -x /usr/libexec/path_helper -a -z "\$TMUX" ]; then
EOF
  exit 1
fi

dotfiles-link() {
  local rpath="$1"
  local shallow="$2"
  local dst="$HOME/.$rpath"

  if [[ -d "$rpath" ]]; then
    if [[ -z "$shallow" ]] || [[ -f "$rpath/.dotfiles-deep" ]]; then
      if [[ ! -d "$dst" ]]; then
        echo " + mkdir $rpath"
        mkdir -p "$dst"
      fi
      while read -r f; do
        dotfiles-link "$f" 'shallow' || return 1
      done < <(find "$rpath" -mindepth 1 -maxdepth 1)
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
