local M = {}

local Log = require "lvim.core.log"

function M.list_registered(filetype)
  local ok, lint = pcall(require, "lint")
  if not ok then
    return {}
  end
  return lint.linters_by_ft[filetype] or {}
end

function M.list_all_registered()
  local ok, lint = pcall(require, "lint")
  if not ok then
    return {}
  end
  local all_linters = {}
  for _, linters in pairs(lint.linters_by_ft) do
    for _, linter in ipairs(linters) do
      all_linters[linter] = true
    end
  end
  return vim.tbl_keys(all_linters)
end

function M.setup()
  local ok, lint = pcall(require, "lint")
  if not ok then
    Log:error "Missing nvim-lint dependency"
    return
  end

  local config = lvim.lsp.linting or {}

  -- Configure linters by filetype
  if config.linters_by_ft then
    lint.linters_by_ft = config.linters_by_ft
  end

  -- Configure individual linters
  if config.linters then
    for name, linter_config in pairs(config.linters) do
      if lint.linters[name] then
        lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter_config)
      end
    end
  end

  -- Create autocommand for linting
  local lint_augroup = vim.api.nvim_create_augroup("lvim_lint", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
      -- Only lint if we have linters configured for this filetype
      local ft = vim.bo.filetype
      if lint.linters_by_ft[ft] then
        lint.try_lint()
      end
    end,
  })

  -- Create Lint command
  vim.api.nvim_create_user_command("Lint", function()
    lint.try_lint()
  end, {})

  Log:debug "nvim-lint setup complete"
end

return M
