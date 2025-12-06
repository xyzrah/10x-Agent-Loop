param(
    [string]$PromptMsg = "Waiting for instructions..."
)

$WATCH_FILE = "NEXT_STEP.md"

# 1. 初始化通信文件
# 使用 HTML 注释包裹系统提示，方便用户直接在下面打字，也方便脚本清洗
$initialContent = @"
<!-- 
🤖 AI REQUEST: $PromptMsg
👉 INSTRUCTION: Type your response below this comment and SAVE the file (Cmd+S / Ctrl+S).
-->

"@

try {
    Set-Content -Path $WATCH_FILE -Value $initialContent -Encoding UTF8
} catch {
    Write-Host "Error creating $WATCH_FILE : $_" -ForegroundColor Red
    exit 1
}

Write-Host "`n🤖 Waiting for input in file: $WATCH_FILE ..." -ForegroundColor Cyan

# 2. 启动"心跳" + "文件轮询"
# 结合了防超时动画和文件读取
$spinnerFrames = @("⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏")
$i = 0

# 处理 Ctrl+C
$null = Register-EngineEvent PowerShell.Exiting -Action {
    Write-Host "`r`n🛑 Stopped manually.`n"
    exit 0
}

while ($true) {
    # --- A. 进度条 (Anti-Timeout) ---
    $frame = $spinnerFrames[$i % $spinnerFrames.Length]
    $i++
    $time = [math]::Floor($i / 2)
    Write-Host "`r$frame Watching $WATCH_FILE for changes... ($time`s)" -NoNewline -ForegroundColor Yellow
    
    # --- B. 检查文件内容 ---
    try {
        if (Test-Path $WATCH_FILE) {
            $content = Get-Content -Path $WATCH_FILE -Raw -Encoding UTF8
            
            # 简单的去抖动逻辑：内容必须与初始内容不同，且长度增加（说明用户打字了）
            # 同时也排除了用户只删除了注释的情况
            if ($content.Trim() -ne $initialContent.Trim() -and $content.Length -gt 10) {
                # 清洗内容：去掉上面的注释，只保留用户输入
                $cleanInput = $content -replace '(?s)<!--.*?-->', '' | ForEach-Object { $_.Trim() }
                
                # 如果用户真的输入了有效内容
                if ($cleanInput.Length -gt 0) {
                    Write-Host "`r" -NoNewline
                    Write-Host "✅ USER_INPUT_RECEIVED: `"$cleanInput`""
                    exit 0
                }
            }
        }
    } catch {
        # 忽略读取错误（比如文件正在写入时被锁定）
    }
    
    Start-Sleep -Milliseconds 500  # 500ms 轮询一次，对系统资源几乎无影响
}

