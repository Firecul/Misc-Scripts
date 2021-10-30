; 9-8 loop.ahk
; Pressing 7 on the numpad starts a set timer loop to press 9 then 8 in 9.5s and 1.9s respectively


Numpad7::
    SetTimer, longSleep, % (toggle := !toggle) ? -9500 : "Off"
    if(!toggle)
        SetTimer, shortSleep, Off
return

longSleep:
    Send, 9
    SetTimer, shortSleep, -1900
return

shortSleep:
    Send, 8
    SetTimer, longSleep, -9500
return
