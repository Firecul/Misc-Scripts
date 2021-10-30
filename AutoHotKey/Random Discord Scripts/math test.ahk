;math test.ahk
; Takes a highlighted number and performes math on it

home::
{
Clipboard := 
Send, ^c
ClipWait, 1
Score := Clipboard
ModifiedScore := Score - 1
msgbox, % "Original Score is " . Score ".  Modified Score is " . ModifiedScore
}
Return

; 5
