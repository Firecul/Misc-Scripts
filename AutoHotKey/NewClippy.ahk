#SingleInstance Force
#Warn

SendMode, Input
Global SleepLength := 50

;Save Keys
Numpad1::Clippy.Save(1)
Numpad2::Clippy.Save(2)
Numpad3::Clippy.Save(3)

;Read Keys
Numpad4::Clippy.Read(1)
Numpad5::Clippy.Read(2)
Numpad6::Clippy.Read(3)

;New Magic
Class Clippy {
   Static slots := []
   
   Save(ClipboardNumber) {
       Global
       SavedClipboard := Clipboard
       Clipboard := ""
       Send ^c
       ClipWait, 2
       this.slots[ClipboardNumber] := Clipboard
       Clipboard := SavedClipboard
       Return
   }
   Read(ClipboardNumber) {
       Global
       SavedClipboard := Clipboard
       Clipboard := ""
       Clipboard := this.slots[ClipboardNumber]
       ClipWait, 2
       Send ^v
       Sleep, SleepLength
       Clipboard := SavedClipboard
       Return
   }
}
