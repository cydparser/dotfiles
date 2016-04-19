# http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
[[ -z "$XDG_DATA_HOME" ]] && export XDG_DATA_HOME="$HOME/.local/share"
[[ -z "$XDG_DATA_DIRS" ]] && export XDG_DATA_DIRS=/usr/local/share/:/usr/share/
[[ -z "$XDG_CONFIG_HOME" ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -z "$XDG_CONFIG_DIRS" ]] && export XDG_CONFIG_DIRS=/etc/xdg
[[ -z "$XDG_CACHE_HOME" ]] && export XDG_CACHE_HOME="$HOME/.cache"

export SPACEMACSDIR="$XDG_CONFIG_HOME/spacemacs.d"
export TERM=xterm-256color
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

[[ $OSTYPE == darwin* ]] && export DARWIN=1

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

path-remove() {
  export PATH="${PATH//$1:/}"
}

path-append() {
  if [[ -e "$1" ]] && ! [[ "$PATH" =~ "$1" ]]; then
    PATH="${PATH//$1:/}"
    export PATH="${PATH//::/:}:$1"
  fi
}

path-prepend() {
  if [[ -e "$1" ]]; then
    PATH="${PATH//$1:/}"
    export PATH="$1:${PATH//::/:}"
  fi
}

path-append ~/bin
path-prepend /usr/local/sbin
path-prepend /usr/local/bin
path-prepend ~/Library/Haskell/bin
path-prepend ~/.cabal/bin
path-prepend ~/.local/bin

if [[ -n "$DARWIN" ]]; then
  NIX_PROFILE="$HOME/.nix-profile/etc/profile.d/nix.sh"
else
  NIX_PROFILE="$HOME/.nix-profile/etc/profile"
fi

if [[ -f "$NIX_PROFILE" ]]; then
  source "$NIX_PROFILE"
fi
