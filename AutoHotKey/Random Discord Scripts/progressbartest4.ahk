;progressbartest4.ahk
; Progress bar control from a button and another progress bar

Gui, Add, Progress, w200 h20 cBlue vMyProgress
Gui, Add, Progress, wp hp cBlue vMyProgress2
Gui, Add, Button, gRestart, Start/Restart
Gui, Show, , Simple Progress Bar
return

Restart:
    GuiControl,, MyProgress, 0
    GuiControl,, MyProgress2, 0
    SetTimer, Loop, 50
    Return

Loop:
    GuiControlGet, MyProgress
    GuiControlGet, MyProgress2
    if (MyProgress <= 99)
        GuiControl,, MyProgress, +1
    if (MyProgress > 50 && MyProgress2 <= 99)
        GuiControl,, MyProgress2, +7
    if (MyProgress = 100 && MyProgress2 = 100) {
        Msgbox, Ding!
        SetTimer, Loop, Off
    }
    return

GuiClose:
ExitApp
