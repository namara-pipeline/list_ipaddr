@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set "input_file=list.txt"
set "temp_file=temp.html"
set "output_file=ip.html"

REM HTML
(
echo ^<html^>
echo     ^<head^>
echo         ^<title^>IPアドレス一覧^</title^>
echo         ^<style^>
echo             body {
echo                 font-family: "Yu Gothic UI", "メイリオ", sans-serif;
echo             }
echo             table {
echo                 border-collapse: collapse;
echo                 border: 1px solid gray;
echo             }
echo             th, td {
echo                 padding: .2em 1em;
echo             }
echo         ^</style^>
echo     ^</head^>
echo     ^<body^>
echo         ^<table^ border="1"^>
echo             ^<tr^>
echo                 ^<th^>コンピュータ名^</th^>
echo                 ^<th^>IPアドレス^</th^>
echo                 ^<th^>備考^</th^>
echo             ^</tr^>
) > "%temp_file%"


for /f "tokens=1,* delims=," %%a in (%input_file%) do (
    set "computer_name=%%a"
    set "remarks=%%b"
    set "ip_address="
    
    for /f "tokens=3 delims=: " %%i in ('ping !computer_name! -4 -n 1 ^| findstr /i /c:"Reply" /c:"応答"') do (
        set "ip_address=%%i"
        set "ip_address=!ip_address::=!"
    )
    
    if "!ip_address!"=="" (
        set "ip_address=わからぬ"
    )
    
    REM echo コンピュータ名: !computer_name!
    REM echo IPアドレス: !ip_address!
    REM echo 備考: !remarks!
    REM echo.

    REM HTML
    (
    echo             ^<tr^>
    echo                 ^<td^>!computer_name!^</td^>
    echo                 ^<td^>!ip_address!^</td^>
    echo                 ^<td^>!remarks!^</td^>
    echo             ^</tr^>
    ) >> "%temp_file%"
)

REM HTML
(
echo         ^</table^>
echo     ^</body^>
echo ^</html^>
) >> "%temp_file%"

REM 反映
move /Y "%temp_file%" "%output_file%" > nul 2>&1

endlocal
