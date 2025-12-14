local opts = {
  setup = {
    root_dir = function(fname)
      -- Use vim.fs.root (Neovim 0.10+) instead of lspconfig.util.root_pattern
      return vim.fs.root(fname, { "package.json" }) or vim.fs.root(fname, { "vue.config.js" }) or vim.fn.getcwd()
    end,
    init_options = {
      config = {
        vetur = {
          completion = {
            autoImport = true,
            tagCasing = "kebab",
            useScaffoldSnippets = true,
          },
          useWorkspaceDependencies = true,
          validation = {
            script = true,
            style = true,
            template = true,
          },
        },
      },
    },
  },
}
return opts
