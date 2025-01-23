@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Usage: %0 ^<folder_path^>
    exit /b 1
)

set "source_folder=%~1"
set "script_folder=%~dp0"

if not exist "%source_folder%" (
    echo Error: Folder "%source_folder%" does not exist.
    exit /b 1
)

set "folders_checked="

for %%f in ("%source_folder%\*.*") do (
    if not "%%~xf"=="" (
        set "filename=%%~nf"
        for /f "tokens=1" %%a in ("!filename!") do (
           set "datepart=%%a"

            if not exist "%script_folder%!datepart!" (
               echo Creating folder "%script_folder%!datepart!"
                mkdir "%script_folder%!datepart!"
            )

           echo Copying "%%f" to "%script_folder%!datepart!"
           copy "%%f" "%script_folder%!datepart!"

        )
     )
)


echo.
echo Checking folders for file count...

for /d %%d in ("%script_folder%*") do (
    set "folder_name=%%~nd"
    set "file_count=0"
    for %%f in ("%%d\*") do (
        if not "%%~xf"=="" (
            set /a file_count+=1
        )
    )
    if !file_count! LSS 48 (
        echo There's less than 48 files in folder !folder_name!
    )
    
    set "folders_checked=!folders_checked! %%d"
)


echo.
echo Done!
pause
endlocal
exit /b 0
