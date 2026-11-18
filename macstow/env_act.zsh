# This file is sourced from .zshrc.
typeset -g current_env=${current_env:-NONE}

_env_act_find_file() {
  local dir=${PWD:A}
  while true; do
    if [[ -f "$dir/env.zsh" ]]; then
      print -r -- "$dir/env.zsh"
      return 0
    fi
    [[ "$dir" == "/" ]] && break
    dir=${dir:h}
  done
  return 1
}

_env_act_clear_functions() {
  (( $+functions[env_activate] )) && unset -f env_activate
  (( $+functions[env_deactivate] )) && unset -f env_deactivate
  return 0
}

env_act() {
  local next_env=NONE

  next_env=$(_env_act_find_file) || next_env=NONE

  [[ "$next_env" == "$current_env" ]] && return 0

  if [[ "$current_env" != NONE ]]; then
    env_deactivate || return 1
    current_env=NONE
    _env_act_clear_functions
  fi

  if [[ "$next_env" != NONE ]]; then
    _env_act_clear_functions

    if ! source "$next_env"; then
      print -u2 -- "env_act: failed to load $next_env"
      _env_act_clear_functions
      return 1
    fi

    if (( ! $+functions[env_activate] || ! $+functions[env_deactivate] )); then
      print -u2 -- "env_act: $next_env must define env_activate and env_deactivate"
      _env_act_clear_functions
      return 1
    fi

    if ! env_activate; then
      _env_act_clear_functions
      return 1
    fi
    current_env=$next_env
    return 0
  fi
}
