#!/bin/bash
# runs after a worktree has been created.
#
set -eu


script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
common_dir="$script_dir/__common"
worktree_dir="$1"

printf 'Worktree folder: %s\n' "$worktree_dir"
printf 'root dir %s\n' "$script_dir"


################################################################################################
# Copying over or symlinking common files.
# We will be looking for a __common folder.
#
for source in "$common_dir"/links/* "$common_dir"/links/.[!.]* "$common_dir"/links/..?*; do
  [ -e "$source" ] || [ -L "$source" ] || continue
  destination="$worktree_dir/$(basename "$source")"
  if [ -e "$destination" ] || [ -L "$destination" ]; then
    continue
  fi
  ln -s "$source" "$destination"
done

cp -R "$common_dir/copies/." "$worktree_dir/"


################################################################################################
# Pycharm config workaround and hacking.
#
pycharm_global_workspace_dir="/Users/sander.teunissen/Library/Application Support/JetBrains/PyCharm2026.2/workspace"

# the file which will be copied over to the pycharm_global_workspace_dir, renamed
# with a randomized name.
source_file="/Users/sander.teunissen/repos/dotfiles/macstow/pycharm-state.xml"

if [[ ! -f "$source_file" ]]; then
    printf 'Source file not found: %s\n' "$source_file" >&2
    exit 1
fi


while :; do
    name=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 27)
    [[ ${#name} -eq 27 ]] || continue

    destination="$pycharm_global_workspace_dir/$name.xml"
    [[ -e "$destination" || -L "$destination" ]] || break
done

cp "$source_file" "$destination"

mkdir -p "$worktree_dir/.idea"
cat > "$worktree_dir/.idea/workspace.xml" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="ProjectId" id="$name" />
</project>
EOF
printf 'Created %s\n' "$destination"
