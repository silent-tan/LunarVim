# 安装指南

## 前置要求

在安装 LunarVim 之前，请确保你的系统已安装以下依赖：

### 必需依赖

| 依赖 | 版本要求 | 说明 |
|------|----------|------|
| [Neovim](https://github.com/neovim/neovim/releases/latest) | v0.9.0+ | 核心编辑器 |
| [Git](https://git-scm.com/) | 最新版 | 版本控制 |
| [Make](https://www.gnu.org/software/make/) | - | 构建工具 |
| [Node.js](https://nodejs.org/) | LTS | JavaScript 运行时 |
| [npm](https://npmjs.com/) | - | 包管理器 |
| [Python](https://www.python.org/) | 3.x | Python 支持 |
| [pip](https://pypi.org/project/pip/) | - | Python 包管理器 |
| [Cargo](https://www.rust-lang.org/tools/install) | - | Rust 工具链 |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | - | 快速搜索工具 |

### 可选依赖

| 依赖 | 说明 |
|------|------|
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI，可通过 `<leader>gg` 启动 |
| [fd](https://github.com/sharkdp/fd) | 快速文件查找 |
| [tree-sitter](https://github.com/tree-sitter/tree-sitter) | 语法高亮增强 |

### Windows 用户

需要安装 [PowerShell 7+](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows)。

---

## 安装

### Linux / macOS

```bash
bash <(curl -s https://raw.githubusercontent.com/silent-tan/LunarVim/master/utils/installer/install.sh)
```

### Windows (PowerShell 7+)

```powershell
iwr https://raw.githubusercontent.com/silent-tan/LunarVim/master/utils/installer/install.ps1 -UseBasicParsing | iex
```

### 使用 Docker 试用

如果你想先试用 LunarVim，可以使用 Docker：

```bash
docker run -w /root -it --rm alpine:edge sh -uelic '
  apk add git neovim ripgrep alpine-sdk bash curl --update && 
  bash <(curl -s https://raw.githubusercontent.com/silent-tan/LunarVim/master/utils/installer/install.sh) --no-install-dependencies && 
  /root/.local/bin/lvim
'
```

---

## 安装选项

安装脚本支持以下选项：

| 选项 | 说明 |
|------|------|
| `-y, --yes` | 非交互模式，自动确认所有提示 |
| `-l, --local` | 使用本地仓库安装（开发用） |
| `--overwrite` | 覆盖已有配置（会先备份） |
| `--no-install-dependencies` | 跳过依赖安装 |
| `-h, --help` | 显示帮助信息 |

示例：

```bash
# 非交互模式安装
bash <(curl -s https://raw.githubusercontent.com/silent-tan/LunarVim/master/utils/installer/install.sh) -y

# 跳过依赖安装
bash <(curl -s https://raw.githubusercontent.com/silent-tan/LunarVim/master/utils/installer/install.sh) --no-install-dependencies
```

---

## 更新 LunarVim

### 在 LunarVim 内更新

```vim
:LvimUpdate
```

### 从命令行更新

```bash
lvim +LvimUpdate +q
```

### 更新插件

在 LunarVim 内运行：

```vim
:LvimSyncCorePlugins
```

---

## 验证安装

安装完成后，运行以下命令启动 LunarVim：

```bash
lvim
```

如果一切正常，你将看到 LunarVim 的启动界面。

### 常见问题

如果遇到 `lvim: command not found` 错误，请确保 `~/.local/bin` 在你的 PATH 中：

```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"
```

然后重新加载配置：

```bash
source ~/.bashrc  # 或 source ~/.zshrc
```
