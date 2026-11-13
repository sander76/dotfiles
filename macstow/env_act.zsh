#this file will be sources from inside .zshrc
current_act="NONE"

function env_act() {
    local find_act_file() {
            local dir="$PWD"
            while [[ "$dir" != "/" ]]; do
                if [[  -f "$dir/act.zsh" ]]; then
                    echo "$dir/act.zsh"
                    return 0
                fi
                dir="$(dirname "$dir")"
            done
            return 1
        }
    typeset -g current_act=$(find_act_file) 

    # when an act.zsh is found and current_act is NONE, run act.zsh and store it on current_act.
    # when found act equals current_act do nothing
    # when an act.zsh is found which is different from the act.zsh stored on
    # current_act: run deact.zsh which lives in the same folder as the stored act.zsh. run the new act.zsh and store it on current_act.
}

