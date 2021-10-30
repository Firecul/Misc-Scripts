;listviewdeselect.ahk
; Deselects one list view when you select an item on another


; Create the ListView with two columns, Name and Size:
Gui, Add, ListView, r10 w700 vMyListView gMyListView, Name|Size (KB)

; Gather a list of file names from a folder and put them into the ListView:
Loop, %A_MyDocuments%\*.*
    LV_Add("", A_LoopFileName, A_LoopFileSizeKB)

LV_ModifyCol()  ; Auto-size each column to fit its contents.
LV_ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.


Gui, Add, ListView, r10 w700 y+m vMyListView2 gMyListView2, Name|Size (KB)

; Gather a list of file names from a folder and put them into the ListView:
Loop, %A_MyDocuments%\*.*
    LV_Add("", A_LoopFileName, A_LoopFileSizeKB)

LV_ModifyCol()  ; Auto-size each column to fit its contents.
LV_ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.

; Display the window and return. The script will be notified whenever the user double clicks a row.
Gui, Show
return


MyListView:
Gui, ListView, MyListView2
LV_Modify(LV_GetNext(),"-Select -Focus")
return

MyListView2:
Gui, ListView, MyListView
LV_Modify(LV_GetNext(),"-Select -Focus")
return



WM_LBUTTONDOWN() { ; this function anywhere else, i.e. w/ other functions
    If !A_Gui
      return
    If (A_GuiControl = "MyListView2") {
        Gui, ListView, MyListView
        LV_Modify(RowNumber,"-Select -Focus")
    }
    If (A_GuiControl = "MyListView") {
        Gui, ListView, MyListView2
        LV_Modify(RowNumber,"-Select -Focus")
    }
}






GuiClose:  ; Indicate that the script should exit automatically when the window is closed.
ExitApp