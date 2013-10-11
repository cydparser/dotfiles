ZSH=$HOME/.oh-my-zsh

ZSH_THEME="lambda" # kardan

DISABLE_AUTO_UPDATE="true"

# Display red dots while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(brew git ssh-agent)

zstyle :omz:plugins:ssh-agent agent-forwarding on

source $ZSH/oh-my-zsh.sh

alias em='emacsclient -n'
alias et='emacsclient -t'
alias gwg='jruby -S rake uninstall build install'
alias jbe='jruby -S bundle'
alias pryc='pry -r ./config/environment'
alias rabls='sudo rabbitmqctl list_queues'
alias yards='yard server --reload'

export EDITOR=ec
export VISUAL=ec

export PATH=$HOME/.cabal/bin:/usr/local/bin:/usr/local/sbin:$PATH:$HOME/bin

if [[ -e ~/.zsh_local ]]; then
   source ~/.zsh_local
fi

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
