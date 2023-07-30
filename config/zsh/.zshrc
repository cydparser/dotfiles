#!/usr/bin/env zsh

# auto-correct commands only
unsetopt correct_all
setopt correct
# allow comments
setopt interactive_comments

# Preserve partial lines--append '%' to output.
setopt prompt_sp

for d in /usr/local/share/zsh-completions ~/.nix-profile/share/zsh/site-functions; do
  [[ -e "$d" ]] && fpath=("$d" $fpath)
done

path=( "$HOME/.local/bin" $path )

autoload -U compinit
compinit

HISTFILE="$XDG_DATA_HOME/zsh/history"
HISTSIZE=4096
SAVEHIST=4096
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history

if [[ -n "$DARWIN" ]]; then
  # Bind delete key.
  bindkey "^[[3~"  delete-char
  bindkey "^[3;5~" delete-char
fi

WORDCHARS='*?.[]~&;!#$%^(){}<>'

# Color numbers match config/termite/config.
COLOR_YELLOW=3
COLOR_ORANGE=1
COLOR_RED=13
COLOR_MAGENTA=5
COLOR_VIOLET=12
COLOR_BLUE=14
COLOR_CYAN=6
COLOR_GREEN=2

ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )

typeset -A ZSH_HIGHLIGHT_STYLES
# main highlighter
ZSH_HIGHLIGHT_STYLES[arg0]="fg=blue"
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]="fg=$COLOR_VIOLET"
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=$COLOR_VIOLET"
ZSH_HIGHLIGHT_STYLES[comment]="fg=$COLOR_BASE01"
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=$COLOR_VIOLET"
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]="fg=cyan"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=cyan"
ZSH_HIGHLIGHT_STYLES[path]="fg=blue"
ZSH_HIGHLIGHT_STYLES[function]="fg=blue"
ZSH_HIGHLIGHT_STYLES[hashed-command]="fg=blue"
ZSH_HIGHLIGHT_STYLES[command]="fg=blue"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=cyan"
ZSH_HIGHLIGHT_STYLES[precommand]="fg=cyan"
ZSH_HIGHLIGHT_STYLES[alias]="fg=$COLOR_VIOLET"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=cyan"
ZSH_HIGHLIGHT_STYLES[suffix-alias]="none"
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=$COLOR_MAGENTA"
# brackets highlighter
ZSH_HIGHLIGHT_STYLES[bracket-error]="fg=$COLOR_MAGENTA,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-1]="fg=blue,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-2]="fg=$COLOR_VIOLET,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-3]="fg=cyan,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-4]="fg=green,bold"

zstyle ':completion:*' matcher-list \
       'm:{a-z-}={A-Z_}' \
       'r:|[-_./]=* r:|=*'

for f in "$XDG_CONFIG_HOME/profile"/*; do
  source "$f"
done

eval "$(direnv hook zsh)"

if [[ "$TERM" != 'dumb' ]]; then
  eval "$(starship init zsh)"
fi
