# for profiling zsh startup
# zmodload zsh/zprof

export PATH="$PATH:/home/sander/bin:/$HOME/.local/bin"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000


# zsh history stuff. `man  zshoptions` for more info
# or https://zsh.sourceforge.io/Doc/Release/Options.html
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

bindkey -v
export KEYTIMEOUT=1

# Remove the default list-expand binding on bare Ctrl-G in vi keymaps so it
# doesn't race with fzf-git.sh's ^g<letter> prefix sequences (e.g. ^g^b).
bindkey -M viins -r '^G'
bindkey -M vicmd -r '^G'
#
# Change terminal cursor to reflect vi mode: always a solid block,
# but colored red in normal mode and default color in insert mode.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'      # steady block cursor
    echo -ne '\e]12;red\a' # red cursor color (normal mode)
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[2 q'    # steady block cursor
    echo -ne '\e]112\a'  # reset cursor color to default (insert mode)
  fi
}
zle -N zle-keymap-select

function zle-line-init {
  echo -ne '\e[2 q'    # steady block cursor by default (insert mode)
  echo -ne '\e]112\a'  # default cursor color
}
zle -N zle-line-init

# Ensure cursor resets to default block/color when the shell exits or a command runs.
precmd_functions+=(_reset_cursor_default)
function _reset_cursor_default() {
  echo -ne '\e[2 q'
  echo -ne '\e]112\a'
}



zstyle :compinstall filename '/
/sander/.zshrc'


autoload -Uz compinit
# Using -C to skip compaudit security check (~130ms faster)
# Run `rm ~/.zcompdump && compinit` manually after installing new completions
compinit -C


DISABLE_AUTO_TITLE="true"

function set_terminal_title(){
    echo -ne "\033]0; $PWD \007"
}
precmd_functions+=(set_terminal_title)

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  # export EDITOR='micro'
  export EDITOR='nvim'
fi
export PIP_REQUIRE_VIRTUALENV=true

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias py="python"


alias gco="git checkout"
alias gp="git push"
alias gpf="git push --force-with-lease --force-if-includes"
alias grbc="git rebase --continue"
alias gcm="git commit -m"
alias gs="git status"
alias gwt="/home/sander/repos/dotfiles/scripts/worktree-checkout.sh"

alias lg="lazygit"

# Only distinguish directories (blue) from files (default color); no other
# type-based coloring (symlinks, executables, etc.).
export LS_COLORS="di=34:fi=0:ln=0:ex=0:*=0"
alias l='ls -lah --color=auto'
alias ll='ls -lh'


# batcat alias
# alias bat='batcat'

# cd into the root of the git folder.
alias r='cd $(git rev-parse --show-toplevel)'

alias pts='source ~/repos/dotfiles/scripts/pts.zsh'

alias vi="~/.local/bin/maybe_nvim.sh"

export LESS='--chop-long-lines --HILITE-UNREAD --ignore-case --incsearch --jump-target=4 --LONG-PROMPT --no-init --quit-if-one-screen --RAW-CONTROL-CHARS --use-color --window=-4'


# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word



eval "$(/home/sander/.local/bin/mise activate zsh)" # added by https://mise.run/zsh

# fzf and keybindings.
# Set up fzf key bindings and fuzzy completion, but disable Ctrl-T and Alt-C
FZF_ALT_C_COMMAND= source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='fd --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
  --bind 'ctrl-d:reload(fd --type d --strip-cwd-prefix)'
  --bind 'ctrl-f:reload(fd --type f --strip-cwd-prefix)' \
  "
export FZF_DEFAULT_OPTS='--bind=shift-tab:up,tab:down'
source ~/repos/fzf-git.sh/fzf-git.sh

# enable zsh autosuggestions.
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/fzf-tab-completion/zsh/fzf-zsh-completion.sh
# bindkey '^I' fzf_completion
# . "$HOME/.local/bin/env"
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source ~/repos/dotfiles/config/wezterm/wezterm.sh



eval "$(starship init zsh)"


if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t default || tmux new-session -s default
fi

# for profiling output
# zprof

