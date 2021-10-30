# Misc-Scripts
#### A collection scripts that I've found useful

---

## [AutoHotKey](https://www.autohotkey.com/)
#### All scripts use ahk v1 unless specified otherwise.
- [**Clippy.ahk:**](https://github.com/Firecul/Misc-Scripts/blob/master/AutoHotKey%20Scripts/Clippy.ahk)  
Allows you to use multiple clipboards simultaneously.

- [**Minimize GoXLR.ahk:**](https://github.com/Firecul/Misc-Scripts/blob/master/AutoHotKey%20Scripts/Minimize%20GoXLR.ahk)  
Compile and add to your start items at log on to cause the GoXLR app to automatically minimize after it launches during login.

- [**Steam Lookup.ahk:**](https://github.com/Firecul/Misc-Scripts/blob/master/AutoHotKey%20Scripts/Steam%20Lookup.ahk)  
Looks up a Steam profile from it's hex id using [Steam ID Finder](https://steamidfinder.com/).

- [**The Great Suspender Exported Sessions URL Fixer.ahk:**](https://github.com/Firecul/Misc-Scripts/blob/master/AutoHotKey%20Scripts/The%20Great%20Suspender%20Exported%20Sessions%20URL%20Fixer.ahk)  
Thanks to the current maintainer of The Great Suspender chrome extension adding in unknown code it was removed from the chrome store without warning to users.  This script (and it's compiled exe if you don't want to install ahk) are to take the extentions export files and remove the `chrome-extension://klbibkeccnjlkjkiokjodocebajanakg/suspended.html#ttl=Google&pos=0&uri=https://www.google.com/` and convert it to `https://www.google.com/`

#### I have placed a number of .ahk scripts into [Random Discord Scripts](AutoHotKey%20Scripts/Random%20Discord%20Scripts) that I've tinkered with for the people over there.

---

## Bash

- [**GitlabBackup.sh:**](https://github.com/Firecul/Misc-Scripts/blob/master/Bash/GitlabBackup.sh)  
Takes a list of Gitlab repos and backs them up, useful for self hosted servers.

---

## Batch

- [**Convert MKV to MP4.bat:**](https://github.com/Firecul/Misc-Scripts/blob/master/Batch/Convert%20MKVs%20to%20MP4.bat)  
Run to convert all MKV files in the folder to MP4 losslessly using [ffmpeg](https://ffmpeg.org/download.html), based on [this gist by JamesMacWhite](https://gist.github.com/jamesmacwhite/58aebfe4a82bb8d645a797a1ba975132). MKVs are not deleted.

- [**Delete All MKVs.bat:**](https://github.com/Firecul/Misc-Scripts/blob/master/Batch/Delete%20All%20MKVs.bat)  
Deletes all MKVs in the folder.

- [**Make Gif from MP4.bat:**](https://github.com/Firecul/Misc-Scripts/blob/master/Batch/Make%20Gif%20from%20MP4.bat)  
Makes a custom Gif from any MP4 video using [ffmpeg](https://ffmpeg.org/download.html), heavily based on [this script by SleepProgger](https://github.com/SleepProgger/my_ffmpeg_utils/blob/master/video2gif.bat)

- [**StartServer.bat:**](https://github.com/Firecul/Misc-Scripts/blob/master/Batch/StartServer.bat)  
Starts the FiveM server after deleting the cache.  Put in the same folder as run.cmd.

- [**Trim MP4.bat:**](https://github.com/Firecul/Misc-Scripts/blob/master/Batch/Trim%20MP4.bat)  
Cuts an MP4 into a smaller file using [ffmpeg](https://ffmpeg.org/download.html). Cuts to the nearest keyframe in front of the time given.

---

## [Python](https://www.python.org/)
#### Most built using Python 3

- [**off_button.py:**](https://github.com/Firecul/Misc-Scripts/blob/master/Python/off_button.py)  
This script was authored by AndrewH7 and belongs to him (www.instructables.com/member/AndrewH7)
Shut down your Raspberry Pi by momentarily connecting pin 21 of the GPIO to ground.

- [**shutdown_pi.py:**](https://github.com/Firecul/Misc-Scripts/blob/master/Python/shutdown_pi.py)  
My version of [off_button.py](https://github.com/Firecul/Misc-Scripts/blob/master/Python/off_button.py) - Shut down your Raspberry Pi after 1 minute by momentarily connecting pin 21 of the GPIO to ground.