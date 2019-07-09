#SingleInstance, Force

Gui, add, text,, FiveM Server Address:
Gui, add, edit, w200 vnumber,
GUi, add, button, w200 gRace, Race Server
GUi, add, button, w200 gTesting, Testing Server
GUi, add, button, w200 gDev, Dev Server
;Gui, add, text, cBlue w200 vresult
Gui, Font, norm
Gui, Show, w220, FiveM Launcher
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
