if [ $# -eq 0 ]; then
    selected_repo=$(find ~/repos ~/baringa -maxdepth 1 -type d | fzf)
else
    selected_repo=$(find ~/repos ~/baringa -maxdepth 1 -type d | fzf -q "$1")
fi

if [ -n "$selected_repo" ]; then
    cd "$selected_repo"
    code $selected_repo
fi

cd "$selected_repo"
