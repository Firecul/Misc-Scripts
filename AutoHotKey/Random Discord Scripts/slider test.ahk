;slider test.ahk
; Executing function when manipulating slider

Gui, add, Slider, vmyslider gmysliderfunc range1-5, 5
gui, show
return

mysliderfunc:
array := ["hello", "world", "how", "are", "you"]

msgbox, % array[myslider]
return

home::Exitapp