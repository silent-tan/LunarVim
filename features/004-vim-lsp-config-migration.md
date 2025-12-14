# vim.lsp.config API 迁移

**Commit**: `f3f9e72`  
**日期**: 2025-12-13

## 问题

nvim-lspconfig 框架在 Neovim 0.11+ 中已废弃：
```
The `require('lspconfig')` "framework" is deprecated, use vim.lsp.config instead.
Feature will be removed in nvim-lspconfig v3.0.0
```

其他废弃警告：
- `client.supports_method` → `client:supports_method`
- `vim.tbl_flatten` → `vim.iter():flatten():totable()`
- `vim.fn.sign_define` → `vim.diagnostic.config()`

## 解决方案

### 1. 使用 vim.lsp.config API

**`lua/lvim/lsp/manager.lua`**:
```lua
-- 旧代码
require("lspconfig")[server_name].setup(config)

-- 新代码
vim.lsp.config(server_name, merged_config)
vim.lsp.enable(server_name)
vim.lsp.start(config, { bufnr = bufnr })
```

### 2. 获取默认服务器配置

```lua
local function get_server_default_config(server_name)
  local ok, server_config = pcall(require, "lspconfig.configs." .. server_name)
  if ok and server_config and server_config.default_config then
    return {
      cmd = server_config.default_config.cmd,
      filetypes = server_config.default_config.filetypes,
    }
  end
  return {}
end
```

### 3. 修复 client.supports_method

**`lua/lvim/lsp/utils.lua`**:
```lua
-- 旧代码
local symbols_supported = client.supports_method "textDocument/documentSymbol"

-- 新代码
local symbols_supported = client:supports_method "textDocument/documentSymbol"
```

### 4. 修复 vim.tbl_flatten

**`lua/lvim/lsp/null-ls/linters.lua`**:
```lua
-- 旧代码
local providers = vim.tbl_flatten(vim.tbl_map(function(m)
  return registered_providers[m] or {}
end, alternative_methods))

-- 新代码
local providers = vim.iter(vim.tbl_map(function(m)
  return registered_providers[m] or {}
end, alternative_methods)):flatten():totable()
```

### 5. 移除废弃的 sign_define

**`lua/lvim/lsp/init.lua`**:
```lua
-- 移除以下代码（现在通过 vim.diagnostic.config 配置）
for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
end
```

### 6. 使用 vim.fs.root 替代 lspconfig.util.root_pattern

**`lua/lvim/lsp/providers/tailwindcss.lua`**:
```lua
-- 旧代码
local util = require "lspconfig/util"
return util.root_pattern("tailwind.config.js")(fname)

-- 新代码
return vim.fs.root(fname, { "tailwind.config.js" })
```

### 7. navic 重复附加检查

**`lua/lvim/lsp/utils.lua`**:
```lua
if status_ok then
  if not navic.is_available(bufnr) then
    navic.attach(client, bufnr)
  end
end
```

## 影响范围

- `lua/lvim/lsp/manager.lua`
- `lua/lvim/lsp/init.lua`
- `lua/lvim/lsp/utils.lua`
- `lua/lvim/lsp/null-ls/linters.lua`
- `lua/lvim/lsp/null-ls/services.lua`
- `lua/lvim/lsp/providers/lua_ls.lua`
- `lua/lvim/lsp/providers/tailwindcss.lua`
- `lua/lvim/lsp/providers/vuels.lua`
- `lua/lvim/core/telescope/custom-finders.lua`

### 8. 模板生成逻辑优化

**`lua/lvim/lsp/templates.lua`**:
```lua
-- 添加 filetype_assigned 跟踪表
local filetype_assigned = {}

function M.generate_ftplugin(server_name, dir, filetype_assigned)
  filetype_assigned = filetype_assigned or {}
  
  for _, filetype in ipairs(filetypes) do
    -- 每个 filetype 只分配第一个 LSP 服务器
    if not filetype_assigned[filetype] then
      utils.write_file(filename, setup_cmd .. "\n", "w")
      filetype_assigned[filetype] = server_name
    end
  end
end
```

## 版本要求

- Neovim >= 0.11.0
