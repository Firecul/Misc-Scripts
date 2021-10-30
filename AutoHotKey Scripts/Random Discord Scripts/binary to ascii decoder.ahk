;binary to ascii decoder.ahk
; takes in a file containing binary and outputs it

file := FileOpen("purebin.txt", "r")
;OutputDebug, % file.Length

f := file.read()
;OutputDebug, % z(f)
MsgBox, % z(f)


z(z){
	z := RegExReplace(z, "[^10]")
	Loop, % StrLen(z) / 8
	{
		for each, Bit in StrSplit(SubStr(z, A_Index*8-7, 8))
			Asc += Asc + Bit
		r .= Chr(Asc), Asc := 0
	}
	return r
}
