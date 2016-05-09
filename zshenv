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

if [[ -n "$DARWIN" ]]; then
  NIX_PROFILE="$HOME/.nix-profile/etc/profile.d/nix.sh"
else
  NIX_PROFILE="$HOME/.nix-profile/etc/profile"
fi

if [[ -f "$NIX_PROFILE" ]]; then
  source "$NIX_PROFILE"
fi

export PATH=$PATH:~/.local/bin
