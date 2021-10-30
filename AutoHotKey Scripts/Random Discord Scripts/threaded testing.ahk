;threaded testing.ahk
; Using Psudo-threading to do multiple things at the same time
; In this example, asks for user input and while waiting launches window speach recoqnition

#persistent

F5::
^q::
SetTimer, launchspeech, -500
InputBox, userinput,
clipboard := userinput
return

launchspeech:
send, #h
return
