;random counter.ahk
; Counts and keeps track of how many times the RightAlt has been pressed

s:= 0
return



LControl & RAlt::
>!::
RAlt::
<^>!::
s:= s + 1
send {s}
MsgBox, 8192, counter, % s, 500
return