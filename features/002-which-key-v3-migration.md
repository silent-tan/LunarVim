# which-key v3 迁移

**Commit**: `beba875`  
**日期**: 2025-12-13

## 问题

which-key.nvim v3 引入了新的配置格式：
- `setup` 选项结构变更
- `mappings`/`vmappings` 替换为 `spec` 格式
- `register()` 替换为 `add()` API

## 解决方案

### 1. 更新 setup 配置

**`lua/lvim/core/which-key.lua`**:
```lua
-- 旧配置
setup = {
  plugins = { ... },
  operators = { gc = "Comments" },
  key_labels = { ... },
  popup_mappings = { ... },
  window = { ... },
  ignore_missing = true,
  hidden = { ... },
  triggers = "auto",
  triggers_blacklist = { ... },
}

-- 新配置
setup = {
  preset = "classic",
  delay = function(ctx) return ctx.plugin and 0 or 200 end,
  spec = {},
  triggers = { { "<auto>", mode = "nxso" } },
  plugins = { ... },
  win = { ... },
  layout = { ... },
  keys = { ... },
  sort = { "local", "order", "group", "alphanum", "mod" },
  icons = { ... },
  disable = { bt = {}, ft = { "TelescopePrompt" } },
}
```

### 2. 转换 mappings 到 spec 格式

```lua
-- 旧格式
mappings = {
  [";"] = { "<cmd>Alpha<CR>", "Dashboard" },
  ["w"] = { "<cmd>w!<CR>", "Save" },
  l = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
  },
}

-- 新格式 (spec)
spec = {
  { "<leader>;", "<cmd>Alpha<CR>", desc = "Dashboard" },
  { "<leader>w", "<cmd>w!<CR>", desc = "Save" },
  { "<leader>l", group = "LSP" },
  { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
}
```

### 3. 更新 M.setup 函数

```lua
-- 旧代码
M.setup = function()
  local which_key = require "which-key"
  which_key.setup(lvim.builtin.which_key.setup)
  which_key.register(mappings, opts)
  which_key.register(vmappings, vopts)
end

-- 新代码
M.setup = function()
  local which_key = require "which-key"
  which_key.setup(lvim.builtin.which_key.setup)
  if lvim.builtin.which_key.spec and #lvim.builtin.which_key.spec > 0 then
    which_key.add(lvim.builtin.which_key.spec)
  end
end
```

## 影响范围

- `lua/lvim/core/which-key.lua`

## 参考

- [which-key.nvim v3 迁移指南](https://github.com/folke/which-key.nvim)
