#!/bin/bash
#
# Creates symlinks in $HOME.

cd $(dirname "$0")
DOTFILES="$(pwd)"

source zshenv
mkdir -p "$XDG_DATA_HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME"

for d in bash irb pry zsh; do
  mkdir -p "$XDG_DATA_HOME/$d"
  touch "$XDG_DATA_HOME/$d/history"
done

if [[ -n "$DARWIN" ]] && ! grep -q TMUX /etc/{profile,zshenv}; then
  echo 'Change the following in /etc/profile and /etc/zshenv'
  echo '- if [ -x /usr/libexec/path_helper ]; then'
  echo '+ if [ -x /usr/libexec/path_helper -a -z "$TMUX" ]; then'
fi

dotfiles-link() {
  local rpath="$1"
  local shallow="$2"

  if [[ -z "$shallow" ]]; then
    if [[ -d "$rpath" ]]; then
      ls "$rpath" |
        while read f; do
          dotfiles-link "$rpath/$f" shallow
        done
      return
    fi
  fi
  local src="$DOTFILES/$rpath"
  local dst="$HOME/.$rpath"

  if [[ -e "$dst" ]]; then
    echo " - skipping $rpath"
  else
    echo " + linking $dst"
    ln -s "$src" "$dst"
  fi
}

if [[ -n "$1" ]]; then
  dotfiles-link "$1"
else
  ls "$DOTFILES" | grep -v $(basename $0) |
    while read f; do
      dotfiles-link "$f"
    done
fi
