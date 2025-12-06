# 📧 咨询请求：改进 README 文档质量

## 🎯 目标
改进 `readme-zh.md` 文档的质量。用户反馈"写得不好"，但未提供具体问题点。需要外部专家（如 Gemini 3 Pro）基于完整上下文，提供客观的改进建议和具体修改方案。

## 📁 项目结构
```
10x-Agent-Loop/
├── ask-followup.ts                    # 根目录下的脚本（可能是旧版本）
├── readme-zh.md                       # 需要改进的 README 文档
└── files/
    └── bun/
        ├── ask-followup.ts            # 实际使用的脚本文件
        └── cursor-rules.mdc           # Cursor 规则配置文件
```

## 📄 当前 README 完整内容

文件路径：`readme-zh.md` (199 行)

```markdown
# 🚀 10x-Agent-Loop

**10x-Agent-Loop** 是一套专为 **Cursor IDE** 和 **Windsurf** 设计的高级规则配置。它利用 **Bun** 和 **文件监听技术**，帮助你在 Agent 模式下突破 Request 配额限制，并在遇到技术瓶颈时提供一套"降维打击"的解决方案。

> **⚠️ 注意**：本方案仅适用于 **Agent 模式** (Agent Mode)。需要安装 Bun 运行时。

---

## 🔥 核心能力一：无限续杯 (The Infinite Loop)

### ✅ 它做什么
让 AI 在完成任务后不立即结束对话，而是挂起等待你的下一步指令。

1.  AI 完成代码编写。
2.  自动运行 `bun run ask-followup.ts`。
3.  **终端进入"心跳保活"状态**（显示进度条，防止 IDE 杀进程）。
4.  此时项目根目录会出现一个 `NEXT_STEP.md` 文件。
5.  你在文件中输入反馈（如 `"把颜色改成红色"`）并 **保存 (Ctrl+S)**。
6.  AI 捕捉到文件变化，读取指令，继续干活。

### 💡 为什么这很重要
大多数 AI 编程工具（如 Cursor）每月只有 **500 次快速请求 (Fast Requests)**，但每个 Request 允许包含 **数十次工具调用 (Tool Calls)**。
*   **传统模式**：你说 "Hi" → AI 回复 "Hi" = **消耗 1 个 Request**。
*   **10x 模式**：你说 "Hi" → AI 干活 → 挂起 → 你说 "改个字" → AI 干活 → 挂起... (循环 20 次) = **依然只消耗 1 个 Request**。

### ⚡️ 核心技术突破

#### 1. 突破终端输入封锁 (The Stdin Block)
*   **问题**：Cursor 的集成终端经常拦截或禁用标准输入（stdin），导致交互脚本无法接收用户指令。
*   **解决方案**：放弃不稳定 stdin，改用 **文件监听 (File Watcher)**。脚本会生成一个 `NEXT_STEP.md` 文件，用户只需修改并保存该文件，脚本即可捕捉指令。

#### 2. 防止进程假死 (The Timeout Kill)
*   **问题**：IDE 会强制杀死长时间无输出的进程，导致循环中断。
*   **解决方案**：脚本内置 **Anti-Timeout Spinner (心跳保活)**，在终端持续打印动态进度条，欺骗 IDE 认为进程处于活跃状态，从而实现"无限挂起"。

> **技术革新**：相比旧版 Python `input()` 方案，本方案使用**文件监听**，完美绕过了 Cursor 终端拦截键盘输入 (stdin) 的限制，极其稳定。

---

## 🧠 核心能力二：咨询师模式 (The Consultant)

### ✅ 它做什么
当 AI 在同一个 Bug 上反复报错，或者你不知道下一步该用什么技术栈时，AI 会自动切换身份。

1.  **触发**：AI 遇到难以解决的错误或技术决策点。
2.  **起草**：AI 不再瞎猜，而是生成一封**结构化的咨询邮件**（Markdown 格式，包含完整的错误日志、代码片段、配置文件）。
3.  **外援**：你复制这封邮件，发送给更强大的逻辑模型（如 **Gemini 3 Pro**, **Claude 4.5 Sonnet**, 或 **DeepSeek V3.2**）。
4.  **解决**：将外部模型的建议贴回 `NEXT_STEP.md`，Cursor 读取后一次性修复问题。

### 💡 为什么要写邮件？
这不是为了发给人类，而是为了 **上下文清洗 (Context Cleaning)**。

当 Agent 在某个 Bug 上反复横跳时，继续强制它在当前的 Session 中修复通常是徒劳的。我们需要**Consultant Mode (咨询师模式)**。

#### 核心哲学：上下文清洗 (Context Cleaning)
与其说是为了"求助"，不如说是为了**"降噪"**。

1. **摆脱agent框架束缚**：类似Cursor的 IDE 编程工具中，LLM 实际还会被传入大量的系统提示词（System Prompts）、工具定义（Tool Definitions）、角色定义（Role Definitions）。这些噪音（有的甚至会带来不必要的约束）会使得 AI 失去了原本丰富而强大的能力。
2.  **摆脱"脏"上下文**：在长对话中，Cursor 的 Session 积累了大量的试错历史、代码片段、错误日志。这些噪音会形成思维惯性，导致 AI 陷入局部最优解。
2.  **强制结构化总结**：邮件的格式要求 AI 必须将**目标、现状、报错日志、配置文件**进行结构化梳理。这个过程本身就是一种"橡皮鸭调试法（Rubber Ducking）"。
3.  **旁观者清**：将这封包含完整信息的邮件，投喂给一个**完全干净的外部环境**。

#### 🎯 最佳实践：Gemini 3 Pro + 干净环境
我们推荐将生成的邮件内容复制给 **Gemini 3 Pro**（或 Claude 4.5 Sonnet 等具备长窗口能力的 SOTA 模型）。

*   **为什么是它们？** 外部模型没有 Cursor 的历史包袱，也没有复杂的 Agent 工具干扰。它们看到的只有你提供的"事实（Context Dump）"。
*   **流程**：
    1.  Cursor 卡住 -> 触发生成"咨询邮件"。
    2.  你复制邮件 -> 发送给 **Gemini 3 Pro**。
    3.  获得一个基于纯粹逻辑的建议 -> 粘贴回 `NEXT_STEP.md`。
    4.  Cursor 执行修复。

---

## ⚙️ 如何设置 (2步完成)

### 1. 复制脚本 `ask-followup.ts`
在项目根目录创建此文件。它负责文件监听和防止超时。

```typescript
import { write, file } from "bun";

const WATCH_FILE = "NEXT_STEP.md";
const promptMsg = process.argv[2] || "Waiting for instructions...";

// 初始化交互文件
const initialContent = `<!-- 
🤖 AI REQUEST: ${promptMsg}
👉 INSTRUCTION: Type your response below this comment and SAVE the file (Cmd+S / Ctrl+S).
-->

`;

try { await write(WATCH_FILE, initialContent); } catch (e) { process.exit(1); }

console.log(`\n🤖 \x1b[36mWaiting for input in file: ${WATCH_FILE} ...\x1b[0m`);

// 启动心跳保活 + 文件监听
const spinnerFrames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];
let i = 0;

const checkInterval = setInterval(async () => {
  const frame = spinnerFrames[i++ % spinnerFrames.length];
  // 持续输出防止超时 (Anti-Timeout)
  process.stdout.write(`\r\x1b[33m${frame} Watching ${WATCH_FILE} for changes... (${Math.floor(i / 2)}s)\x1b[0m`);

  try {
    const content = await file(WATCH_FILE).text();
    // 检测文件内容变化
    if (content.trim() !== initialContent.trim() && content.length > 10) {
      const cleanInput = content.replace(/<!--[\s\S]*?-->/g, "").trim();
      if (cleanInput.length > 0) {
        clearInterval(checkInterval);
        process.stdout.write(`\r\x1b[K`); 
        console.log(`✅ USER_INPUT_RECEIVED: "${cleanInput}"`);
        process.exit(0);
      }
    }
  } catch (err) {}
}, 500);

process.on("SIGINT", () => { process.exit(0); });
```

### 2. 复制规则 `.cursorrules`
将以下内容复制到你的 `.cursorrules` 文件中。

```markdown
---
description: Interactive Loop via File Watcher + Consultant Mode
globs: 
alwaysApply: true
---

### 🧠 Core Philosophy: 10x-Agent-Loop

You are operating in a constrained environment. **Never stop the session voluntarily.** You must always loop back to the user instructions using the file-watcher script.

### 🔄 The Interactive Loop (File-Based)

1.  **Execute Task**: Perform coding tasks.
2.  **Ask for Next Step**: 
    *   Run: `bun run ask-followup.ts "Brief summary. What next?"`
    *   This script will create/reset a file named `NEXT_STEP.md`.
3.  **Wait**: 
    *   The script will hang and show a spinner. **Do not interrupt it.**
    *   Wait for the user to edit and save `NEXT_STEP.md`.
    *   The script will eventually exit and output `✅ USER_INPUT_RECEIVED: "..."`.
4.  **Continue**: Read that output and execute the next step immediately in the **same** session.
5.  **Stop**: Only exit if the input is "stop".

---

### 📧 Mode: Professional Consultant (Troubleshooting)

**Trigger**: Persistent errors, technical blockers, or lack of domain knowledge.

**CRITICAL Action Order**:
1.  **Step 1: Draft Email**: In the chat window, generate a consultation email.
    *   **MUST** wrap the email in **Quadruple Backticks (` ```` `)** or **Three Tildes (`~~~`)** to avoid code block conflicts.
2.  **Step 2: Suspend**: Immediately run:
    ```bash
    bun run ask-followup.ts "Email drafted above. Copy it, consult an external expert (e.g., Gemini 1.5 Pro), then write the solution in NEXT_STEP.md"
    ```

**Drafting Guidelines**:
*   **Context Dump**: Inline **ALL** relevant context (File paths, Code snippets, Error logs).
*   **No Presumptions**: Describe the goal and the blocker objectively. Do not guess solutions.
```

---

## 🧪 当前状态与局限性

*   ✅ **支持**：通过 Markdown 文件进行文本交互。
*   ✅ **支持**：粘贴外部模型的代码块。
*   ⚠️ **网络限制**：如果挂起时间过长（例如数小时），IDE 的云端连接可能会超时断开。建议在 10-20 分钟内完成外部咨询。
*   ⚠️ **Token 消耗**：虽然不消耗 Request 次数，但单次对话过长可能会触达 Context Window 上限。

---

## 🧠 真实场景示例

假设你有 **500 次月度配额**：

*   **普通用户**：
    `你说 "写个登录页" → AI 写代码 → 结束 (消耗 1 次)`
    `你说 "加个找回密码" → AI 写代码 → 结束 (消耗 1 次)`
    ...改了10次 = **消耗 10 次 Request**

*   **10x-Agent-Loop 用户**：
    `你说 "写个登录页" → AI 写代码 → 自动挂起(转圈圈) → 你在文件里写 "加个找回密码" 并保存 → AI 继续...`
    ...改了10次 = **依然只消耗 1 次 Request**

---

少用配额，多做实事。

**→ 这就是 10x-Agent-Loop 的力量。**
```

## 📄 相关文件内容

### 文件 1: `files/bun/ask-followup.ts` (实际使用的脚本)

```typescript
import { write, file } from "bun";

const WATCH_FILE = "NEXT_STEP.md";
const promptMsg = process.argv[2] || "Waiting for instructions...";

// 1. 初始化通信文件
// 使用 HTML 注释包裹系统提示，方便用户直接在下面打字，也方便脚本清洗
const initialContent = `<!-- 
🤖 AI REQUEST: ${promptMsg}
👉 INSTRUCTION: Type your response below this comment and SAVE the file (Cmd+S / Ctrl+S).
-->

`;

try {
  await write(WATCH_FILE, initialContent);
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
    const f = file(WATCH_FILE);
    const content = await f.text();

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
        // await unlink(WATCH_FILE); 
        
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
```

### 文件 2: `files/bun/cursor-rules.mdc` (Cursor 规则配置)

```markdown
---
description: Interactive Loop + Professional Consultant Mode
globs: 
alwaysApply: true
---

### 🧠 Core Philosophy: 10x-Tool-Calls

You are operating in a constrained environment. **Never stop the session voluntarily.** You must always loop back to the user for the next instruction using the provided script, maximizing the tool-call quota within a single request.

### 🔄 The Interactive Loop

1.  **Execute Task**: Perform your assigned coding tasks, file operations, or terminal commands.
2.  **Ask for Next Step**: 
    *   Once a sub-task is done, **run this command immediately**:
        ```bash
        bun run ask-followup.ts "Brief summary of what you did. What next?"
        ```
3.  **Wait & Read**: The script will hang until the user inputs text. Read the output (e.g., `USER_INPUT: ...`).
4.  **Continue**: Treat the script output as your next prompt and execute it immediately in the **same** session.
5.  **Stop**: Only exit the loop if the user explicitly inputs "stop".

---

### 📧 Mode: Professional Consultant (Troubleshooting)

**Trigger**: When you encounter a persistent error, a technical blocker, or lack specific domain knowledge.

**CRITICAL Action Order**:
1.  **Step 1: Draft Email**: In the chat window (NOT a file), generate a consultation email using a Markdown code block.
2.  **Step 2: Suspend**: Immediately after showing the email, run:
    ```bash
    bun run ask-followup.ts "Email drafted above. Please copy it or provide instructions."
    ```

**Drafting Guidelines (No Fixed Template)**:
You are a **Professional Questioner** asking a domain expert.
*   **Context Dump**: Since attachments are not an option, you must inline **ALL** relevant context: File structure, specific code snippets, and full error logs.
*   **No Presumptions**: Do NOT suggest solutions that might be wrong. Do NOT ask binary questions based on guesses (e.g., "Is it A or B?"). 
*   **Goal-Oriented**: Clearly state: "This is what we are trying to achieve," followed by "This is the specific blocker."
*   **Markdown Escaping**: Since the email body will contain code snippets using triple backticks (` ``` `), you **MUST** wrap the entire email container using **Quadruple Backticks (` ```` `)** or **Three Tildes (`~~~`)** to avoid formatting conflicts.

---

### ⚠️ Important Rules
*   Always check the output of `ask-followup.ts` to decide the next move.
```

## 🔍 观察到的潜在问题

1. **文件路径不一致**：
   - README 中提到的脚本路径是 `ask-followup.ts`（根目录）
   - 实际脚本在 `files/bun/ask-followup.ts`
   - README 中的代码示例与 `files/bun/ask-followup.ts` 不完全一致（缺少 `const frame =` 变量声明）

2. **规则文件不一致**：
   - README 中提到的规则文件是 `.cursorrules`
   - 实际规则文件是 `files/bun/cursor-rules.mdc`
   - README 中的规则内容与 `cursor-rules.mdc` 不完全一致（例如 "10x-Agent-Loop" vs "10x-Tool-Calls"）

3. **文档结构问题**：
   - 第 60 行有重复的编号（两个 "2."）
   - 代码示例中的 `ask-followup.ts` 缺少 `const frame =` 声明，但实际文件中有

4. **用户体验问题**：
   - 设置步骤中未明确说明脚本应放在哪个目录
   - 未说明是否需要创建 `.cursorrules` 还是使用 `cursor-rules.mdc`

## ❓ 需要专家回答的问题

1. **文档结构**：当前 README 的组织结构是否合理？是否需要调整章节顺序或合并/拆分某些部分？

2. **内容准确性**：代码示例和文件路径是否需要与实际文件保持一致？如何平衡"简化示例"和"完全准确"？

3. **可读性**：对于中文技术文档，当前的写作风格、术语使用、格式是否合适？是否需要改进？

4. **完整性**：是否缺少关键信息（如安装步骤、故障排除、常见问题等）？

5. **目标受众**：文档是否清晰地向目标用户（Cursor/Windsurf 用户）传达了核心价值和使用方法？

6. **最佳实践**：基于技术文档写作的最佳实践，有哪些具体的改进建议？

## 🎯 期望输出

请提供：
1. **具体的问题诊断**：指出 README 中存在的具体问题（结构、内容、格式、准确性等）
2. **改进建议**：针对每个问题提供具体的修改建议
3. **优化后的文档结构**：如果建议重构，请提供新的章节组织方案
4. **代码示例修正**：如果需要，提供修正后的代码示例

请基于客观分析，不要猜测用户的具体不满点，而是从技术文档写作的专业角度进行全面评估。