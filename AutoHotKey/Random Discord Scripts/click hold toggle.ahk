;click hold toggle.ahk
; Uses 'k' to toggle click being help down until the next click

toggle := 0
MsgBox,,,%toggle%, 1
return

~k::    ; toggle click mode
toggle := !toggle
MsgBox,,,%toggle%, 1
return

LButton::
switch toggle {
    case 1: ; alter click
        Click, Down
        KeyWait, Lbutton, Up
        KeyWait, Lbutton, Down
        Click, Up
    case 0: ; native click
        Click, Down,
        KeyWait, LButton, Up
        Click, Up
}
return

RButton::
switch toggle {
    case 1: ; alter click
        Click, Right, Down
        KeyWait, Rbutton, Up
        KeyWait, Rbutton, Down
        Click, Right, Up
    case 0: ; native click
        Click, Right, Down
        KeyWait, RButton, Up
        Click, Right, Up
}
return

End::ExitApp
