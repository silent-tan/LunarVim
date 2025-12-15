# 快速入门

## 启动 LunarVim

安装完成后，在终端中运行：

```bash
lvim
```

或者打开特定文件：

```bash
lvim filename.txt
```

---

## 基本概念

### Leader 键

LunarVim 使用 **空格键** (`<Space>`) 作为 Leader 键。大多数快捷键都以 Leader 键开始。

例如：
- `<Space>e` - 打开文件浏览器
- `<Space>f` - 查找文件
- `<Space>w` - 保存文件

### 模式

Vim/Neovim 有多种模式：

| 模式 | 进入方式 | 说明 |
|------|----------|------|
| Normal | `Esc` | 默认模式，用于导航和执行命令 |
| Insert | `i`, `a`, `o` | 输入文本 |
| Visual | `v`, `V`, `Ctrl+v` | 选择文本 |
| Command | `:` | 执行 Ex 命令 |

---

## 常用操作

### 文件操作

| 快捷键 | 说明 |
|--------|------|
| `<Space>e` | 打开/关闭文件浏览器 |
| `<Space>f` | 查找文件 |
| `<Space>w` | 保存文件 |
| `<Space>q` | 退出 |
| `<Space>c` | 关闭当前缓冲区 |

### 搜索

| 快捷键 | 说明 |
|--------|------|
| `<Space>sf` | 搜索文件 |
| `<Space>st` | 搜索文本（全局） |
| `<Space>sb` | 搜索当前缓冲区 |
| `/` | 在当前文件中搜索 |

### 窗口操作

| 快捷键 | 说明 |
|--------|------|
| `<Ctrl>h` | 移动到左侧窗口 |
| `<Ctrl>j` | 移动到下方窗口 |
| `<Ctrl>k` | 移动到上方窗口 |
| `<Ctrl>l` | 移动到右侧窗口 |
| `<Space>sv` | 垂直分割窗口 |
| `<Space>sh` | 水平分割窗口 |

### 缓冲区操作

| 快捷键 | 说明 |
|--------|------|
| `<Shift>l` | 下一个缓冲区 |
| `<Shift>h` | 上一个缓冲区 |
| `<Space>bb` | 缓冲区列表 |

---

## LSP 功能

LunarVim 内置了 LSP（语言服务器协议）支持，提供智能代码补全、跳转、重构等功能。

### 常用 LSP 快捷键

| 快捷键 | 说明 |
|--------|------|
| `gd` | 跳转到定义 |
| `gD` | 跳转到声明 |
| `gr` | 查找引用 |
| `gi` | 跳转到实现 |
| `K` | 显示悬浮文档 |
| `<Space>la` | 代码操作 |
| `<Space>lr` | 重命名 |
| `<Space>lf` | 格式化 |

### 诊断

| 快捷键 | 说明 |
|--------|------|
| `<Space>lj` | 下一个诊断 |
| `<Space>lk` | 上一个诊断 |
| `<Space>ld` | 显示诊断列表 |

---

## Git 集成

如果安装了 `lazygit`，可以使用以下快捷键：

| 快捷键 | 说明 |
|--------|------|
| `<Space>gg` | 打开 lazygit |
| `<Space>gj` | 下一个 hunk |
| `<Space>gk` | 上一个 hunk |
| `<Space>gl` | Git blame |
| `<Space>gp` | 预览 hunk |
| `<Space>gr` | 重置 hunk |
| `<Space>gs` | 暂存 hunk |

---

## 获取帮助

- 按 `<Space>` 等待片刻，会显示可用的快捷键菜单 (which-key)
- 在 LunarVim 中运行 `:LvimInfo` 查看当前配置信息
- 运行 `:checkhealth` 检查系统配置

---

## 下一步

- 阅读 [配置指南](./configuration.md) 了解如何自定义 LunarVim
- 查看 [快捷键](./keybindings.md) 了解完整的快捷键列表
