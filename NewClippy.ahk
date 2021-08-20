#SingleInstance Force
#Warn
SendMode, Input
Global SleepLength := 50

;Save Keys
Numpad1::Clippy.Save(1)
Numpad2::Clippy.Save(2)
Numpad3::Clippy.Save(3)
5::Clippy.Save(1)
6::Clippy.Save(2)
7::Clippy.Save(3)

;Read Keys
Numpad4::Clippy.Read(1)
Numpad5::Clippy.Read(2)
Numpad6::Clippy.Read(3)
8::Clippy.Read(1)
9::Clippy.Read(2)
0::Clippy.Read(3)

;New Magic
Class Clippy {

	Save(ClipboardNumber) {
		Global
		this.BackupClipboard()
		Send ^c
		ClipWait, 2
		Board%ClipboardNumber% := Clipboard
		this.RestoreClipboard()
		Return
	}

	Read(ClipboardNumber) {
		Global
		this.BackupClipboard()
		Clipboard := % Board%ClipboardNumber%
		ClipWait, 2
		Send ^v
		Sleep, SleepLength
		this.RestoreClipboard()
		Return
	}

	BackupClipboard() {
		Global
		SavedClipboard := Clipboard
		Clipboard := ""
		Return
	}

	RestoreClipboard() {
		Global
		Clipboard := SavedClipboard
		Return
	}

}
