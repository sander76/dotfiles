tell application "Finder"
		set b to bounds of window of desktop
end tell
set sw to item 3 of b
set sh to item 4 of b

tell application "System Events"
    set p to first application process whose frontmost is true
    tell window 1 of p
        set position to {0, 25} -- 25 ≈ menu bar height
        set size to {sw / 3, sh - 25}
    end tell
end tell
return input

