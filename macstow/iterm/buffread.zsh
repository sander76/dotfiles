#!/usr/bin/env zsh

setopt pipefail

osascript <<'APPLESCRIPT'
tell application "iTerm2"
  get contents of current session of current window
end tell
APPLESCRIPT
