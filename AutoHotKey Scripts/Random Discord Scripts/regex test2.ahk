;regex test2.ahk
; Removes quotation marks from a given string

teststring := """Hello"""

removalstring := "\x22"

output := RegExReplace(teststring,removalstring, "")

MsgBox, % teststring . "`n" . output
