;gui hidebutton.ahk
; Shows a different button depending on t he position of a drop down list. 


Gui, Add, DropDownList, gShowHide vSelection, ||Button1|Button2|Button3|Button4
Gui, Add, Button, vButton1, Button1
Gui, Add, Button, vButton2, Button2
Gui, Add, Button, vButton3, Button3
Gui, Add, Button, vButton4, Button4
Gui, Show
GoSub, ShowHide
Return
ShowHide:
Gui, Submit, NoHide
For k,v in ["Button1","Button2","Button3","Button4"]
GuiControl, Hide, % v
GuiControl, Show, % Selection
Return
q::
exitapp