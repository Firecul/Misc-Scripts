@ECHO OFF
SET /P src=Video to trim (you can drag and drop the file):

SET "dst=%src:~0,-5%"

SET /P start_time=Start point (in either ss, mm:ss or hh:mm:ss formats):
SET /P duration=Length in Seconds:
SET /P dest=Name and path for output video: [default = %dst%_trimmed.mp4"]:
if "%dest%" == "" (
	SET dest=%dst%_trimmed.mp4"
)
SET /P dof=Delete original [y/N]:
if "%dof%" == "" (
	SET dof=N
)
ffmpeg.exe -ss %start_time% -i %src% -t %duration% -avoid_negative_ts make_zero -c copy -map 0 %dest% -hide_banner

if "%dof%" == "y" goto delorg
if "%dof%" == "Y" goto delorg

:keeporg
	pause
	exit /b

:delorg
	DEL %src%
	pause
	exit /b
