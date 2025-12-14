local default_workspace = {
  library = {
    vim.fn.expand "$VIMRUNTIME",
    get_lvim_base_dir(),
    "${3rd}/busted/library",
    "${3rd}/luassert/library",
    "${3rd}/luv/library",
  },

  maxPreload = 5000,
  preloadFileSize = 10000,
}

-- Try to add neodev types if available
pcall(function()
  local neodev_types = require("neodev.config").types()
  if neodev_types then
    table.insert(default_workspace.library, neodev_types)
  end
end)

local opts = {
  settings = {
    Lua = {
      telemetry = { enable = false },
      runtime = {
        version = "LuaJIT",
        special = {
          reload = "require",
        },
      },
      diagnostics = {
        globals = { "vim", "lvim", "reload" },
      },
      workspace = default_workspace,
    },
  },
}

return opts
