;ctrl clicker.ahk
; Clickes on a certain part of the screen then returns the pointer to it's previous location

z::
CoordMode, Mouse, Screen
MouseGetPos, OutputVarX, OutputVarY, 
MouseClick, L, 650, 66, 1
MouseMove, % OutputVarX, % OutputVarY
;Sleep, 150
;Send {Down}
return

end::ExitApp