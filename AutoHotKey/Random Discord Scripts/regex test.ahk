; regex test
; Shows an example of how to pull wanted text from a variable using regex
; Also can take in a file instead

variable = (
/FontInfo 16 dict dup begin
  /version (001.000) readonly def
  /FullName (Hu-TrumpetLite-Regular) readonly def
  /FamilyName (Hu-TrumpetLite) readonly def )

;FileRead, variable, regextest.txt

RegExMatch(variable, "FullName \(([^)]+)\)", test)
MsgBox, % test1
