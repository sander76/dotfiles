#!/usr/bin/env zsh

typeset -g _BUFSELF_BUFFREAD="${${(%):-%x}:A:h:h}/macstow/iterm/buffread.zsh"

_bufself() {
  setopt localoptions pipefail
  if (( $# == 0 )) || [[ -z "$1" ]]; then
    print -u2 -- 'Usage: bufself <regex>'
    return 2
  fi

  local in_widget=0
  [[ ${WIDGET-} == bufself ]] && in_widget=1
  (( in_widget )) && zle -I

  local regex="$1"
  local selection
  selection=$(zsh "$_BUFSELF_BUFFREAD" | selektor "$regex")
  (( $? == 0 )) || return 1
  [[ -n "$selection" ]] || return 0

  if (( in_widget )); then
    BUFFER="$selection"
    CURSOR=${#BUFFER}
  else
    print -z -- "$selection"
  fi
}

if [[ "$ZSH_EVAL_CONTEXT" == *:file ]]; then
  zle -N bufself _bufself
fi
