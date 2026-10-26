# HISTFILE=~/.zsh_history
# HISTSIZE=10000
# SAVEHIST=10000


# zsh history stuff. `man  zshoptions` for more info
# or https://zsh.sourceforge.io/Doc/Release/Options.html
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

bindkey -v
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins 'jj' vi-cmd-mode
export KEYTIMEOUT=20
export UV_DEFAULT_INDEX=https://alliander.jfrog.io/artifactory/api/pypi/pypi-all/simple/

set_vi_cursor() {
  if [[ "$KEYMAP" == vicmd ]]; then
    print -n $'\e[2 q'
  else
    print -n $'\e[6 q'
  fi
}

zle-keymap-select() {
  set_vi_cursor
  zle reset-prompt
}

zle-line-init() {
  set_vi_cursor
}

zle -N zle-keymap-select
zle -N zle-line-init

# uv setup.
. "$HOME/.local/bin/env"

venv_prompt() {
  [[ -n "$VIRTUAL_ENV" ]] || return

  local python_version
  if (( $+commands[python] )); then
    python_version=$(python --version 2>&1)
  elif (( $+commands[python3] )); then
    python_version=$(python3 --version 2>&1)
  else
    python_version='Python unavailable'
  fi

  print -n "%F{magenta}[venv: ${VIRTUAL_ENV:t} | ${python_version}]%f "
}

setopt PROMPT_SUBST
PROMPT='$(venv_prompt)%F{208}%~ >%f'

# fzf and keybindings.
# Set up fzf key bindings and fuzzy completion, but disable Ctrl-T and Alt-C
# FZF_ALT_C_COMMAND= source <(fzf --zsh)
# export FZF_DEFAULT_COMMAND='fd --strip-cwd-prefix'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_CTRL_T_OPTS="
#   --bind 'ctrl-d:reload(fd --type d --strip-cwd-prefix)'
#   --bind 'ctrl-f:reload(fd --type f --strip-cwd-prefix)' \
#   "
# export FZF_DEFAULT_OPTS='--bind=shift-tab:up,tab:down'


alias l='ls -lah --color=auto'
alias gwt='~/repos/dotfiles/scripts/worktree-checkout.sh' '~/alliander/common'
alias gco="git checkout"
alias gp="git push"
alias gpf="git push --force-with-lease --force-if-includes"
alias grbc="git rebase --continue"
alias gcm="git commit -m"
alias gs="git status"
alias notes="vi ~/alliander/notes.md"

# alias r="cd $(git rev-parse --show-toplevel)"
alias pts='source ~/repos/dotfiles/scripts/pts.zsh'
alias bufself='source ~/repos/dotfiles/scripts/bufself.zsh; _bufself'

eval "$(/Users/sander.teunissen/.local/bin/mise activate zsh)" # added by https://mise.run/zsh

source <(fzf --zsh)
source "${${(%):-%x}:A:h}/iterm/vim-buff.zsh"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/sander.teunissen/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit
# End of Docker CLI completions
