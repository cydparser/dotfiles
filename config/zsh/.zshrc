ZSH=~/.oh-my-zsh

ZSH_THEME="lambda" # kardan

DISABLE_AUTO_UPDATE="true"

# Display red dots while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=( docker git stack )

zstyle :omz:plugins:ssh-agent agent-forwarding on

source $ZSH/oh-my-zsh.sh

# auto-correct commands only
unsetopt correct_all
setopt correct
# allow comments
setopt interactive_comments

for d in /usr/local/share/zsh-completions ~/.nix-profile/share/zsh/site-functions; do
  [[ -e "$d" ]] && fpath=("$d" $fpath)
done

autoload -U compinit
compinit

export HISTFILE="$XDG_DATA_HOME/zsh/history"

for f in "$XDG_CONFIG_HOME/profile"/*; do
  source "$f"
done
