local opts = {
  root_dir = function(fname)
    -- Use vim.fs.root (Neovim 0.10+) instead of lspconfig.util.root_pattern
    local root_files = {
      "tailwind.config.js",
      "tailwind.config.ts",
      "tailwind.config.cjs",
      "tailwind.js",
      "tailwind.ts",
      "tailwind.cjs",
    }
    return vim.fs.root(fname, root_files)
  end,
}

return opts
