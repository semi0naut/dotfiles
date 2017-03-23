@echo off

REM
REM  To run this at startup, use this as your shortcut target:
REM  %windir%\system32\cmd.exe /k x:\dev\c-shell.bat
REM

call "X:\Programs\Visual Studio 15\VC\vcvarsall.bat" x64
REM not sure if i want this for all projects
REM set _NO_DEBUG_HEAP=1
call "C:\Program Files\Git\git-bash.exe"
