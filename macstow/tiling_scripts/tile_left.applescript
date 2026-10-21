on run {input, parameters}
	delay 0.3 -- let Spotlight close so the previous app is frontmost again
	
	-- Full bounds of the primary display
	tell application "Finder" to set screenBounds to bounds of window of desktop
	set screenW to item 3 of screenBounds
	set screenH to item 4 of screenBounds
	
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
			set position of window 1 to {dockLeft, menuBarH}
			set size of window 1 to {usableW / 2, usableH}
			-- some apps clamp the size on the first try, so set the position again
			set position of window 1 to {dockLeft, menuBarH}
		end tell
	end tell
	
	return input
end run
