# http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
[[ -z "$XDG_DATA_HOME" ]] && export XDG_DATA_HOME="${HOME}/.local/share"
[[ -z "$XDG_DATA_DIRS" ]] && export XDG_DATA_DIRS=/usr/local/share/:/usr/share/
[[ -z "$XDG_CONFIG_HOME" ]] && export XDG_CONFIG_HOME="${HOME}/.config"
[[ -z "$XDG_CONFIG_DIRS" ]] && export XDG_CONFIG_DIRS=/etc/xdg
[[ -z "$XDG_CACHE_HOME" ]] && export XDG_CACHE_HOME="${HOME}/.cache"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
[[ -z "$OPENSSL_X509_CERT_FILE" ]] && export OPENSSL_X509_CERT_FILE="${HOME}/.nix-profile/etc/ca-bundle.crt"
[[ -z "$GIT_SSL_CAINFO" ]] && export GIT_SSL_CAINFO="$OPENSSL_X509_CERT_FILE"

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

export PATH=~/.cabal/bin:/usr/local/bin:/usr/local/sbin:$PATH:~/bin

nix_profile="$HOME/.nix-profile/etc/profile.d/nix.sh"
[ -f "$nix_profile" ] && source "$nix_profile"
