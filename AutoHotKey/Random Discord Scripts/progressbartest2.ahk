;progressbartest2.ahk
; Increments 2 progress bars simultaniously

Gui, 1:Show, w300 h300, Simple Progress Bar
Gui, 1:Add, Progress, vMyProgress1 w150 h20 x10 y10
Gui, 1:Add, Progress, vMyProgress2 y+m w150 h20

SetTimer, Loop1, 50
SetTimer, Loop2, 50

Loop1:
GuiControl,, MyProgress1, +1
return

Loop2:
GuiControl,, MyProgress2, +7
return


GuiClose:
ExitApp