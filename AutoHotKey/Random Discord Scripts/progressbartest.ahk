;progressbartest.ahk
; An example function to increment a progress bar by a certain amount

Gui, Add, Progress, w300 h20 cBlue vMyProgress
Gui, Show, x0 y0 , Simple Progress Bar

Sleep, 1000
ProgressBarControl("MyProgress", "+25")
ProgressBarControl("MyProgress", "+25", "500")
ProgressBarControl("MyProgress", "+25", "1000")
ProgressBarControl("MyProgress", "+25", "200")

GuiClose:
ExitApp

ProgressBarControl(Bar, Increment, SleepDuration := "500"){
Guicontrol,,% Bar,% Increment
Sleep, % SleepDuration
}