if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

[[ -e ~/.zshenv ]] && source ~/.zshenv

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

  if [[ "`whoami`" == "root" ]]; then
    export PS1="\e[0;31m\]\u \e[0;37m\]\w # \e[0m\]"
  else
    export PS1="\e[0;36m\]\u \w \$(parse_git_branch)$ \e[0m\]"
  fi

  if [ -f /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
  fi

  shopt -s cdable_vars
  # check window size and change lines and columns after each command
  shopt -s checkwinsize

fi

# ssh-agent setup
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
  echo "Initialising new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add -k;
}

# Source SSH settings, if applicable
if [[ -f "${SSH_ENV}" ]]; then
  . "${SSH_ENV}" > /dev/null
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
  }
else
  start_agent;
fi

for f in "$XDG_CONFIG_HOME/profile"/*; do
  source "$f"
done
