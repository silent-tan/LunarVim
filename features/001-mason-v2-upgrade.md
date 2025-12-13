# Mason v2 升级

**Commit**: `8c2e994`  
**日期**: 2025-12-13

## 问题

Mason v2.0.0 (2025-05-06) 引入了多个 Breaking Changes：
- `mason-lspconfig.mappings.server` 模块移除
- `mason-core.path` 模块移除
- `automatic_installation` 替换为 `automatic_enable`
- 仓库地址从 `williamboman/*` 改为 `mason-org/*`

## 解决方案

### 1. 替换废弃的 API

**`lua/lvim/lsp/manager.lua`**:
```lua
-- 旧代码
local server_mapping = require "mason-lspconfig.mappings.server"
local path = require "mason-core.path"
local pkg_name = server_mapping.lspconfig_to_package[server_name]
local install_dir = path.package_prefix(pkg_name)

-- 新代码
local function get_lspconfig_to_package_mapping()
  local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if ok and mason_lspconfig.get_mappings then
    return mason_lspconfig.get_mappings().lspconfig_to_package or {}
  end
  return {}
end

local function get_package_install_dir(pkg_name)
  return vim.fn.expand("$MASON/packages/" .. pkg_name)
end
```

### 2. 更新仓库地址

**`lua/lvim/plugins.lua`**:
```lua
-- 旧地址
"williamboman/mason-lspconfig.nvim"
"williamboman/mason.nvim"

-- 新地址
"mason-org/mason-lspconfig.nvim"
"mason-org/mason.nvim"
```

### 3. 更新配置参数

**`lua/lvim/plugins.lua`**:
```lua
-- 旧代码
local settings = require "mason-lspconfig.settings"
settings.current.automatic_installation = false

-- 新代码
local setup_config = vim.tbl_deep_extend("force", lvim.lsp.installer.setup or {}, {
  automatic_enable = false,
})
require("mason-lspconfig").setup(setup_config)
```

### 4. 添加新 UI 选项

**`lua/lvim/core/mason.lua`**:
```lua
ui = {
  backdrop = 60,
  keymaps = {
    toggle_package_install_log = "<CR>",
    toggle_help = "g?",
  },
}
```

## 影响范围

- `lua/lvim/lsp/manager.lua`
- `lua/lvim/lsp/utils.lua`
- `lua/lvim/plugins.lua`
- `lua/lvim/core/mason.lua`
- `tests/minimal_lsp.lua`
- `snapshots/default.json`

## 版本要求

- Neovim >= 0.11.0 (mason-lspconfig v2 要求)
