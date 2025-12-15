# 常见问题

## 安装问题

### `lvim: command not found`

确保 `~/.local/bin` 在你的 PATH 中：

```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"

# 重新加载配置
source ~/.bashrc  # 或 source ~/.zshrc
```

### 安装时权限错误

如果遇到 npm 全局安装权限问题，请参考 [npm 权限修复指南](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally)。

### Neovim 版本过低

LunarVim 需要 Neovim 0.9.0 或更高版本。检查版本：

```bash
nvim --version
```

从 [Neovim releases](https://github.com/neovim/neovim/releases/latest) 下载最新版本。

---

## 启动问题

### 启动缓慢

1. 检查是否有太多插件：
   ```vim
   :Lazy profile
   ```

2. 禁用不需要的内置插件：
   ```lua
   lvim.builtin.alpha.active = false
   lvim.builtin.terminal.active = false
   ```

### 插件加载失败

运行以下命令同步插件：

```vim
:Lazy sync
```

如果问题持续，尝试清除缓存：

```bash
rm -rf ~/.cache/lvim
rm -rf ~/.local/share/lunarvim/site/pack/lazy
```

然后重新启动 LunarVim。

---

## LSP 问题

### 语言服务器未启动

1. 检查 LSP 状态：
   ```vim
   :LspInfo
   ```

2. 确保语言服务器已安装：
   ```vim
   :Mason
   ```

3. 手动安装语言服务器：
   ```vim
   :MasonInstall <server_name>
   ```

### 代码补全不工作

1. 检查 LSP 是否正常运行：
   ```vim
   :LspInfo
   ```

2. 检查文件类型：
   ```vim
   :set filetype?
   ```

3. 确保对应语言的 LSP 服务器已安装。

### 格式化不工作

1. 检查格式化器状态：
   ```vim
   :NullLsInfo
   ```

2. 确保格式化器已安装。例如安装 prettier：
   ```bash
   npm install -g prettier
   ```

3. 在配置中设置格式化器：
   ```lua
   local formatters = require "lvim.lsp.null-ls.formatters"
   formatters.setup {
     { command = "prettier", filetypes = { "javascript", "typescript" } },
   }
   ```

---

## 显示问题

### 图标显示为方块

需要安装 Nerd Font。推荐：

- [JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases)
- [Fira Code Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases)

安装后在终端设置中选择该字体。

### 颜色显示不正确

确保终端支持真彩色，并添加到 shell 配置：

```bash
export TERM=xterm-256color
```

或在 `config.lua` 中：

```lua
vim.opt.termguicolors = true
```

---

## 快捷键问题

### Which-Key 不显示

按住 Leader 键（空格）稍等片刻，Which-Key 应该会显示。

如果仍不显示，检查是否被禁用：

```lua
lvim.builtin.which_key.active = true
```

### 快捷键冲突

检查当前快捷键映射：

```vim
:map <key>
```

例如：
```vim
:map <Space>f
```

---

## 更新问题

### 更新后插件报错

1. 同步核心插件：
   ```vim
   :LvimSyncCorePlugins
   ```

2. 更新所有插件：
   ```vim
   :Lazy sync
   ```

3. 如果问题持续，检查 CHANGELOG 了解破坏性更新。

---

## 性能问题

### 高 CPU 使用

1. 禁用不必要的 LSP 功能：
   ```lua
   lvim.lsp.diagnostics.virtual_text = false
   ```

2. 增加 LSP 更新延迟：
   ```lua
   vim.opt.updatetime = 300
   ```

### 高内存使用

1. 限制 LSP 日志级别：
   ```lua
   vim.lsp.set_log_level("error")
   ```

2. 定期重启 LSP：
   ```vim
   :LspRestart
   ```

---

## 诊断命令

运行以下命令收集诊断信息：

```vim
:checkhealth
:LvimInfo
:LspInfo
:Mason
```

---

## 获取帮助

如果以上方法都无法解决问题：

1. 查看 [GitHub Issues](https://github.com/silent-tan/LunarVim/issues)
2. 提交新 Issue，包含：
   - `:LvimVersion` 输出
   - `nvim --version` 输出
   - 问题描述和复现步骤
   - 相关错误日志
