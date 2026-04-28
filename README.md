# Claude Code Portable for Windows

**真正的便携版 Claude Code** — 所有依赖已打包，可存放在 U 盘中随处运行。

---

## ✨ 特性

- ✅ **真正便携**：Node.js + Git for Windows 全部打包，零系统依赖
- ✅ **灵活切换**：支持 portable / system / hybrid 三种运行时模式
- ✅ **开箱即用**：无需配置环境变量，不污染系统 PATH
- ✅ **一键启动**：双击 `claude.cmd` 即可启动
- ✅ **右键菜单**：支持在任意文件夹右键快速启动
- ✅ **一键更新**：运行 `update.cmd` 更新到最新版
- ✅ **配置跟随**：所有 Claude Code 配置保存在便携版目录内，U 盘拔走即带走
- ✅ **CC Switch 集成**：内置 CC Switch 便携版，一键管理 Provider、MCP、用量追踪

---

## 📁 目录结构

```
Claude-Code-Portable/
├── claude.cmd              ← 🚀 双击启动 Claude Code
├── switch-runtime.cmd      ← 🔄 切换运行时模式（portable/system/hybrid）
├── update.cmd              ← 📦 更新到最新版
├── setup-context-menu.cmd  ← 🔗 注册右键菜单
├── remove-context-menu.cmd ← ❌ 移除右键菜单
├── launcher.cmd            ← 📂 右键菜单调用的启动器（自动传入目录参数）
├── build.cmd               ← 🔧 从零构建（首次使用 / 重新打包）
├── portable.ini            ← ⚙️ 运行时模式配置（portable/system/hybrid）
├── README.md               ← 📖 本文件
├── runtime/
│   ├── node/               ← Node.js v22 运行时（~94 MB）
│   ├── npm/                ← Claude Code 及 npm 依赖（~483 MB）
│   └── git/                ← Git for Windows Portable（~391 MB）
├── config/                 ← npm 全局配置（npmrc）
├── cc-switch/              ← CC Switch 便携版（Provider/MCP/用量管理）
│   ├── CC Switch.exe       ← 双击启动 CC Switch
│   └── ...                 ← 附属文件
└── data/
    ├── home/               ← 用户主目录（.claude/ 配置存于此）
    └── npm-cache/          ← npm 缓存目录
```

**总体积**：约 1 GB（含 CC Switch）

---

## 🚀 快速开始

### 方式一：直接使用（已构建好）

1. 双击 `claude.cmd` 启动
2. 首次运行需要登录：
   ```
   claude auth login
   ```
3. 开始使用！

### 方式二：从零构建

> ⚠️ **`build.cmd` 是破坏性操作！** 运行前请务必了解以下风险：
>
> | 风险 | 说明 |
> |------|------|
> | **覆盖现有运行时** | `runtime/node/` 和 `runtime/npm/` 将被重新下载和替换，已有版本丢失 |
> | **需要联网** | 将从 nodejs.org 和 npmjs.org 下载约 110 MB 数据 |
> | **需要磁盘空间** | 至少 1.5 GB 可用空间（下载 + 解压 + 安装） |
> | **耗时** | 首次构建约 5-10 分钟，取决于网速 |
>
> **安全机制**：脚本已内置三层防护——
> 1. 🛡️ **已有安装检测**：发现已有运行时时，必须输入 `YES` 确认才会继续
> 2. 🛡️ **操作确认**：启动前需再次输入 `YES` 确认
> 3. 🛡️ **自动备份 + 回滚**：构建前自动备份现有运行时，失败时自动恢复
>
> **`data/` 目录（配置、登录凭据）永远不会被 build.cmd 触碰，始终安全。**

1. 双击 `build.cmd`
2. 阅读提示，输入 `YES` 确认
3. 等待构建完成
4. 双击 `claude.cmd` 启动

---

## 🔗 右键菜单集成

### 注册

双击 `setup-context-menu.cmd`，注册成功后：

- **文件夹空白处右键** → "Open Claude Code Here"
- **右键点击文件夹** → "Open Claude Code Here"

### 移除

双击 `remove-context-menu.cmd`，一键清除注册表项。

> 📌 注册表写在 `HKCU`（当前用户）下，不需要管理员权限。
> 📌 移动文件夹后需重新运行 `setup-context-menu.cmd`，因为注册表中存储了绝对路径。

---

## 📦 更新 Claude Code

双击 `update.cmd`，自动通过 npm 更新到最新版本。

---

## 🔄 运行时模式切换

便携版支持三种运行时模式，通过 `switch-runtime.cmd` 一键切换，或手动编辑 `portable.ini`。

### 模式对比

| 模式 | Node.js | Git | 适用场景 |
|------|---------|-----|----------|
| **portable** | ✅ 便携版 | ✅ 便携版 | 默认模式。零系统依赖，U 盘随处运行 |
| **system** | 🔗 系统安装 | 🔗 系统安装 | 机器已装好 Node.js + Git，想用系统版本 |
| **hybrid** | ✅ 便携版 | 🔗 系统安装 | 用便携版 Claude Code + 系统新版 Git |

### 切换方式

**方式一：交互式脚本（推荐）**

双击 `switch-runtime.cmd`，它会：
1. 自动检测本机已安装的 Node.js / Git 版本
2. 显示便携版 vs 系统版对比
3. 让你选择模式
4. 写入 `portable.ini`，重启 `claude.cmd` 即生效

**方式二：手动编辑**

打开 `portable.ini`，修改 `RUNTIME_MODE` 的值：
```ini
RUNTIME_MODE=portable    ; 或 system, hybrid
```

### 启动时显示

`claude.cmd` 启动时会显示当前模式及使用的运行时来源：

```
 Starting Claude Code...
 ──────────────────────────────────────────
  Mode:  portable
  Node:  ...\runtime\node\node.exe [portable]
  Git:   ...\runtime\git [portable]
  Home:  ...\data\home
 ──────────────────────────────────────────
```

> 📌 切换模式后需要**重启 `claude.cmd`** 才会生效。
> 📌 `HOME` 始终指向便携版 `data/home/`，无论哪种模式配置都跟便便携版走。

---

## 🔄 CC Switch — Provider 管理与切换

[CC Switch](https://github.com/farion1231/cc-switch) 是一个跨平台桌面工具，用于统一管理 AI 编程 CLI 的配置，已内置便携版。

### 功能亮点

| 功能 | 说明 |
|------|------|
| **Provider 管理** | 50+ 预设（含 AWS Bedrock、NVIDIA NIM 等），一键导入/切换，支持拖拽排序、导入导出 |
| **本地代理与故障转移** | 格式转换、自动故障转移、熔断器、Provider 健康监控 |
| **MCP 统一管理** | 跨 Claude Code / Codex / Gemini CLI / OpenCode 管理 MCP 服务器，双向同步 |
| **Prompts 管理** | Markdown 编辑器，跨应用同步（CLAUDE.md / AGENTS.md / GEMINI.md） |
| **Skills 管理** | 从 GitHub 仓库或 ZIP 一键安装，支持符号链接 |
| **用量与成本追踪** | 消费看板、请求日志、Token 统计、趋势图表、自定义模型定价 |
| **Session 管理** | 浏览、搜索、恢复所有应用的对话历史 |
| **云同步** | 支持 Dropbox、OneDrive、iCloud、NAS 及 WebDAV |
| **系统托盘** | 无需打开主界面即可切换 Provider，即时生效 |
| **Deep Link** | 通过 `ccswitch://` URL 导入 Provider、MCP 等 |

### 启动方式

1. 进入 `cc-switch/` 目录
2. 双击 `CC Switch.exe` 启动
3. 首次使用时选择导入现有 Claude Code 配置作为默认 Provider

### 配合 Claude Code 使用

1. 先启动 `claude.cmd`（Claude Code）
2. 再启动 `CC Switch.exe`
3. 在 CC Switch 中添加/切换 Provider → **Claude Code 无需重启终端即可生效**
4. 如需切回官方登录：添加 "Official Login" 预设 → 重启 Claude Code → 按登录流程操作

> 📌 CC Switch 的数据存储在 `data/home/.cc-switch/` 目录下（跟随 HOME 变量），U 盘拔走即带走。

### 更新 CC Switch

1. 从 [Releases 页面](https://github.com/farion1231/cc-switch/releases/latest) 下载最新的 `CC-Switch-vX.X.X-Windows-Portable.zip`
2. 解压覆盖 `cc-switch/` 目录下的文件即可

---

## 💾 在 U 盘上使用

1. 将整个 `Claude-Code-Portable` 文件夹复制到 U 盘
2. 在任意 Windows 电脑上双击 `claude.cmd` 即可运行
3. 所有配置保存在 `data/home/.claude/` 目录中，跟随 U 盘走
4. 如需右键菜单，在新电脑上运行一次 `setup-context-menu.cmd`

---

## 🔧 技术细节

### 启动原理

`claude.cmd` 启动时做了以下事情：

1. 读取 `portable.ini` 中的 `RUNTIME_MODE` 配置
2. 根据模式选择 Node.js 和 Git 来源（便携版或系统）
3. 构建 `PATH`：便携版路径优先（portable/hybrid），或仅保留系统路径（system）
4. 设置 `CLAUDE_CODE_GIT_BASH_PATH` 指向对应 Git Bash
5. 重定向 `HOME` 到 `data/home/`，配置文件跟便便携版走
6. 重定向 `NPM_CONFIG_CACHE` 到 `data/npm-cache/`
7. 验证所需运行时是否存在，缺失则报错
8. 调用 Claude Code 启动

### 核心环境变量

| 变量 | 作用 | 受模式影响 |
|------|------|------------|
| `CLAUDE_CODE_GIT_BASH_PATH` | 指向 Git Bash，portable/hybrid 模式下指向便携版，system 模式下指向系统 Git | ✅ |
| `DISABLE_INSTALLATION_CHECKS` | 设为 1，跳过安装检查 | ❌ 始终设置 |
| `HOME` | 重定向到 `data/home/`，配置跟便便携版走 | ❌ 始终设置 |
| `NPM_CONFIG_CACHE` | npm 缓存存于便携版目录内 | ✅ 仅 portable/hybrid |
| `PATH` | portable: 便携版优先；system: 仅系统路径；hybrid: 便携版 Node + 系统 Git | ✅ |

### 为什么需要 Git Bash？

Claude Code 在 Windows 上**必须**通过 Git Bash 执行 shell 命令。如果没有系统级 Git for Windows，就必须通过 `CLAUDE_CODE_GIT_BASH_PATH` 环境变量告诉它便携版 Git Bash 的位置。这是与其它第三方便携版的核心区别——它们大多没解决这个问题。

---

## ⚠️ 已知限制

- **Windows 平台专用**（不支持 macOS / Linux）
- **首次使用需联网**登录 Anthropic 账号
- **体积较大**（约 1 GB），因为包含了完整的 Git for Windows Portable 和 CC Switch
- **移动文件夹后**需重新运行 `setup-context-menu.cmd` 更新注册表路径

---

## 📄 许可

- **Claude Code**: © Anthropic — 使用需遵守其服务条款
- **Node.js**: MIT License
- **Git for Windows**: GPLv2
- **CC Switch**: MIT License — [github.com/farion1231/cc-switch](https://github.com/farion1231/cc-switch)
