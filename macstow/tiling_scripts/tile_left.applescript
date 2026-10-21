on run argv
	if (count of argv) is not 2 then error "Pass a width (1, 2, or 3) and a side (l or r)." number 64
	set tileArgument to item 1 of argv
	set sideArgument to item 2 of argv
	if tileArgument is "1" then
		set tileNumerator to 1
	else if tileArgument is "2" then
		set tileNumerator to 2
	else if tileArgument is "3" then
		set tileNumerator to 3
	else
		error "Invalid tile width. Pass 1, 2, or 3." number 64
	end if
	if sideArgument is not "l" and sideArgument is not "r" then
		error "Invalid tile side. Pass l for left or r for right." number 64
	end if

-- delay 0.1 -- let Spotlight close so the previous app is frontmost again

-- Prefer the primary display if it is external; otherwise use an active external display.
set displayBoundsExecutable to (POSIX path of (path to home folder)) & ".local/bin/external-display-bounds"
set displayBoundsText to do shell script quoted form of displayBoundsExecutable
set previousDelimiters to AppleScript's text item delimiters
set AppleScript's text item delimiters to ","
set screenBounds to text items of displayBoundsText
set AppleScript's text item delimiters to previousDelimiters
set screenX to (item 1 of screenBounds) as integer
set screenY to (item 2 of screenBounds) as integer
set screenW to (item 3 of screenBounds) as integer
set screenH to (item 4 of screenBounds) as integer

set menuBarH to 25 -- use ~38 on notched MacBooks
set dockLeft to 0
set dockRight to 0
set dockBottom to 0

tell application "System Events"
	tell dock preferences
		set dockHidden to autohide
		set dockEdge to screen edge as text
	end tell
	if not dockHidden then
		tell process "Dock" to set dockSize to size of list 1
		if dockEdge is "bottom" then set dockBottom to item 2 of dockSize
		if dockEdge is "left" then set dockLeft to item 1 of dockSize
		if dockEdge is "right" then set dockRight to item 1 of dockSize
	end if
	
	set frontApp to first application process whose frontmost is true
	tell frontApp
		set usableW to screenW - dockLeft - dockRight
		set usableH to screenH - menuBarH - dockBottom
		set tileW to usableW * tileNumerator / 3
		if sideArgument is "l" then
			set tileX to screenX + dockLeft
		else
			set tileX to screenX + screenW - dockRight - tileW
		end if
		set position of window 1 to {tileX, screenY + menuBarH}
		set size of window 1 to {tileW, usableH}
		-- some apps clamp the size on the first try, so set the position again
		set position of window 1 to {tileX, screenY + menuBarH}
	end tell
end tell

end run
