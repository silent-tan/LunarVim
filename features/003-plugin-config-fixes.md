# 插件配置修复

**Commit**: `6e245ff`  
**日期**: 2025-12-13

## 问题

### 1. gitsigns.nvim
警告: `Ignoring invalid configuration field 'yadm'`

`yadm` 配置选项在新版本中已废弃。

### 2. indent-blankline.nvim
错误: `You are trying to call the setup function of indent-blankline version 2, but you have version 3 installed`

indent-blankline v3 使用完全不同的配置结构。

## 解决方案

### 1. gitsigns 修复

**`lua/lvim/core/gitsigns.lua`**:
```lua
-- 移除废弃的 yadm 配置
opts = {
  preview_config = { ... },
  -- yadm = { enable = false },  -- 已移除
}
```

### 2. indent-blankline v3 迁移

**`lua/lvim/core/indentlines.lua`**:
```lua
-- 旧配置 (v2)
options = {
  enabled = true,
  buftype_exclude = { "terminal", "nofile" },
  filetype_exclude = { ... },
  char = lvim.icons.ui.LineLeft,
  context_char = lvim.icons.ui.LineLeft,
  show_trailing_blankline_indent = false,
  show_first_indent_level = true,
  use_treesitter = true,
  show_current_context = true,
}

-- 新配置 (v3)
options = {
  enabled = true,
  indent = {
    char = lvim.icons.ui.LineLeft,
  },
  scope = {
    enabled = true,
    char = lvim.icons.ui.LineLeft,
    show_start = false,
    show_end = false,
  },
  exclude = {
    buftypes = { "terminal", "nofile" },
    filetypes = { ... },
  },
}

-- 旧 setup
local indent_blankline = require("indent_blankline")
indent_blankline.setup(options)

-- 新 setup
local ibl = require("ibl")
ibl.setup(options)
```

## 影响范围

- `lua/lvim/core/gitsigns.lua`
- `lua/lvim/core/indentlines.lua`
