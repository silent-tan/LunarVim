# Mason v2 升级任务清单

## 背景
Mason v2.0.0 (2025-05-06) 引入了多个 Breaking Changes，需要更新 LunarVim 代码以适配。

## Neovim 版本要求
- Mason v2 要求 Neovim >= 0.10.0
- Mason-lspconfig v2 要求 Neovim >= 0.11.0

---

## LunarVim 架构概述

### 目录结构
```
lvim/
├── init.lua                    # 入口文件
├── lua/lvim/
│   ├── bootstrap.lua           # 初始化运行时环境
│   ├── config/
│   │   ├── init.lua            # 配置加载器
│   │   ├── defaults.lua        # 默认配置
│   │   └── settings.lua        # Neovim 设置
│   ├── core/
│   │   ├── builtins/init.lua   # 内置插件配置加载
│   │   ├── mason.lua           # Mason 配置 ⭐
│   │   └── ...                 # 其他核心组件
│   ├── lsp/
│   │   ├── init.lua            # LSP 入口
│   │   ├── manager.lua         # LSP 服务器管理 ⭐
│   │   ├── config.lua          # LSP 配置结构
│   │   └── utils.lua           # LSP 工具函数 ⭐
│   ├── plugins.lua             # 核心插件定义 ⭐
│   └── plugin-loader.lua       # lazy.nvim 加载器
└── tests/
    └── minimal_lsp.lua         # LSP 测试文件 ⭐
```

### 启动流程
```
init.lua
  ↓
bootstrap:init()
  ├── 设置运行时路径
  ├── plugin-loader.init()  # 初始化 lazy.nvim
  ├── config:init()         # 加载默认配置
  │   └── builtins.config() # 加载内置组件配置（包括 mason.config()）
  └── mason.bootstrap()     # 添加 mason/bin 到 PATH
  ↓
config:load()               # 加载用户配置 (config.lua)
  ↓
plugin-loader.load()        # 加载所有插件
  └── mason.nvim 配置触发 mason.setup()
  ↓
theme.setup()
commands.load()
```

### Mason 相关流程
1. **bootstrap 阶段**: `mason.bootstrap()` 将 `$MASON/bin` 添加到 PATH
2. **插件加载阶段**: 
   - `mason.nvim` 触发 `mason.setup()` 
   - `mason-lspconfig.nvim` 触发 setup (禁用 `automatic_enable`)
3. **LSP 设置阶段**: 
   - `lvim.lsp.manager.setup()` 被 ftplugin 模板调用
   - 使用 `mason-registry` 检查/安装 LSP 服务器
   - 使用 `mason-lspconfig.get_mappings()` 获取服务器映射

### 重要说明
- LunarVim 有自己的自动安装逻辑 (`lvim.lsp.installer.setup.automatic_installation`)
- 这与 mason-lspconfig 的 `automatic_installation`/`automatic_enable` 是独立的
- LunarVim 禁用 mason-lspconfig 的自动启用，自己管理 LSP 服务器设置

---

## 需要修改的文件

### 1. `lua/lvim/lsp/manager.lua` - **高优先级**

#### 问题 1.1: `mason-core.path` 模块变更
- **位置**: 第 15 行
- **当前代码**:
  ```lua
  local path = require "mason-core.path"
  local install_dir = path.package_prefix(pkg_name)
  ```
- **问题**: `mason-core.path` 内部模块在 v2 中可能已变更
- **解决方案**: 使用 `$MASON` 环境变量替代
  ```lua
  local install_dir = vim.fn.expand("$MASON/packages/" .. pkg_name)
  ```

#### 问题 1.2: `mason-lspconfig.mappings.server` 模块变更
- **位置**: 第 14 行, 第 101 行
- **当前代码**:
  ```lua
  local server_mapping = require "mason-lspconfig.mappings.server"
  local pkg_name = server_mapping.lspconfig_to_package[server_name]
  ```
- **问题**: 模块路径在 v2 中已移除
- **解决方案**: 使用新的 mason-lspconfig API
  ```lua
  local mason_lspconfig = require "mason-lspconfig"
  -- 使用 get_mappings() 或其他新 API
  ```

#### 问题 1.3: `mason-lspconfig.server_configurations` 模块
- **位置**: 第 9 行
- **当前代码**:
  ```lua
  local found, mason_config = pcall(require, "mason-lspconfig.server_configurations." .. server_name)
  ```
- **问题**: 此内部模块结构可能已变更
- **解决方案**: 检查 v2 是否还支持此 API，或改用 lspconfig 默认配置

---

### 2. `lua/lvim/lsp/utils.lua` - **中优先级**

#### 问题 2.1: `mason-lspconfig.mappings.filetype` 模块
- **位置**: 第 71 行
- **当前代码**:
  ```lua
  local status_ok, filetype_server_map = pcall(require, "mason-lspconfig.mappings.filetype")
  ```
- **问题**: 模块路径在 v2 中已移除
- **解决方案**: 使用新的 API 或从 lspconfig 获取 filetype 映射

---

### 3. `lua/lvim/plugins.lua` - **中优先级**

#### 问题 3.1: `mason-lspconfig.settings` 内部访问
- **位置**: 第 16-17 行
- **当前代码**:
  ```lua
  local settings = require "mason-lspconfig.settings"
  settings.current.automatic_installation = false
  ```
- **问题**: 直接访问内部 settings 模块
- **解决方案**: 通过 setup() 函数配置，使用 `automatic_enable` 替代 `automatic_installation`

#### 问题 3.2: mason-lspconfig setup 参数变更
- **当前代码**:
  ```lua
  require("mason-lspconfig").setup(lvim.lsp.installer.setup)
  ```
- **问题**: v2 中 setup 参数可能有变化
- **解决方案**: 检查并更新 setup 参数，注意 `automatic_enable` vs `automatic_installation`

---

### 4. `lua/lvim/core/mason.lua` - **低优先级**

#### 问题 4.1: UI keymaps 变更
- **位置**: 第 12-22 行
- **问题**: v2 新增了一些 keymaps
- **解决方案**: 添加新的 keymaps:
  ```lua
  toggle_package_install_log = "<CR>",
  toggle_help = "g?",
  ```

#### 问题 4.2: UI 新增 `backdrop` 选项
- **位置**: UI 配置部分
- **解决方案**: 添加 `backdrop = 60` 选项

---

## 修改顺序

- [x] 1. 修改 `lua/lvim/lsp/manager.lua` - 替换废弃 API
- [x] 2. 修改 `lua/lvim/lsp/utils.lua` - 替换 filetype 映射获取方式
- [x] 3. 修改 `lua/lvim/plugins.lua` - 更新 mason-lspconfig 配置和仓库地址
- [x] 4. 修改 `lua/lvim/core/mason.lua` - 更新 UI 配置选项
- [x] 5. 修改 `tests/minimal_lsp.lua` - 更新测试文件使用新 API
- [ ] 6. 实际测试 LSP 功能是否正常

## 已完成的修改摘要

### `lua/lvim/lsp/manager.lua`
- 新增 `get_lspconfig_to_package_mapping()` 函数使用 `mason-lspconfig.get_mappings()` API
- 新增 `get_package_install_dir()` 函数使用 `$MASON` 环境变量
- 移除对 `mason-lspconfig.mappings.server` 和 `mason-core.path` 的依赖

### `lua/lvim/lsp/utils.lua`
- 更新 `get_all_supported_filetypes()` 添加多层 fallback 支持 v1/v2

### `lua/lvim/plugins.lua`
- 更新仓库地址: `williamboman/mason*` → `mason-org/mason*`
- 使用 `automatic_enable = false` 替代直接访问内部 settings 模块

### `lua/lvim/core/mason.lua`
- 添加 `backdrop = 60` UI 选项
- 添加新 keymaps: `toggle_package_install_log`, `toggle_help`

### `tests/minimal_lsp.lua`
- 更新仓库地址
- 使用 `automatic_enable` 替代 `automatic_installation`

## 向后兼容性说明

- `lvim.lsp.installer.setup.automatic_installation` 配置保持不变
  - 这是 LunarVim 自己的配置，用于控制 `lsp-manager` 的自动安装行为
  - 与 mason-lspconfig 的配置是独立的

## 用户安装流程分析

### 安装脚本 (`utils/installer/install.sh`)
安装脚本**不包含** mason 相关代码，无需修改：
1. 克隆 LunarVim 仓库
2. 安装系统依赖 (git, nvim)
3. 可选安装 nodejs/python/rust 依赖
4. 运行 `lvim --headless` 触发 Lazy 同步

### Snapshots 文件 (`snapshots/default.json`)
- 用于验证核心插件版本
- 当前记录的是 mason v1.x 的 commit hash
- **升级后需要更新**：运行 `make` 或 CI 会自动生成新的 snapshot
- 当前值：
  ```json
  "mason-lspconfig.nvim": { "commit": "a4caa0d" },  // v1.29.0
  "mason.nvim": { "commit": "49ff59a" }
  ```

### 升级后需要用户执行
1. `:Lazy sync` - 更新所有插件到最新版本
2. 重启 LunarVim
3. 验证 LSP 功能正常

---

## 参考资料
- [Mason v2 Release Notes](https://github.com/mason-org/mason.nvim/releases/tag/v2.0.0)
- [Mason-lspconfig v2 迁移指南](https://github.com/mason-org/mason-lspconfig.nvim)
- [Breaking Changes Discussion](https://github.com/mason-org/mason.nvim/discussions/2)
