; center text.ahk
; Changes Text width to keep contents centered no matter the window's width 

#SingleInstance force
gui, new
gui, add, button, w500, I
Gui, Add, Text, vHoursText Center, # hours auhfiuehfi uauhfifi uauhfi usiuash ahuohaiuhiu `n aowyoiauhdiah `n auwdiauyg `n dydgug: `nI
GUI, show

	WinGetActiveStats T,W,H,X,Y
	GuiControl, hide, HoursText
	GuiControl, Move, HoursText, % "w" . W - 25 . " h" . H
	guicontrol, show, HoursText
	return
