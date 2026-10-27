#!/usr/bin/env zsh

typeset -g _BUFSELF_BUFFREAD="${${(%):-%x}:A:h:h}/macstow/iterm/buffread.zsh"
typeset -g _BUFSELF_HAS_SELECTION=0

_bufself() {
  setopt localoptions pipefail
  _BUFSELF_HAS_SELECTION=0
  if (( $# == 0 )) || [[ -z "$1" ]]; then
    print -u2 -- 'Usage: bufself <regex>'
    return 2
  fi

  local regex="$1"
  local selection
  selection=$(zsh "$_BUFSELF_BUFFREAD" | tail -n 100 | selektor "$regex")
  (( $? == 0 )) || return 1
  while [[ "$selection" == *$'\r' ]]; do
    selection=${selection%$'\r'}
  done
  [[ -n "$selection" ]] || return 0

  if ! printf '%s' "$selection" | pbcopy; then
    print -u2 -- 'Failed to copy selection to clipboard'
    return 1
  fi
  _BUFSELF_HAS_SELECTION=1
}

if [[ "$ZSH_EVAL_CONTEXT" == *:file ]]; then
  zle -N bufself _bufself
fi
