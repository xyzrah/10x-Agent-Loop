#!/usr/bin/env python3
import sys
import os
import time
import signal

WATCH_FILE = "NEXT_STEP.md"
prompt_msg = sys.argv[1] if len(sys.argv) > 1 else "Waiting for instructions..."

# 1. 初始化通信文件
# 使用 HTML 注释包裹系统提示，方便用户直接在下面打字，也方便脚本清洗
initial_content = f"""<!-- 
🤖 AI REQUEST: {prompt_msg}
👉 INSTRUCTION: Type your response below this comment and SAVE the file (Cmd+S / Ctrl+S).
-->

"""

try:
    with open(WATCH_FILE, 'w', encoding='utf-8') as f:
        f.write(initial_content)
except Exception as e:
    print(f"Error creating {WATCH_FILE}: {e}", file=sys.stderr)
    sys.exit(1)

print(f"\n🤖 \033[36mWaiting for input in file: {WATCH_FILE} ...\033[0m")

# 2. 启动"心跳" + "文件轮询"
# 结合了防超时动画和文件读取
spinner_frames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
i = 0

def signal_handler(sig, frame):
    print("\r\033[K\n🛑 Stopped manually.\n", end="")
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

while True:
    # --- A. 进度条 (Anti-Timeout) ---
    frame = spinner_frames[i % len(spinner_frames)]
    i += 1
    time_elapsed = i // 2
    print(f"\r\033[33m{frame} Watching {WATCH_FILE} for changes... ({time_elapsed}s)\033[0m", end="", flush=True)
    
    # --- B. 检查文件内容 ---
    try:
        if os.path.exists(WATCH_FILE):
            with open(WATCH_FILE, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # 简单的去抖动逻辑：内容必须与初始内容不同，且长度增加（说明用户打字了）
            # 同时也排除了用户只删除了注释的情况
            if content.strip() != initial_content.strip() and len(content) > 10:
                # 清洗内容：去掉上面的注释，只保留用户输入
                import re
                clean_input = re.sub(r'<!--[\s\S]*?-->', '', content).strip()
                
                # 如果用户真的输入了有效内容
                if len(clean_input) > 0:
                    print(f"\r\033[K", end="")
                    print(f'✅ USER_INPUT_RECEIVED: "{clean_input}"')
                    sys.exit(0)
    except Exception:
        # 忽略读取错误（比如文件正在写入时被锁定）
        pass
    
    time.sleep(0.5)  # 500ms 轮询一次，对系统资源几乎无影响

