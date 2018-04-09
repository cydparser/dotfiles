#!/usr/bin/env bash

# http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
[[ -z "$XDG_DATA_HOME" ]]   && export XDG_DATA_HOME="$HOME/.local/share"
[[ -z "$XDG_DATA_DIRS" ]]   && export XDG_DATA_DIRS=/usr/local/share/:/usr/share/
[[ -z "$XDG_CONFIG_HOME" ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -z "$XDG_CONFIG_DIRS" ]] && export XDG_CONFIG_DIRS=/etc/xdg
[[ -z "$XDG_CACHE_HOME" ]]  && export XDG_CACHE_HOME="$HOME/.cache"

export _JAVA_AWT_WM_NONREPARENTING=true

export CODEX_DISABLE_WORKSPACE=true

export DICPATH="$HOME/.nix-profile/share/hunspell"

export HTTPIE_CONFIG_DIR="$XDG_CONFIG_HOME/httpie"

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

export SPACEMACSDIR="$XDG_CONFIG_HOME/spacemacs.d"

export TERM='xterm-256color'

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

if [[ $OSTYPE == darwin* ]]; then
  export DARWIN=1
fi

export PATH=$PATH:~/.local/bin
