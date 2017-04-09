#!/usr/bin/env bash

# http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
[[ -z "$XDG_DATA_HOME" ]] && export XDG_DATA_HOME="$HOME/.local/share"
[[ -z "$XDG_DATA_DIRS" ]] && export XDG_DATA_DIRS=/usr/local/share/:/usr/share/
[[ -z "$XDG_CONFIG_HOME" ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -z "$XDG_CONFIG_DIRS" ]] && export XDG_CONFIG_DIRS=/etc/xdg
[[ -z "$XDG_CACHE_HOME" ]] && export XDG_CACHE_HOME="$HOME/.cache"

export SPACEMACSDIR="$XDG_CONFIG_HOME/spacemacs.d"
export TERM=xterm-256color
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

if [[ $OSTYPE == darwin* ]]; then
  export DARWIN=1
else
  # https://github.com/NixOS/nixpkgs/issues/8247
  for f in ~/.nix-profile/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt; do
    if [[ -f "$f" ]]; then
      export GIT_SSL_CAINFO="$f"
      break
    fi
  done
fi

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

if [[ -e ~/.nix-profile ]]; then
  export DICPATH=~/.nix-profile/share/hunspell

  if [[ -n "$DARWIN" ]]; then
    source ~/.nix-profile/etc/profile.d/nix.sh
  fi
fi

export PATH=$PATH:~/.local/bin
