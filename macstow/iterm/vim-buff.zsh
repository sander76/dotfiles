#!/usr/bin/env zsh

iterm_python_buffer_picker() {
  setopt localoptions pipefail
  zle -I
  zsh "$_ITERM_VIM_BUFF_DIR/buffread.zsh" | zsh "$_ITERM_VIM_BUFF_DIR/vim-buff.zsh"
}

if [[ "$ZSH_EVAL_CONTEXT" == *:file ]]; then
  typeset _ITERM_VIM_BUFF_DIR="${${(%):-%x}:A:h}"
  zle -N iterm_python_buffer_picker
  bindkey -M viins '^F' iterm_python_buffer_picker
  bindkey -M vicmd '^F' iterm_python_buffer_picker
else
  typeset temp_dir buffer_file result_file
  temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/iterm-python-search.XXXXXX") || exit 1
  buffer_file="$temp_dir/buffer"
  result_file="$temp_dir/selection"
  trap 'rm -f "$buffer_file" "$result_file"; rmdir "$temp_dir" 2>/dev/null' EXIT

  if ! cat > "$buffer_file"; then
    print -u2 -- 'Could not read the iTerm2 buffer from stdin.'
    exit 1
  fi
  if ! command -v vim >/dev/null; then
    print -u2 -- 'vim is required for the iTerm2 buffer picker.'
    exit 127
  fi

  ITERM_VIM_RESULT="$result_file" vim -n -u NONE \
    -c 'autocmd VimLeavePre * call writefile([getline(".")], expand("$ITERM_VIM_RESULT"))' \
    '+/.*\.py' "$buffer_file"

  [[ -f "$result_file" ]] && cat "$result_file"
fi
