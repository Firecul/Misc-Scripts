#SingleInstance, Force
#NoEnv
;#Warn
SetBatchLines -1
StringCaseSense, On
SetWorkingDir, %A_ScriptDir%

;@Ahk2Exe-SetName The Great Suspender URL Fixer
;@Ahk2Exe-SetVersion 1.0
;@Ahk2Exe-SetCopyright Firecul666@gmail.com
;@Ahk2Exe-SetDescription https://github.com/Firecul/Misc-Scripts
;@Ahk2Exe-SetLanguage 0x0809


FileSelectFile, FilePath , 3, %A_MyDocuments%, Please select exported sessions file., Documents (*.txt)
GreatSuspenderURLFix(FilePath)

Return


GreatSuspenderURLFix(FilePath){

	FileCopy, %FilePath%, %FilePath%.backup
		If (ErrorLevel){
			FileSelectFile, BackUpFilePath , S24, %BackupFilePath%, Where to save the backup file?, Backup (*.backup)
			FileCopy, %FilePath%, %BackUpFilePath%.backup
				If (ErrorLevel){
					MsgBox, 0x10, Saving Failed, An error occured whilst saving backup,`nAborting.
					Return
				}
		}

	FileRead, FileContents, %FilePath%
	StringSplit, FileLines, FileContents, `r, `n

		Loop, %FileLines0%{

		IfMatchFound := RegExMatch(FileLines%a_index%, ("O)\/\/.+\/suspended.html.+&uri=(http:\/\/.+|https:\/\/.+)"), ExtractedURL)

		If (IfMatchFound > 0){
				SanitizedURL := % ExtractedURL.1
				FileLineArray := % FileLineArray "`r`n" SanitizedURL
				Continue
			}
		else{
				FileLineArray := % FileLineArray "`r`n" FileLines%a_index%
				Continue
			}

	}

	Sort, FileLineArray, U

	FileSelectFile, NewFilePath , S24, %FilePath%, Where to save converted file?, Documents (*.txt)
		If !(ErrorLevel){
			FileDelete, %NewFilePath%
			FileAppend, %FileLineArray%, %NewFilePath%
		}
		Else{
			MsgBox, An error occured while saving.
		}

Return
}
