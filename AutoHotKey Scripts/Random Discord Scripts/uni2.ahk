; uni2.ahk
; Sends given text using it's ascii equivalent 

2::
string := "My TeXt"
SendAsc(string)
SendAsc(s) {
    static min := Asc("A")
    for _, v in StrSplit(s) {
        asc := Asc(v)
        SendInput % (asc >= min && asc < min + 26)?Format("{U+{:04x}}",asc):v
    }
}
return
