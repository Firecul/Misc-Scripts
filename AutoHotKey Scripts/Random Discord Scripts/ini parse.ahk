;ini parse.ahk
; Takes all the key=value pairs, lists them one after another in a split up format

IniRead, SectionContents, randomcoordinates.ini, coordinates

KeyPairs := StrSplit(SectionContents, "`n")


for i, key in KeyPairs{
    KeyNameAndValues := StrSplit(KeyPairs[i], "=")
    Coords := StrSplit(KeyNameAndValues[2], " ")
    MsgBox, % "Your coordinates for " . KeyNameAndValues[1] . " are`nX1:" . Coords[1] . "`nY1:" . Coords[2] . "`nX2:" . Coords[3] . "`nY2:" . Coords[4]
}

Return
