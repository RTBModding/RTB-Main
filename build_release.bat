@echo off
REM Call the Developer Command Prompt script to set up the environment
call "D:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\VsDevCmd.bat"

REM Create the build directory and clean it
if not exist "build\" mkdir "build\"
del /q "build\*.*"

REM Build dependencies
msbuild "RaceBits\src\RaceBits.sln" /property:Configuration=Release
if %errorlevel% neq 0 goto exiterror

msbuild "RaceTrackBuilder\src\RaceTrackBuilder.sln" /property:Configuration=Release
if %errorlevel% neq 0 goto exiterror

REM Copy built files to the build directory
xcopy "RaceTrackBuilder\src\bin\Release\net48\*" "build\" /s /e /y
if %errorlevel% neq 0 goto exiterror

xcopy "RaceBits\src\bin\Release\net48\*" "build\" /s /e /y
if %errorlevel% neq 0 goto exiterror

REM Clean up the build directory
echo "Cleaning meta files (this is okay to fail)"
del /q "build\*.pdb"
del /q "build\*.config"

echo.
echo.
echo "Build successful"
echo.

pause
exit /b 0

:exiterror
echo.
echo.
echo "The build failed"
echo.
pause
exit /b %errorlevel%
