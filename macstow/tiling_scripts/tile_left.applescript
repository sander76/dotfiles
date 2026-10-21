on run argv
	if (count of argv) is not 1 then error "Pass 1, 2, or 3 for one-third, two-thirds, or full-width tiling." number 64
	set tileArgument to item 1 of argv
	if tileArgument is "1" then
		set tileNumerator to 1
	else if tileArgument is "2" then
		set tileNumerator to 2
	else if tileArgument is "3" then
		set tileNumerator to 3
	else
		error "Invalid tile width. Pass 1, 2, or 3." number 64
	end if

delay 0.1 -- let Spotlight close so the previous app is frontmost again

-- Prefer the primary display if it is external; otherwise use an active external display.
set displayBoundsText to do shell script "/usr/bin/swift -e " & quoted form of "import CoreGraphics; var count: UInt32 = 0; CGGetActiveDisplayList(0, nil, &count); var ids = Array(repeating: CGDirectDisplayID(0), count: Int(count)); CGGetActiveDisplayList(count, &ids, &count); let external = ids.filter { CGDisplayIsBuiltin($0) == 0 }; guard let display = external.first(where: { $0 == CGMainDisplayID() }) ?? external.first else { fatalError(\"No active external display found\") }; let b = CGDisplayBounds(display); print(\"\\(Int(b.origin.x)),\\(Int(b.origin.y)),\\(Int(b.width)),\\(Int(b.height))\")"
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
		set position of window 1 to {screenX + dockLeft, screenY + menuBarH}
		set size of window 1 to {usableW * tileNumerator / 3, usableH}
		-- some apps clamp the size on the first try, so set the position again
		set position of window 1 to {screenX + dockLeft, screenY + menuBarH}
	end tell
end tell

end run
