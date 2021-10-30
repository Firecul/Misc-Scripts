;chm launcher.ahk
; Launches the included help file for ahk, useful for when the site goes offline or unresponsive
; Normally found at C:\Program Files\AutoHotkey\AutoHotkey.chm



^F1::
    SplitPath, A_AhkPath,, AHKFolderPath
    if FileExist(AHKFolderPath . "\AutoHotkey.chm")
        Run, % AHKFolderPath . "\AutoHotkey.chm"
    else Run "https://www.autohotkey.com/docs/AutoHotkey.htm"
    return

End::ExitApp