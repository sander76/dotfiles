tell application "System Events"
		set p to first application process whose frontmost is true
end tell


set validColumns to {"1", "2", "3"}
repeat
	set response to display dialog "Choose which screen columns the window should cover." & return & return & "The screen is split into three equal columns:" & return & "1 | 2 | 3" & return & return & "Enter the first and last column as two digits:" & return & "11 = column 1 only (left third)" & return & "12 = columns 1-2 (left two-thirds)" & return & "23 = columns 2-3 (right two-thirds)" & return & "33 = column 3 only (right third)" default answer "11" with title "Tile Window"
	set placement to text returned of response
	if (count of placement) is 2 then
		set firstColumn to character 1 of placement as text
		set lastColumn to character 2 of placement as text
		if firstColumn is in validColumns and lastColumn is in validColumns then exit repeat
	end if
	display dialog "Enter two digits from 1 to 3." & return & "Examples: 11, 12, 23, or 33." buttons {"OK"} default button "OK" with title "Invalid Columns"
end repeat

tell application "Finder"
		set b to bounds of window of desktop
end tell
set sw to item 3 of b
set sh to item 4 of b

set firstColumn to firstColumn as integer
set lastColumn to lastColumn as integer
if firstColumn > lastColumn then
	set tempColumn to firstColumn
	set firstColumn to lastColumn
	set lastColumn to tempColumn
end if

set columnWidth to sw / 3
set windowLeft to (firstColumn - 1) * columnWidth
set windowWidth to (lastColumn - firstColumn + 1) * columnWidth

tell application "System Events"
    tell window 1 of p
        set position to {windowLeft, 25} -- 25 ≈ menu bar height
        set size to {windowWidth, sh - 25}
    end tell
end tell
