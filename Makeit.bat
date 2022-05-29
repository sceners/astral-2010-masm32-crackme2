\masm32\bin\rc.exe /v rc.rc
@echo off
echo.
echo      z ____  ________  _______
echo    / *  /  \/__/ _  /\/ ++ / /\
echo   / // /_\ / __\// /\/ // / /_/
echo  /_/\_//__/\_/_/ \_\/_/\_/\__/\
echo  \_\/\_\__\/\\_\/ \_\/ \_/\__ /
echo _____________________________ASTRAL
echo.
echo http://astral.tuxfamily.org/
echo.
\masm32\bin\ml /c /nologo /coff /Cp crackme.asm
\masm32\bin\link /SUBSYSTEM:WINDOWS /NOLOGO /SECTION:.text,ERW /LIBPATH:c:\masm32\lib *.obj rc.res
del *.res
del *.obj
pause
cls
