;str replace.ahk
; Regexreplace example of using extracted matches

;[[Category: Images of , [[Category:Images by ** and [[Category:Images from  and replace them with [[Kategori: 

;NewStr := RegExReplace(Haystack, NeedleRegEx [, Replacement := "", OutputVarCount := "", Limit := -1, StartingPos := 1])

Haystack := "[[Category:Images from Firecul]] [[Category:Images of SecondFirecul]] [[Category:Images by 3rdFirecul]]"

NewStr := RegExReplace(Haystack, ("i)\[\[Category:\s*Images\s*(?:by|from|of)\s?(\S+)\]\]"), Replacement := "[[Kategori:$1 resimleri]]" )

OutputDebug, % Haystack . "`n" . NewStr