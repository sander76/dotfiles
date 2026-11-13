# HISTFILE=~/.zsh_history
# HISTSIZE=10000
# SAVEHIST=10000

eval "$(/Users/sander.teunissen/.local/bin/mise activate zsh)" # added by https://mise.run/zsh

# zsh history stuff. `man  zshoptions` for more info
# or https://zsh.sourceforge.io/Doc/Release/Options.html
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

bindkey -v
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins 'jj' vi-cmd-mode

export KEYTIMEOUT=20  # for the jj binding to work.
export UV_DEFAULT_INDEX=https://alliander.jfrog.io/artifactory/api/pypi/pypi-all/simple/
export TERM=xterm-256color

# make vim the manpage viewer.
export MANPAGER="vim +MANPAGER --not-a-term -"

# to comply with alliander allowed containers.
export RYUK_CONTAINER_IMAGE="testcontainers/ryuk:0.14.0"

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

  print -n "%F{magenta}[${VIRTUAL_ENV:t} | ${python_version}]%f "
}

setopt PROMPT_SUBST
PROMPT='$(venv_prompt)%F{208}%~ >%f'

source <(fzf --zsh)
# fzf and keybindings.
# Set up fzf key bindings and fuzzy completion, but disable Ctrl-T and Alt-C
# FZF_ALT_C_COMMAND= source <(fzf --zsh)
# export FZF_DEFAULT_COMMAND='fd --strip-cwd-prefix'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
  --bind 'ctrl-d:reload(find . \( -name .venv -o -name .git -o -name .versify_cache -o -name __pycache__ \) -prune -o -type d -print)'
  "
export FZF_DEFAULT_OPTS='--bind=shift-tab:up,tab:down'

chpwd() {
  [[ -f ./act.zsh ]] && source ./act.zsh
}

alias l='ls -lah --color=auto'
alias gwt='~/repos/dotfiles/scripts/worktree-checkout.sh --common-folder ~/alliander/common'
alias gco="git checkout"
alias gp="git push"
alias gpf="git push --force-with-lease --force-if-includes"
alias grbc="git rebase --continue"
alias gcm="git commit -m"
alias gs="git status"
alias gd="git difftool"
alias notes="vi ~/alliander/notes.md"
alias vimdiff="vim -d"

# alias r="cd $(git rev-parse --show-toplevel)"
alias pts='source ~/repos/dotfiles/scripts/pts.zsh'
alias pc='pycharm'

alias py="ptpython"

# cd into the root of the git folder.
alias r='cd $(git rev-parse --show-toplevel)'
alias gitopen='gh browse -b $(git branch --show-current)'

bindkey '^[[Z' reverse-menu-complete
zstyle ':completion:*' menu select interactive
# fuzzy matching completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt menu_complete

from_buffer() {
    osascript <<'APPLESCRIPT'
    tell application "iTerm2"
      get contents of current session of current window
    end tell
APPLESCRIPT
}

_fd_py_widget() {
    selection=$(from_buffer | tail -n 100 | selektor - \
        "[\w\/\-\.]+\.py" \
        "[\w\/\-\.]+\.toml" \
        "[\w\/\-\.]+\.py:\d{1,4}" \
        "[\w\/\-\.]+\.py:\d{1,4}:\d{1,4}" \
        "[\w\/\-\.]+\.py::[\w\-\.]+" \
    )
  BUFFER+="$selection"
  CURSOR=${#BUFFER}
  zle reset-prompt # to clean up messy prompt
}
zle -N _fd_py_widget
bindkey '^X' _fd_py_widget



# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/sander.teunissen/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit
# End of Docker CLI completions

