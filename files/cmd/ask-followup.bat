@echo off
setlocal enabledelayedexpansion

set "WATCH_FILE=NEXT_STEP.md"
set "PROMPT_MSG=%~1"
if "!PROMPT_MSG!"=="" set "PROMPT_MSG=Waiting for instructions..."

REM 1. 初始化通信文件
REM 使用 HTML 注释包裹系统提示，方便用户直接在下面打字，也方便脚本清洗
(
echo ^<!-- 
echo 🤖 AI REQUEST: !PROMPT_MSG!
echo 👉 INSTRUCTION: Type your response below this comment and SAVE the file ^(Cmd+S / Ctrl+S^).
echo --^>
echo.
) > "!WATCH_FILE!"

if errorlevel 1 (
    echo Error creating !WATCH_FILE!
    exit /b 1
)

echo.
echo 🤖 Waiting for input in file: !WATCH_FILE! ...

REM 2. 启动"心跳" + "文件轮询"
set "i=0"
set "spinner[0]=⠋"
set "spinner[1]=⠙"
set "spinner[2]=⠹"
set "spinner[3]=⠸"
set "spinner[4]=⠼"
set "spinner[5]=⠴"
set "spinner[6]=⠦"
set "spinner[7]=⠧"
set "spinner[8]=⠇"
set "spinner[9]=⠏"

:loop
REM --- A. 进度条 (Anti-Timeout) ---
set /a "spinner_idx=!i! %% 10"
set /a "time=!i! / 2"
set "frame=!spinner[!spinner_idx!]!"
<nul set /p "=!frame! Watching !WATCH_FILE! for changes... (!time!s)"

REM --- B. 检查文件内容 ---
if exist "!WATCH_FILE!" (
    for /f "delims=" %%a in ('type "!WATCH_FILE!"') do set "line=%%a"
    REM 简单的去抖动逻辑：检查文件是否被修改
    REM 注意：CMD 批处理脚本功能有限，这里使用简化版本
    for %%F in ("!WATCH_FILE!") do set "file_size=%%~zF"
    if !file_size! gtr 10 (
        REM 读取文件并提取用户输入（去除 HTML 注释）
        powershell -Command "$content = Get-Content '!WATCH_FILE!' -Raw; $clean = $content -replace '(?s)<!--.*?-->', ''; $clean = $clean.Trim(); if ($clean.Length -gt 0) { Write-Host \"✅ USER_INPUT_RECEIVED: `\"$clean`\"\"; exit 0 }"
        if !errorlevel! equ 0 exit /b 0
    )
)

set /a "i+=1"
timeout /t 1 /nobreak >nul 2>&1
goto loop

