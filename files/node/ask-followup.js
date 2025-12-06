const fs = require('fs').promises;
const path = require('path');

const WATCH_FILE = "NEXT_STEP.md";
const promptMsg = process.argv[2] || "Waiting for instructions...";

// 1. 初始化通信文件
// 使用 HTML 注释包裹系统提示，方便用户直接在下面打字，也方便脚本清洗
const initialContent = `<!-- 
🤖 AI REQUEST: ${promptMsg}
👉 INSTRUCTION: Type your response below this comment and SAVE the file (Cmd+S / Ctrl+S).
-->

`;

(async () => {
  try {
    await fs.writeFile(WATCH_FILE, initialContent, 'utf8');
  } catch (e) {
    console.error(`Error creating ${WATCH_FILE}:`, e);
    process.exit(1);
  }

  console.log(`\n🤖 \x1b[36mWaiting for input in file: ${WATCH_FILE} ...\x1b[0m`);

  // 2. 启动"心跳" + "文件轮询"
  // 结合了防超时动画和文件读取
  const spinnerFrames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];
  let i = 0;

  const checkInterval = setInterval(async () => {
    // --- A. 进度条 (Anti-Timeout) ---
    const frame = spinnerFrames[i++ % spinnerFrames.length];
    const time = Math.floor(i / 2); 
    process.stdout.write(`\r\x1b[33m${frame} Watching ${WATCH_FILE} for changes... (${time}s)\x1b[0m`);

    // --- B. 检查文件内容 ---
    try {
      const content = await fs.readFile(WATCH_FILE, 'utf8');

      // 简单的去抖动逻辑：内容必须与初始内容不同，且长度增加（说明用户打字了）
      // 同时也排除了用户只删除了注释的情况
      if (content.trim() !== initialContent.trim() && content.length > 10) {
        
        // 清洗内容：去掉上面的注释，只保留用户输入
        const cleanInput = content.replace(/<!--[\s\S]*?-->/g, "").trim();

        // 如果用户真的输入了有效内容
        if (cleanInput.length > 0) {
          clearInterval(checkInterval);
          
          // 清除进度条行
          process.stdout.write(`\r\x1b[K`); 
          
          console.log(`✅ USER_INPUT_RECEIVED: "${cleanInput}"`);
          
          // 可选：重置文件或删除文件，这里保留文件作为历史记录比较好
          // await fs.unlink(WATCH_FILE);
          
          process.exit(0);
        }
      }
    } catch (err) {
      // 忽略读取错误（比如文件正在写入时被锁定）
    }

  }, 500); // 500ms 轮询一次，对系统资源几乎无影响

  // 3. 允许手动强杀
  process.on("SIGINT", () => {
    clearInterval(checkInterval);
    process.stdout.write(`\r\x1b[K\n🛑 Stopped manually.\n`);
    process.exit(0);
  });
})();

