#!/bin/bash

WATCH_FILE="NEXT_STEP.md"
PROMPT_MSG="${1:-Waiting for instructions...}"

# 1. 初始化通信文件
# 使用 HTML 注释包裹系统提示，方便用户直接在下面打字，也方便脚本清洗
INITIAL_CONTENT="<!-- 
🤖 AI REQUEST: $PROMPT_MSG
👉 INSTRUCTION: Type your response below this comment and SAVE the file (Cmd+S / Ctrl+S).
-->

"

if ! echo "$INITIAL_CONTENT" > "$WATCH_FILE" 2>/dev/null; then
    echo "Error creating $WATCH_FILE" >&2
    exit 1
fi

echo -e "\n🤖 \033[36mWaiting for input in file: $WATCH_FILE ...\033[0m"

# 2. 启动"心跳" + "文件轮询"
# 结合了防超时动画和文件读取
SPINNER_FRAMES=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
i=0

# 处理 Ctrl+C
trap 'echo -e "\r\033[K\n🛑 Stopped manually.\n"; exit 0' INT

while true; do
    # --- A. 进度条 (Anti-Timeout) ---
    frame="${SPINNER_FRAMES[$((i % ${#SPINNER_FRAMES[@]}))]}"
    time=$((i / 2))
    printf "\r\033[33m%s Watching %s for changes... (%ds)\033[0m" "$frame" "$WATCH_FILE" "$time"
    
    # --- B. 检查文件内容 ---
    if [ -f "$WATCH_FILE" ]; then
        content=$(cat "$WATCH_FILE" 2>/dev/null)
        
        # 简单的去抖动逻辑：内容必须与初始内容不同，且长度增加（说明用户打字了）
        # 同时也排除了用户只删除了注释的情况
        if [ "$(echo "$content" | tr -d '[:space:]')" != "$(echo "$INITIAL_CONTENT" | tr -d '[:space:]')" ] && [ ${#content} -gt 10 ]; then
            # 清洗内容：去掉上面的注释，只保留用户输入
            clean_input=$(echo "$content" | sed 's/<!--[^>]*-->//g' | sed '/^[[:space:]]*$/d' | xargs)
            
            # 如果用户真的输入了有效内容
            if [ -n "$clean_input" ]; then
                printf "\r\033[K"
                echo "✅ USER_INPUT_RECEIVED: \"$clean_input\""
                exit 0
            fi
        fi
    fi
    
    sleep 0.5  # 500ms 轮询一次，对系统资源几乎无影响
    i=$((i + 1))
done

