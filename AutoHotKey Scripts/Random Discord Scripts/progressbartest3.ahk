;progressbartest3.ahk
; Completes one progress bar then triggers the next. Also stops loop once progress of either is full

Gui, Show, w300 h300, Simple Progress Bar
Gui, Add, Progress, w100 h20 x10 y40 cBlue vMyProgress
Gui, Add, Progress, w100 h20 x10 y10 cBlue vMyProgress2

SetTimer, Loop1, 50
return

Loop1:
    GuiControl,, MyProgress, +10
    GuiControlGet, MyProgress
    if (MyProgress = 100)
    {
        SetTimer, Loop1, off
        SetTimer, Loop2, 100
    }
return

Loop2:
    GuiControl,, MyProgress2, +7
    GuiControlGet, MyProgress2
    if (MyProgress2 = 100)
        SetTimer, Loop2, off
return

GuiClose:
ExitApp


