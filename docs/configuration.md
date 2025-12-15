# 配置指南

## 配置文件位置

LunarVim 的用户配置文件位于：

- **Linux/macOS**: `~/.config/lvim/config.lua`
- **Windows**: `%LOCALAPPDATA%\lvim\config.lua`

---

## 基本配置

### 主题

```lua
-- 设置颜色主题
lvim.colorscheme = "tokyonight"
```

### 常用选项

```lua
-- 显示行号
vim.opt.number = true
vim.opt.relativenumber = true

-- 缩进设置
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- 搜索设置
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 剪贴板
vim.opt.clipboard = "unnamedplus"
```

---

## 插件管理

LunarVim 使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 作为插件管理器。

### 添加插件

```lua
lvim.plugins = {
  -- 简单插件
  { "folke/trouble.nvim" },
  
  -- 带配置的插件
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  
  -- 指定版本
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.x",
  },
}
```

### 禁用内置插件

```lua
lvim.builtin.alpha.active = false      -- 禁用启动页
lvim.builtin.terminal.active = false   -- 禁用内置终端
```

---

## LSP 配置

### 自动安装语言服务器

```lua
-- 设置要自动安装的语言服务器
lvim.lsp.installer.setup.ensure_installed = {
  "lua_ls",
  "tsserver",
  "pyright",
  "rust_analyzer",
}
```

### 配置特定语言服务器

```lua
-- 配置 lua_ls
require("lvim.lsp.manager").setup("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "lvim" },
      },
    },
  },
})
```

### 格式化配置

```lua
-- 使用特定格式化器
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "prettier", filetypes = { "javascript", "typescript", "css", "html" } },
  { command = "stylua", filetypes = { "lua" } },
  { command = "black", filetypes = { "python" } },
}
```

### Linter 配置

```lua
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "eslint", filetypes = { "javascript", "typescript" } },
  { command = "flake8", filetypes = { "python" } },
}
```

---

## 快捷键配置

### 添加自定义快捷键

```lua
-- Normal 模式
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- Insert 模式
lvim.keys.insert_mode["jk"] = "<Esc>"
```

### 使用 Which-Key 添加快捷键

```lua
lvim.builtin.which_key.mappings["t"] = {
  name = "+Terminal",
  t = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
  f = { "<cmd>ToggleTerm direction=float<cr>", "Float Terminal" },
  h = { "<cmd>ToggleTerm direction=horizontal<cr>", "Horizontal Terminal" },
  v = { "<cmd>ToggleTerm direction=vertical<cr>", "Vertical Terminal" },
}
```

---

## 自动命令

```lua
-- 保存时自动格式化
lvim.autocommands = {
  {
    "BufWritePre",
    {
      pattern = { "*.lua", "*.py", "*.js", "*.ts" },
      command = "lua vim.lsp.buf.format()",
    },
  },
}
```

---

## 文件类型配置

```lua
-- 为特定文件类型设置选项
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
```

---

## 配置示例

完整的配置示例：

```lua
-- 基本设置
lvim.colorscheme = "tokyonight"
lvim.format_on_save = true

-- 编辑器选项
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false

-- 快捷键
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.insert_mode["jk"] = "<Esc>"

-- 插件
lvim.plugins = {
  { "folke/trouble.nvim" },
  { "github/copilot.vim" },
}

-- LSP
lvim.lsp.installer.setup.ensure_installed = {
  "lua_ls",
  "tsserver",
  "pyright",
}

-- 格式化
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "prettier", filetypes = { "javascript", "typescript" } },
  { command = "stylua", filetypes = { "lua" } },
}
```

---

## 更多资源

- 查看 [快捷键](./keybindings.md) 了解默认快捷键
- 查看 [常见问题](./troubleshooting.md) 解决常见问题
