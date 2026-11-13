# This file is sourced from .zshrc.
typeset -g current_act=${current_act:-NONE}

_env_act_find_file() {
  local dir=${PWD:A}
  while true; do
    if [[ -f "$dir/act.zsh" ]]; then
      print -r -- "$dir/act.zsh"
      return 0
    fi
    [[ "$dir" == "/" ]] && break
    dir=${dir:h}
  done
  return 1
}

env_act() {
  local next_act=NONE

  next_act=$(_env_act_find_file) || next_act=NONE


  #   next_act     current_act
  #   -----------------------------------------
  #   None         None          Do nothing
  #   act_1.zsh    None          run act_1.zsh
  #   act_1.zsh    act_1.zsh     Do nothing
  #   act_2.zsh    act_1.zsh     run deact_1 run act_2
  #   None         act_1.zsh     reun deact_1
  #
  # Either both are NONE or are actual act files but are identical.
  # In both cases we do nothing.
  [[ "$next_act" == "$current_act" ]] && return 0

  if [[ "$next_act" != NONE && ! -f "${next_act:h}/deact.zsh" ]]; then
    print -u2 -- "env_act: missing deact.zsh for $next_act"
    return 1
  fi

  if [[ "$next_act" != NONE ]]; then
    if [[ "$current_act" != NONE ]]; then
      source "${current_act:h}/deact.zsh"
    fi
    source "$next_act"
    current_act=$next_act
    return 0
  fi
  if [[ "$current_act" != NONE ]]; then
    source "${current_act:h}/deact.zsh"
    current_act=NONE
  fi
}
