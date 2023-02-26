#!/usr/bin/env bash

[[ -f ~/.zshenv ]] && source ~/.zshenv

if [[ -n "$PS1" ]]; then
  HISTSIZE=4096
  HISTFILESIZE=4096
  HISTCONTROL=ignoreboth
  HISTFILE="$XDG_DATA_HOME/bash/history"

  if [[ ! -e "$HISTFILE" ]]; then
    mkdir -p "$(dirname "$HISTFILE")"
    touch "$HISTFILE"
  fi

  # Join multi-line commands with a semicolon.
  shopt -s cmdhist
  # Append to the history file.
  shopt -s histappend

  for d in /usr/local/etc/bash_completion ~/.nix-profile/share/bash-completion; do
    f="$d/bash_completion"
    if [[ -e "$f" ]]; then
      source "$f"
      break
    fi
  done

  for f in "$XDG_CONFIG_HOME/profile"/*; do
    source "$f"
  done

  eval "$(starship init bash)"

fi
