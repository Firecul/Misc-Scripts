#SingleInstance, Force
Gui, New
Gui, add, text,, Project Homecoming Servers:
;Gui, add, edit, w200 vAddress,
GUi, add, button, w200 default gRace, Race Server
GUi, add, button, w200 gTesting, Testing Server
GUi, add, button, w200 gDev, Dev Server
GUi, add, button, w200 gGuiClose, Exit
Gui, Show, AutoSize Center, PH FiveM Launcher
;Gui, -SysMenu +Owner
return

race:
  Run fivem://connect/142.4.215.102
  return

testing:
  Run fivem://connect/158.69.144.59
  return

dev:
  Run fivem://connect/144.217.206.76
  return

GuiEscape:
GuiClose:
ButtonCancel:
  ExitApp
