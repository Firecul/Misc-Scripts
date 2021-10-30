#SingleInstance Force

Global SleepLength := 50


;Key::Clippy(Command, ClipboardNumber)

;Save Keys
Numpad1::Clippy("Save", 1)
Numpad2::Clippy("Save", 2)
Numpad3::Clippy("Save", 3)

;Read Keys
Numpad4::Clippy("Read", 1)
Numpad5::Clippy("Read", 2)
Numpad6::Clippy("Read", 3)


;Magic
Clippy(Command, ClipboardNumber)
{
	Global
 	If (Command = "Save")
 	{
			SavedClipboard := Clipboard
			Send ^c
			Sleep, SleepLength
			Board%ClipboardNumber% := Clipboard
			Clipboard := SavedClipboard
			Return
	}
	Else If (Command = "Read")
	{
			SavedClipboard := Clipboard
			Clipboard := % Board%ClipboardNumber%
			Send ^v
			Sleep, SleepLength
			Clipboard := SavedClipboard
			Return
 	}
 	Else
 	{
 		MsgBox, Please check the "Command" parameter sent to the function.
 		Return
 	}
 	Return ;Just in case, should never get here though
}
