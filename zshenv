#!/usr/bin/env bash

# http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
[[ -z "$XDG_DATA_HOME" ]]   && export XDG_DATA_HOME="$HOME/.local/share"
[[ -z "$XDG_DATA_DIRS" ]]   && export XDG_DATA_DIRS=/usr/local/share/:/usr/share/
[[ -z "$XDG_CONFIG_HOME" ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -z "$XDG_CONFIG_DIRS" ]] && export XDG_CONFIG_DIRS=/etc/xdg
[[ -z "$XDG_CACHE_HOME" ]]  && export XDG_CACHE_HOME="$HOME/.cache"

export _JAVA_AWT_WM_NONREPARENTING=true

export CODEX_DISABLE_WORKSPACE=true

export GHCUP_USE_XDG_DIRS=true

export HTTPIE_CONFIG_DIR="$XDG_CONFIG_HOME/httpie"

export HSPEC_OPTIONS="--color"

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

export SPACEMACSDIR="$XDG_CONFIG_HOME/spacemacs.d"

export TERM='xterm-256color'

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export PSQLRC="$XDG_CONFIG_HOME/psql/psqlrc"
export PSQL_HISTORY="$XDG_DATA_HOME/psql/history"

if [[ $OSTYPE == darwin* ]]; then
  export DARWIN=1
fi

. ~/.nix-profile/etc/profile.d/hm-session-vars.sh

export PATH=$PATH:~/.local/bin:~/.cabal/bin
