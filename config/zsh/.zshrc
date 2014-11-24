ZSH=~/.oh-my-zsh

ZSH_THEME="lambda" # kardan

DISABLE_AUTO_UPDATE="true"

# Display red dots while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git ssh-agent)

zstyle :omz:plugins:ssh-agent agent-forwarding on

source $ZSH/oh-my-zsh.sh

setopt auto_cd
# auto-correct commands only
unsetopt correct_all
setopt correct
# allow comments
setopt interactive_comments

if [[ -e /usr/local/share/zsh-completions ]]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

export HISTFILE="$XDG_DATA_HOME/zsh/history"

for f in "$XDG_CONFIG_HOME/profile"/*; do
  source "$f"
done
