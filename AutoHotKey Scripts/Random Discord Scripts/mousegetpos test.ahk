;mousegetpos test
; Press Ctrl+Alt+C to toggle a tooltip of the active mouse coordinates

CoordMode, Mouse, Screen
#MaxThreadsPerHotkey, 2
^!c up::
toggle := !toggle

While toggle
{
   MouseGetPos, Cur_x, Cur_y
   pos_x := Cur_x + 15
   pos_y := Cur_y + 15
   ToolTip, X:%Cur_x% Y:%Cur_Y%, %pos_x%, %pos_y%
   ;ToolTip, X:%Cur_x% Y:%Cur_Y%, %cur_x%, %cur_y%
   sleep, 50
}
tooltip
return
