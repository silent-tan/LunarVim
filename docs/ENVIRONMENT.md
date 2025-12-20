# Recommended environment baseline (Silent fork)

This fork targets **Neovim >= 0.11** and uses **lazy.nvim**. The effective lockfile is:

- `~/.config/lvim/lazy-lock.json`

## Neovim (required)

Install Neovim via Homebrew:

```bash
brew install neovim
nvim --version | head -n 2
```

## Providers (recommended)

These do **NOT** install Neovim itself. They enable optional remote-plugin providers and remove common `:checkhealth` warnings.

### Node provider (recommended)

```bash
pnpm add -g neovim
# or: npm i -g neovim
```

### Python provider (recommended)

```bash
python3 -m pip install --user pynvim
# or (if using uv):
# uv pip install --user pynvim
```

## Providers (optional / can be disabled)

If you do not use these providers, disable them to avoid warnings:

```lua
-- Put this in an early user config entrypoint (e.g. ~/.config/lvim/config.lua)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Only disable these if you are sure you don't need them:
-- vim.g.loaded_node_provider = 0
-- vim.g.loaded_python3_provider = 0
```

## fzf-lua media preview (optional)

For terminal image previews inside fzf-lua:

```bash
brew install chafa viu
```

## Healthcheck export (debugging / CI)

`:checkhealth` writes to a `health://` buffer, not stdout. Export it explicitly:

```bash
cd ~/.local/share/lunarvim/lvim
NVIM_APPNAME=lvim lvim --headless   +"silent! checkhealth"   +"silent! w! $(pwd)/checkhealth.full.log"   +"qa"
```
