;pixelsearch.ahk
; Searches for a colour in a given coord box and if it's found clicks it

CoordMode, pixel, screen
CoordMode, mouse, screen

x::SetTimer, label, % (toggle := !toggle) ? 50 : "Off"

label:
    PixelSearch, OutputVarX, OutputVarY, 3312, 427, 3320, 435, 0xFFFFFF, 3,RGB
    if !errorlevel{
        MouseClick, left, OutputVarX, OutputVarY
        OutputDebug, % "Success"
    }
    else{
        OutputDebug, % "fail"
    }

return


End::
*esc::exitapp


