;crappyarraything.ahk
; Fires different functions depending on the position of a slider in a gui
; This example is with 2 windows


Slide2:
array2 := ["3","4"] ;ArrayList
MaxRange := array2.MaxIndex() ;Ranges
gui, 1:add, slider, vSlider2 gSlide2 y+m w80 Range1-%MaxRange% gSliderFunc2, 2 ;Slider

Slide1:
array := ["1","2"] ;ArrayList
MaxRange := array.MaxIndex() ;Ranges
gui, 2:add, slider, vSlider1 gSlide1 w80 Range1-%MaxRange% gSliderFunc1, 1 ;Slider


gui, 2:show, w300 h300
gui, 1:show, w300 h300 x10 y10

return

SliderFunc1:
Func(array[Slider1]).Call() ;ArrayFunction
Return

1() { ;Sliders Position
gosub Example1 ;Slider Label
}

2() { ;Sliders Position
gosub Example2 ;Slider Label
}

Example1:
MsgBox, lkjhjkh
return

Example2:
MsgBox, kjhkjhkugh
return

SliderFunc2:
Func(array2[Slider2]).Call() ;ArrayFunction
Return

3() { ;Sliders Position
gosub Example3 ;Slider Label
}

4() { ;Sliders Position
gosub Example4 ;Slider Label
}

Example3:
MsgBox, Example Code3
return

Example4:
MsgBox, Example Code4
return