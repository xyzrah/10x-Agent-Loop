# 🚀 10x-Agent-Loop

**Break through Cursor / Windsurf quota limits and achieve true autonomous programming loops.**

[中文](readme-zh.md) | [English](readme.md)

---

Often, your Agent is forced to stop due to exhausted Fast Request quota, or gets stuck in loops due to context pollution.

**10x-Agent-Loop** brings you through file watching technology and multi-runtime support:

*   💰 **Infinite Refills**: One Fast Request, unlimited interactions—make your 500 quota feel like 5000.
*   🧠 **Consultant Mode**: When AI gets stuck, automatically generate structured consultation emails and leverage external clean environments (Gemini/Claude) to break through.
*   🛡️ **Context Cleaning**: Force structured thinking to prevent Agents from falling into local optima.

> **⚠️ Prerequisites**:
> 1. One of the following runtimes (prefer system-built-in versions, no installation required):
>    *   PowerShell (Built-in on Windows)
>    *   CMD (Built-in on Windows)
>    *   Bash (Built-in on Linux/macOS)
>    *   [Bun](https://bun.sh/) (Requires installation)
>    *   [Node.js](https://nodejs.org/) (v16+, requires installation)
>    *   [Python](https://www.python.org/) (v3.6+, requires installation)
> 2. **⚠️ Important**: Using **Composer Agent Mode** in Cursor or Windsurf (not normal chat mode). This solution only works in Agent mode because it requires AI to execute terminal commands.

---

## ⚡️ Quick Start

**Core Principle**: 1. **Script** suspends the process; 2. **Rules** tell AI to run the script.

```
┌──────┐    ┌──────────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ User │───>│Cursor Composer│───>│Rules File│───>│AI Executes│───>│Run Script│
└──────┘    │ (Agent Mode) │    │cursor-rules│    └────┬───┘    │ask-followup│
            └──────────────┘    └──────────┘           │         └─────┬────┘
                                                       │                │
                                                       │                ▼
                                                       │         ┌──────────────┐
                                                       │         │ File Watch   │
                                                       │         │NEXT_STEP.md  │
                                                       │         └──────┬───────┘
                                                       │                │
                                                       │                ▼
                                                       │         ┌──────────────┐
                                                       │         │User Input    │
                                                       │         └──────┬───────┘
                                                       │                │
                                                       └────────────────┘
                                                                  │
                                                                  ▼
                                                           ┌──────────────┐
                                                           │AI Continues  │
                                                           └──────┬───────┘
                                                                  │
                                                                  └──> (Loop continues...)
```

### 1. Deploy Files

Copy the corresponding files directly to your project. **All versions have the same functionality, choose one that fits your environment**.

| Your Environment | Copy Script (to project root) | Copy Rules (to `.cursor/rules/` or root) |
| :--- | :--- | :--- |
| **Windows** (Recommended, built-in) | `files/pwsh/ask-followup.ps1` | `files/pwsh/cursor-rules.mdc` |
| **Mac / Linux** (Built-in) | `files/shell/ask-followup.sh` | `files/shell/cursor-rules.mdc` |
| **Node.js** | `files/node/ask-followup.js` | `files/node/cursor-rules.mdc` |
| **Python** | `files/python/ask-followup.py` | `files/python/cursor-rules.mdc` |
| **Bun** | `files/bun/ask-followup.ts` | `files/bun/cursor-rules.mdc` |

> ⚠️ **Important**: **Copy the file itself directly**. Manually creating and pasting may cause **encoding format (UTF-8/BOM) or line ending (CRLF/LF)** issues, preventing script execution.
>
> **Rules File Location**:
> - Recommended for newer Cursor: Copy to `.cursor/rules/` directory (ensure "Rules for AI" is enabled in Cursor settings)
> - Or root directory: Copy to project root and name it `.cursorrules`
>
> **Linux/Mac Users**: Remember to add execute permission: `chmod +x ask-followup.sh`

### 2. Start the Loop

```
┌──────────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│Open Composer │──>│Enter Req │──>│AI Executes│──>│Run Script│──>│Show Spinner│
│  (Ctrl+I)    │   └──────────┘   └──────────┘   │ask-followup│  │Spinning..│
└──────────────┘                                 └─────┬──────┘   └─────┬────┘
                                                       │                │
                                                       │                ▼
                                                       │         ┌──────────────┐
                                                       │         │Generate      │
                                                       │         │NEXT_STEP.md  │
                                                       │         └──────┬───────┘
                                                       │                │
                                                       │                ▼
                                                       │         ┌──────────────┐
                                                       │         │User Edits File│
                                                       │         │Enter Command │
                                                       │         └──────┬───────┘
                                                       │                │
                                                       │                ▼
                                                       │         ┌──────────────┐
                                                       │         │  Save File    │
                                                       │         └──────┬───────┘
                                                       │                │
                                                       │                ▼
                                                       │         ┌──────────────┐
                                                       │         │AI Detects    │
                                                       │         └──────┬───────┘
                                                       │                │
                                                       │                ▼
                                                       │         ┌──────────────┐
                                                       │         │  Continue?    │
                                                       │         └──────┬───────┘
                                                       │                │
                                                       │        ┌──────┴──────┐
                                                       │        │              │
                                                       │        ▼              ▼
                                                       │   ┌────────┐    ┌──────────┐
                                                       │   │  Yes   │    │   No     │
                                                       │   └───┬────┘    └─────┬────┘
                                                       │       │              │
                                                       │       │              ▼
                                                       │       │         ┌──────────┐
                                                       │       │         │End Loop  │
                                                       │       │         └──────────┘
                                                       │       │
                                                       │       └──> (Return to AI Executes)
```

**Steps**:
1. Open Cursor Composer (`Ctrl+I` / `Cmd+I`), **ensure you're in Agent mode**.
2. Enter your requirements, **ensure AI references the rules file** (you can manually type `@cursor-rules.mdc` to confirm).
3. After AI completes work, it will automatically run the script and display **Spinning (progress bar)**.
4. Open the generated `NEXT_STEP.md` in the root directory, enter your instruction and **save**.
5. AI automatically wakes up and continues working.

### 3. How to Stop

- **Normal End**: Type `stop` or `end` in `NEXT_STEP.md`, AI will exit the loop normally.
- **Force Terminate**: Press `Ctrl+C` in the terminal to kill the script process.

---

## 🧠 Design Philosophy (Why This Matters)

### 1. Why "Write Emails"? (Context Cleaning)

This is a counter-intuitive design. Why not just chat directly in the IDE?

**Core Philosophy: Context Cleaning**

Rather than "asking for help," it's more about **"noise reduction"**.

*   **Break Free from Agent Framework Constraints**: In IDE programming tools like Cursor, LLMs are actually fed a large number of system prompts (System Prompts), tool definitions (Tool Definitions), and role definitions (Role Definitions). This noise (some of which may bring unnecessary constraints) causes AI to lose its original rich and powerful capabilities.

*   **Escape Context Pollution**: In long conversations, Cursor's Session accumulates a large amount of trial-and-error history, code snippets, and error logs. This noise forms thinking inertia, causing AI to fall into local optima.

*   **Force Structured Summarization**: The email format requires AI to structure **goals, current state, error logs, and configuration files**. This process itself is a form of "Rubber Duck Debugging."

*   **Fresh Perspective**: Feed this email containing complete information to a **completely clean external environment**. External models don't have Cursor's historical baggage, nor do they have complex Agent tool interference. They only see the "facts (Context Dump)" you provide.

**Best Practice**: Copy the generated email content directly to **Gemini 3 Pro**, **Claude 4.5**, **DeepSeek V3.2**, **Qwen Max**. Get advice based on pure logic, then paste it back into `NEXT_STEP.md` for Cursor to execute the fix.

### 2. Breaking Terminal Blocking (The Stdin Block)

**Problem**: Cursor's integrated terminal often intercepts or disables standard input (stdin), preventing interactive scripts from receiving user commands.

**Solution**: Abandon unstable stdin and switch to **File Watching**. The script generates a `NEXT_STEP.md` file, and users only need to modify and save this file for the script to capture commands.

**Technical Innovation**: Compared to the old Python `input()` approach, this solution uses **file watching**, perfectly bypassing Cursor's terminal keyboard input (stdin) blocking restrictions, making it extremely stable.

### 3. Preventing Process Timeout (The Timeout Kill)

**Problem**: IDEs will forcefully kill processes with no output for extended periods, causing loop interruption.

**Solution**: The script has a built-in **Anti-Timeout Spinner (heartbeat keep-alive)**, continuously printing a dynamic progress bar in the terminal to trick the IDE into thinking the process is active, thus achieving "infinite suspension."

---

## 🔥 Core Capabilities Explained

### 1. Infinite Refills (The Infinite Loop)

**Pain Point**: Cursor's 500 Fast Request quota per month runs out quickly.

**Principle Comparison**:

```
┌─────────────────────────────────────────────────────────────┐
│                  Traditional Mode                            │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  User Input ──> AI Reply ──> End Chat ──> ❌ Consume 1 Request│
│                                                               │
│  (Each conversation consumes 1 Request)                     │
│                                                               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    10x Mode                                  │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  User Input ──> AI Executes ──> Run Script Suspend          │
│                                                               │
│       ▲                                    │                 │
│       │                                    ▼                 │
│       │                             User Modifies File      │
│       │                                    │                 │
│       │                                    ▼                 │
│       └────────── AI Continues ◄────────────┘               │
│                                                               │
│  ✅ Consume 1 Request (no matter how many loops)             │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

**Core Advantage**:
- **Traditional Mode**: Each conversation = **Consume 1 Fast Request**
- **10x Mode**: No matter how many times this loops (as long as the Session isn't closed), typically **consumes only 1 Fast Request** (mainly consuming Tokens, not Request count)

**Technical Implementation**: Use file watching instead of unstable terminal input, and leverage dynamic progress bars to prevent IDEs from killing processes due to timeout.

### 2. Consultant Mode (The Consultant)

**Pain Point**: AI repeatedly tries the same bug, falls into local optima, wasting context window.

**Workflow**:

```
┌──────────────┐   ┌──────────┐   ┌──────────┐   ┌──────────────┐   ┌──────────────┐
│AI Hits Error │──>│In Loop?  │──>│  Yes    │──>│Trigger       │──>│Generate Email│
└──────────────┘   └─────┬────┘   └──────────┘   │Consultant    │   │(Goal/Error/  │
                         │                      └──────────────┘   │ Code/Context)│
                         │                                         └──────┬───────┘
                         │                                                │
                         │                                                ▼
                         │                                         ┌──────────────┐
                         │                                         │User Copies   │
                         │                                         │Email Content │
                         │                                         └──────┬───────┘
                         │                                                │
                         │                                                ▼
                         │                                         ┌──────────────┐
                         │                                         │Send to Ext    │
                         │                                         │Gemini/Claude  │
                         │                                         └──────┬───────┘
                         │                                                │
                         │                                                ▼
                         │                                         ┌──────────────┐
                         │                                         │External Model│
                         │                                         │Analyzes      │
                         │                                         │(Clean Advice)│
                         │                                         └──────┬───────┘
                         │                                                │
                         │                                                ▼
                         │                                         ┌──────────────┐
                         │                                         │Paste to      │
                         │                                         │NEXT_STEP.md  │
                         │                                         └──────┬───────┘
                         │                                                │
                         │                                                ▼
                         │                                         ┌──────────────┐
                         │                                         │Cursor Reads  │
                         │                                         └──────┬───────┘
                         │                                                │
                         │                                                ▼
                         │                                         ┌──────────────┐
                         │                                         │Break Pattern │
                         │                                         └──────┬───────┘
                         │                                                │
                         │                                                ▼
                         │                                         ┌──────────────┐
                         │                                         │Fix in One Go │
                         │                                         └──────┬───────┘
                         │                                                │
                         │                                                ▼
                         │                                         ┌──────────────┐
                         │                                         │✅ Problem    │
                         │                                         │   Solved     │
                         │                                         └──────────────┘
                         │
                         └──> [No] ──> ┌──────────────┐
                                       │Continue Normal│
                                       └──────────────┘
```

**Detailed Steps**:

1.  **Trigger**: When AI encounters persistent errors or cannot make decisions.

2.  **Draft**: AI automatically generates a **structured consultation email** in the dialog (containing logs, code, context) according to rules.

3.  **Seek Help**: You copy this "email" and send it to external clean environments: **Gemini 3 Pro**, **Claude 4.5**, **DeepSeek V3.2**, **Qwen Max**. These external models don't have Cursor's historical baggage or complex Agent tool interference—they only see the clean facts you provide.

4.  **Fill Back**: Paste the external model's suggestions back into `NEXT_STEP.md`.

5.  **Resolve**: Cursor reads external suggestions, breaks thinking patterns, and fixes the problem in one go.

---

---

## ❓ FAQ

**Q: Why these runtimes?**

A: This project supports multiple runtimes. **All versions have the same functionality**. We recommend using system-built-in versions (PowerShell/CMD/Shell) first, as they require no installation. If you already have Bun, Node.js, or Python installed, you can use those versions as well.

**Q: Will long suspension disconnect?**

A: Yes. If suspended for too long (usually 2-5 minutes, depending on IDE settings), the cloud connection may disconnect. It's recommended to complete the `NEXT_STEP.md` response within 2-5 minutes.

**Q: Does this solution consume Tokens?**

A: **Yes**. While it saves Request count, long conversations accumulate a large number of Tokens. Please monitor your Token usage and start a new Session when appropriate.

**Q: What if the rules file doesn't work?**

A: If the rules don't take effect, you can:
1. Manually add the rules file content to the conversation context
2. Directly reference the rules file in the conversation (e.g., `@cursor-rules.mdc`)
3. Confirm "Rules for AI" is enabled in Cursor settings
4. Check if the rules file is in the correct location (`.cursor/rules/` or root directory as `.cursorrules`)

---

## 🔧 Troubleshooting

### Script Error "Permission denied"

**Problem**: Script fails with permission error on Linux/macOS.

**Solution**:
```bash
chmod +x ask-followup.sh  # or ask-followup.py
```

### AI Doesn't Run Script, Just Replies

**Problem**: AI completes task but doesn't run the script, just replies directly.

**Solution**:
1. Check if rules file is read correctly: Type `@cursor-rules.mdc` in the conversation to confirm
2. Manually prompt AI: `Please run the ask-followup.* script`
3. Confirm you're using **Composer Agent Mode**, not normal chat mode

### Chinese Characters Garbled on Windows

**Problem**: Chinese characters display as garbled text in Windows.

**Solution**:
- PowerShell: Ensure script file encoding is UTF-8 (no BOM)
- CMD: May need to set code page: `chcp 65001`

### Rules File Not Recognized

**Problem**: Cursor doesn't read the rules file.

**Solution**:
1. Confirm file location: `.cursor/rules/cursor-rules.mdc` or root directory `.cursorrules`
2. Check file format: Ensure it's `.mdc` or `.cursorrules` extension
3. Restart Cursor to apply rules
4. Confirm "Rules for AI" is enabled in Cursor settings

---

## 💝 Support

If you find this tool helpful, you can support me by:

*   Buying me a coffee at [Ko-fi](https://ko-fi.com/helloxlxz)

## 🤝 Contributing

If you need other runtime versions or have more suggestions, please feel free to open an Issue or submit a Pull Request!

---

## 📄 License

MIT

