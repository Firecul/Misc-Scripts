; array test.ahk
; Prints an array's contents one by one using either a loop or for statement

array := ["one"
 , "two"
 , "three"]

; Iterate from 1 to the end of the array:
Loop % array.Length()
    MsgBox % array[A_Index]

; Enumerate the array's contents:
For index, value in array
    MsgBox % "Item " index " is '" value "'"