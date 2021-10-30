;function testing.ahk
; Shows a function will return it's value properly

#warn

Home::

MsgBox, % edgeSearch()
return

edgeSearch(){
xPos1:=0
xPos1++
return, xPos1
}

End::ExitApp