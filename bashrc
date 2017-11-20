#!/usr/bin/env bash

[[ -f ~/.zshenv ]] && source ~/.zshenv

if [[ -n "$PS1" ]]; then

  HISTSIZE=4096
  HISTFILESIZE=4096
  HISTFILE="$XDG_DATA_HOME/bash/history"
  HISTCONTROL=ignoreboth
  PATH="$HOME/.local/bin:$PATH"

  # Append to the history file.
  shopt -s histappend

  for d in /usr/local/etc/bash_completion ~/.nix-profile/share/bash-completion; do
    f="$d/bash_completion"
    if [[ -e "$f" ]]; then
      source "$f"
      break
    fi
  done

  if [[ "$USER" == "root" ]]; then
    export PS1="\e[0;31m\u \e[0;37m\w # \e[0m"
  else
    export PS1="\e[0;36m\u \w \e[0m"
  fi
fi

for f in "$XDG_CONFIG_HOME/profile"/*; do
  source "$f"
done
