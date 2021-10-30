;mouse wsad thing.ahk
; Allow mouse to control the wasd

#Persistent

Home::SetTimer, SendShit, % (toggle := !toggle) ? 100 : "Off"
return


SendShit:

	MouseGetPos, OutputVarX, OutputVarY,

	If (OutputVarY < (A_ScreenHeight / 3))
	Send, w

	If (OutputVarX < (A_ScreenWidth / 3))
	Send, a

	If (OutputVarY > ((A_ScreenHeight / 3))*2)
	Send, s

	If (OutputVarX > ((A_ScreenWidth / 3)*2))
	Send, d
	return


End::ExitApp
