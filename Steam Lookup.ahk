Gui, add, text,, Steam ID Hex input:
Gui, add, edit, w200 vnumber, 0x
GUi, add, button, w200 gConvert, Lookup ID
Gui, add, text, cBlue w200 vresult
Gui, Font, norm
Gui, Show, w545460846811 w220, Steam Hex Lookup
return

Convert:
  Gui, Submit, nohide
  SetFormat, integer, decimal
  number := "0x" number
  result := number+0
  Run https://steamidfinder.com/lookup/%result%/
  return

GuiClose:
ExitApp
