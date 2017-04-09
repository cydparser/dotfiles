[[ -f /etc/bashrc ]] && source /etc/bashrc

[[ -f ~/.zshenv ]] && source ~/.zshenv

if [[ -n "$PS1" ]]; then
  export HISTFILE="$XDG_DATA_HOME/bash/history"
  # force ignoredups and ignorespace
  export HISTCONTROL=ignoreboth
  # append to the history file, don't overwrite it
  shopt -s histappend

  # make less more friendly for non-text input files, see lesspipe(1)
  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

  # colors
  if [[ -x /usr/bin/dircolors ]]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
  fi
  export CLICOLOR=1
  export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rb=90'
  export TERM=xterm-color
  export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'

  # ps1
  parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
  }

  for d in /usr/local/etc/bash_completion ~/.nix-profile/share/bash-completion; do
    f="$d/bash_completion"
    if [[ -e "$f" ]]; then
      source "$f"
      break
    fi
  done

  if [[ "$(whoami)" == "root" ]]; then
    export PS1="\e[0;31m\u \e[0;37m\w # \e[0m"
  else
    export PS1="\e[0;36m\u \w \e[0m"
  fi

  shopt -s cdable_vars
  # check window size and change lines and columns after each command
  shopt -s checkwinsize
fi

for f in "$XDG_CONFIG_HOME/profile"/*; do
  source "$f"
done
