# 卸载指南

## 卸载 LunarVim

### Linux / macOS

使用本地卸载脚本：

```bash
bash ~/.local/share/lunarvim/lvim/utils/installer/uninstall.sh
```

或从远程下载卸载脚本：

```bash
bash <(curl -s https://raw.githubusercontent.com/silent-tan/LunarVim/master/utils/installer/uninstall.sh)
```

### Windows (PowerShell)

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/silent-tan/LunarVim/master/utils/installer/uninstall.ps1 -UseBasicParsing | Invoke-Expression
```

---

## 卸载选项

| 选项 | 说明 |
|------|------|
| `--remove-config` | 同时删除用户配置文件 |
| `--remove-backups` | 同时删除备份文件夹 |
| `-h, --help` | 显示帮助信息 |

示例：

```bash
# 完全卸载（包括配置和备份）
bash ~/.local/share/lunarvim/lvim/utils/installer/uninstall.sh --remove-config --remove-backups
```

---

## 手动清理

如果卸载脚本无法正常工作，你可以手动删除以下目录：

### Linux / macOS

```bash
# LunarVim 运行时目录
rm -rf ~/.local/share/lunarvim

# LunarVim 缓存目录
rm -rf ~/.cache/lvim

# LunarVim 配置目录（可选，如果你想保留配置）
rm -rf ~/.config/lvim

# LunarVim 可执行文件
rm -f ~/.local/bin/lvim
```

### Windows

```powershell
# LunarVim 运行时目录
Remove-Item -Recurse -Force "$env:APPDATA\lunarvim"

# LunarVim 缓存目录
Remove-Item -Recurse -Force "$env:TEMP\lvim"

# LunarVim 配置目录
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\lvim"

# LunarVim 可执行文件
Remove-Item -Force "$HOME\.local\bin\lvim.ps1"
```

---

## 重新安装

卸载后，如果你想重新安装 LunarVim，请参考 [安装指南](./installation.md)。
