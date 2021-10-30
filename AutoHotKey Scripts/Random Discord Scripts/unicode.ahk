; uni.ahk
; Gets the unicode value of a given character


1::
InputBox, OutputVar, Please insert a single character,

MsgBox, % "Hex: " . Format("{{}U+{:04X}{}}", Ord(OutputVar)) . "`nDec: " . Ord(OutputVar) ; Result in Dec format
return

;ExitApp
