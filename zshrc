NIX_PROFILE=~/.nix-profile/etc/profile.d/nix.sh
[ -f "$NIX_PROFILE" ] && source $NIX_PROFILE

ZSH=~/.oh-my-zsh

ZSH_THEME="lambda" # kardan

DISABLE_AUTO_UPDATE="true"

# Display red dots while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git ssh-agent)

zstyle :omz:plugins:ssh-agent agent-forwarding on

source $ZSH/oh-my-zsh.sh

export PATH=~/.cabal/bin:/usr/local/bin:/usr/local/sbin:$PATH:~/bin

setopt auto_cd
# auto-correct commands only
unsetopt correct_all
setopt correct
# allow comments
setopt interactive_comments

if [[ -e /usr/local/share/zsh-completions ]]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

for f in ~/.zsh/*; do source $f; done

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
