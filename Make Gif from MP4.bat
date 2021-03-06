@ECHO OFF

REM For general infos see http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html
REM Set the path here if your ffmpeg executable is somewhere else as in the current directory
SET ffmpeg_path=ffmpeg.exe
SET palette=%TMP%\palette.png
SET subtitlefile=subtitle.ass

if not exist "%ffmpeg_path%" echo "Can't find ffmpeg.exe" & goto done

SET /P src=Video to convert (you can drag and drop the file):
if not exist %src% echo "Can't find the video file" & goto done

SET /P start_time=Startime (ss, mm:ss, and hh:mm:ss formats are supported):
SET /P duration=Duration in seconds:
SET /P dest=Name and path for the gif [test.gif]:
if "%dest%" == "" (
	SET dest=test.gif
)
SET /P size=Size [540:-1]("width:height" format. if one is -1 the aspect ratio will be the same):
if "%size%" == "" (
	SET size=540:-1
)
SET /P fps=FPS [25]:
if "%fps%" == "" (
	SET fps=25
)
SET stats_mode=full
SET dithering=sierra2_4a

SET FC_CONFIG_DIR=.\fonts
SET FC_CONFIG_FILE=.\fonts\fonts.conf

SET /P extended=Extended settings ? [N]:
if "%extended%" == "" goto noextended
if not "%extended%" == "Y" goto noextended
SET /P stats_mode=Prioritize moving objects [N]:
if "%stats_mode%" == "Y" (
	SET stats_mode=diff
)

Setlocal DisableDelayedExpansion
:noextended
SET "filters=%subtitlefilter%fps=%fps%,scale=%size%:flags=lanczos"

echo.
echo Creating palette ...
REM Doesn't have the correct subtitle offset but it shouldn't matter
"%ffmpeg_path%" -v warning -ss %start_time% -t %duration% -i %src% -vf "%filters%,palettegen=stats_mode=%stats_mode%" -y %palette% || echo Failed creating the palette (Invalid video file ?) && goto done
echo.
echo Creating GIF ...
"%ffmpeg_path%" -v warning -i %src% -i %palette% -ss %start_time% -t %duration% -lavfi "%filters% [x]; [x][1:v] paletteuse=dither=%dithering%" -y %dest% || echo Failed creating the gif && goto done

:done
pause
exit /b
