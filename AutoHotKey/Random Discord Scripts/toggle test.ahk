;toggle test
; When toggle is true enables the e::f keybind
; Also an example of toggling 

$a::
toggle := !toggle
return

#IF (toggle)

$e::f

#IF

NumpadDiv::
SMpause := !SMpause
If (!SMpause) {
MsgBox, "pause false" ; [code to click on the icon to pause playback]
}
else {
msgbox, "pause true" ; [code to click on the icon to resume playback]
}
return

3::ExitApp
