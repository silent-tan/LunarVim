local M = {}

local Log = require "lvim.core.log"

function M.list_registered(filetype)
  local ok, conform = pcall(require, "conform")
  if not ok then
    return {}
  end
  local formatters = conform.list_formatters_for_buffer()
  return vim.tbl_map(function(f)
    return f.name
  end, formatters)
end

function M.list_all_registered()
  local ok, conform = pcall(require, "conform")
  if not ok then
    return {}
  end
  local formatters = conform.list_all_formatters()
  return vim.tbl_keys(formatters)
end

function M.setup()
  local ok, conform = pcall(require, "conform")
  if not ok then
    Log:error "Missing conform.nvim dependency"
    return
  end

  local config = lvim.lsp.formatting or {}

  -- Default configuration
  local default_config = {
    formatters_by_ft = config.formatters_by_ft or {},
    format_on_save = config.format_on_save or {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
    format_after_save = config.format_after_save,
    log_level = vim.log.levels.ERROR,
    notify_on_error = true,
    notify_no_formatters = false,
  }

  -- Merge user config
  local final_config = vim.tbl_deep_extend("force", default_config, config.setup or {})

  conform.setup(final_config)

  -- Create format command
  vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ["end"] = { args.line2, end_line:len() },
      }
    end
    conform.format({ async = true, lsp_format = "fallback", range = range })
  end, { range = true })

  Log:debug "conform.nvim setup complete"
end

return M
