#SingleInstance, Force

Gui, add, text,, Steam ID Hex input:
Gui, add, edit, w200 vnumber,
GUi, add, button, w200 gLaunch, Lookup ID
Gui, add, text, cBlue w200 vresult
Gui, Font, norm
Gui, Show, w220, Steam Hex Lookup
return

race:
  Gui, Submit, nohide
  Run fivem://connect/142.4.215.102
  return

testing:
  Gui, Submit, nohide
  Run fivem://connect/158.69.144.59
  return

dev:
  Gui, Submit, nohide
  Run fivem://connect/144.217.206.76
  return

GuiClose:
ExitApp
