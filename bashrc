# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

export EDITOR='ec'

if [[ `whoami` == "root" ]]; then
    export PATH=$PATH:/usr/local/sbin
else
    export PATH=/usr/local/bin:/usr/local/sbin:$PATH:~/bin
fi

if [[ -n "$PS1" ]]; then
    # force ignoredups and ignorespace
    export HISTCONTROL=ignoreboth

    # append to the history file, don't overwrite it
    shopt -s histappend

    # make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

    # Colors
    if [[ -x /usr/bin/dircolors ]]; then
	eval "`dircolors -b`"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
    fi

    parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    }

    if [[ "`whoami`" == "root" ]]; then
	export PS1="\e[0;31m\]\u \e[0;37m\]\w # \e[0m\]"
    else
	export PS1="\e[0;34m\]\u \e[0;37m\]\w\$(parse_git_branch) $ \e[0m\]"
    fi

    export CLICOLOR=1
    export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rb=90'
    export TERM=xterm-color
    export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'

    # bash completion settings (actually, these are readline settings)
    bind "set completion-ignore-case on" # note: bind is used instead of setting these in .inputrc.  This ignores case in bash completion
    bind "set bell-style none" # No bell, because it's damn annoying
    bind "set show-all-if-ambiguous On" # this allows you to automatically show completion without double tab-ing

    # Turn on advanced bash completion if the file exists (get it here: http://www.caliban.org/bash/index.shtml#completion)
    if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
    fi

    if [ -f `brew --prefix`/etc/bash_completion ]; then
	. `brew --prefix`/etc/bash_completion
    fi

    # Bookmarking Folders:
    #   $ save folder_alias
    #   $ cd folder_alias
    #   $ show
    if [ ! -f ~/.dirs ]; then
	touch ~/.dirs
    fi

    alias show='cat ~/.dirs'
    save (){
	command sed "/!$/d" ~/.dirs > ~/.dirs1; \mv ~/.dirs1 ~/.dirs; echo "$@"=\"`pwd`\" >> ~/.dirs; source ~/.dirs ; 
    }
    source ~/.dirs  # Initialization for the above 'save' facility: source the .sdirs file

    shopt -s cdable_vars # set the bash option so that no '$' is required when using the above facility
    shopt -s checkwinsize # After each command, checks the windows size and changes lines and columns

fi # end -n $PS1

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

# Aliases
if [[ -f ~/.bash.d/aliases ]]; then
    . ~/.bash.d/aliases
fi

# OS specific changes
OS=`uname -s`
if [[ -f ~/.bash.d/$OS ]]; then
    . ~/.bash.d/$OS
fi

# Local changes
if [ -f ~/.bash.d/local ]; then
    . ~/.bash.d/local
fi

# RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
