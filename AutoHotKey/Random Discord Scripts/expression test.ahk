;expression test.ahk
; Shows a difference between the old and new style syntaxes for ahk


test = 1
newtest := 1

test = test + 1
test2 := newtest + 1
MsgBox, % "1:" . test . "`n2:" . test2

