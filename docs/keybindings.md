# 快捷键

LunarVim 使用 **空格键** (`<Space>`) 作为 Leader 键。

## 通用快捷键

| 快捷键 | 说明 |
|--------|------|
| `<Space>` | 显示 Which-Key 菜单 |
| `<Esc>` | 清除搜索高亮 |
| `jk` / `jj` | 退出 Insert 模式（需配置） |

---

## 文件操作

| 快捷键 | 说明 |
|--------|------|
| `<Space>w` | 保存文件 |
| `<Space>q` | 退出 |
| `<Space>c` | 关闭当前缓冲区 |
| `<Space>e` | 打开/关闭文件浏览器 |
| `<Space>o` | 聚焦文件浏览器 |

---

## 查找 (Telescope)

| 快捷键 | 说明 |
|--------|------|
| `<Space>f` | 查找文件 |
| `<Space>sf` | 查找文件 |
| `<Space>st` | 全局搜索文本 |
| `<Space>sb` | 搜索当前缓冲区 |
| `<Space>sh` | 搜索帮助 |
| `<Space>sr` | 最近打开的文件 |
| `<Space>sc` | 搜索命令 |
| `<Space>sk` | 搜索快捷键 |

---

## 缓冲区操作

| 快捷键 | 说明 |
|--------|------|
| `<Shift>l` | 下一个缓冲区 |
| `<Shift>h` | 上一个缓冲区 |
| `<Space>bb` | 缓冲区列表 |
| `<Space>bc` | 关闭当前缓冲区 |
| `<Space>bD` | 强制关闭缓冲区 |
| `<Space>bn` | 下一个缓冲区 |
| `<Space>bp` | 上一个缓冲区 |

---

## 窗口操作

| 快捷键 | 说明 |
|--------|------|
| `<Ctrl>h` | 移动到左侧窗口 |
| `<Ctrl>j` | 移动到下方窗口 |
| `<Ctrl>k` | 移动到上方窗口 |
| `<Ctrl>l` | 移动到右侧窗口 |
| `<Ctrl>Up` | 增加窗口高度 |
| `<Ctrl>Down` | 减少窗口高度 |
| `<Ctrl>Left` | 减少窗口宽度 |
| `<Ctrl>Right` | 增加窗口宽度 |

---

## LSP 功能

### 跳转

| 快捷键 | 说明 |
|--------|------|
| `gd` | 跳转到定义 |
| `gD` | 跳转到声明 |
| `gr` | 查找引用 |
| `gi` | 跳转到实现 |
| `gt` | 跳转到类型定义 |
| `K` | 显示悬浮文档 |
| `gK` | 显示签名帮助 |

### 代码操作 (`<Space>l`)

| 快捷键 | 说明 |
|--------|------|
| `<Space>la` | 代码操作 |
| `<Space>ld` | 显示诊断 |
| `<Space>lf` | 格式化 |
| `<Space>li` | LSP 信息 |
| `<Space>lj` | 下一个诊断 |
| `<Space>lk` | 上一个诊断 |
| `<Space>ll` | 代码镜头 |
| `<Space>lq` | 快速修复列表 |
| `<Space>lr` | 重命名 |
| `<Space>ls` | 文档符号 |
| `<Space>lS` | 工作区符号 |

---

## Git 操作 (`<Space>g`)

| 快捷键 | 说明 |
|--------|------|
| `<Space>gg` | 打开 lazygit |
| `<Space>gj` | 下一个 hunk |
| `<Space>gk` | 上一个 hunk |
| `<Space>gl` | Git blame (行) |
| `<Space>gL` | Git blame (全屏) |
| `<Space>gp` | 预览 hunk |
| `<Space>gr` | 重置 hunk |
| `<Space>gR` | 重置缓冲区 |
| `<Space>gs` | 暂存 hunk |
| `<Space>gS` | 暂存缓冲区 |
| `<Space>gu` | 撤销暂存 hunk |
| `<Space>gd` | Git diff |
| `<Space>gD` | Git diff (split) |

---

## 调试 (DAP) (`<Space>d`)

| 快捷键 | 说明 |
|--------|------|
| `<Space>db` | 切换断点 |
| `<Space>dB` | 条件断点 |
| `<Space>dc` | 继续执行 |
| `<Space>dC` | 运行到光标 |
| `<Space>di` | 单步进入 |
| `<Space>do` | 单步跳出 |
| `<Space>dO` | 单步跳过 |
| `<Space>dr` | 切换 REPL |
| `<Space>dt` | 终止调试 |
| `<Space>du` | 切换调试 UI |

---

## 终端 (`<Space>t`)

| 快捷键 | 说明 |
|--------|------|
| `<Ctrl>\` | 切换终端 |
| `<Space>tf` | 浮动终端 |
| `<Space>th` | 水平分割终端 |
| `<Space>tv` | 垂直分割终端 |

---

## 其他

### Treesitter

| 快捷键 | 说明 |
|--------|------|
| `<Space>Ts` | Treesitter 信息 |

### 插件管理

| 快捷键 | 说明 |
|--------|------|
| `<Space>pi` | 插件信息 |
| `<Space>ps` | 同步插件 |
| `<Space>pS` | 插件状态 |

### LunarVim

| 快捷键 | 说明 |
|--------|------|
| `<Space>Lc` | 编辑配置文件 |
| `<Space>Lf` | 查找 LunarVim 文件 |
| `<Space>Li` | LunarVim 信息 |
| `<Space>Ll` | LunarVim 日志 |
| `<Space>Lu` | 更新 LunarVim |

---

## 自定义快捷键

你可以在 `~/.config/lvim/config.lua` 中添加自定义快捷键：

```lua
-- Normal 模式
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- Insert 模式
lvim.keys.insert_mode["jk"] = "<Esc>"

-- Visual 模式
lvim.keys.visual_mode["p"] = '"_dP'

-- Which-Key 菜单
lvim.builtin.which_key.mappings["P"] = {
  "<cmd>Telescope projects<cr>", "Projects"
}
```

详见 [配置指南](./configuration.md)。
