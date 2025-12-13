local M = {}

local Log = require "lvim.core.log"
local fmt = string.format
local lvim_lsp_utils = require "lvim.lsp.utils"
local is_windows = vim.uv.os_uname().version:match "Windows"

--- Get the lspconfig to mason package name mapping
---@return table<string, string>
local function get_lspconfig_to_package_mapping()
  local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if ok and mason_lspconfig.get_mappings then
    return mason_lspconfig.get_mappings().lspconfig_to_package or {}
  end
  return {}
end

--- Get the install directory for a mason package
---@param pkg_name string
---@return string
local function get_package_install_dir(pkg_name)
  return vim.fn.expand("$MASON/packages/" .. pkg_name)
end

local function resolve_mason_config(server_name)
  local found, mason_config = pcall(require, "mason-lspconfig.server_configurations." .. server_name)
  if not found then
    Log:debug(fmt("mason configuration not found for %s", server_name))
    return {}
  end
  local mappings = get_lspconfig_to_package_mapping()
  local pkg_name = mappings[server_name]
  if not pkg_name then
    Log:debug(fmt("no mason package mapping found for %s", server_name))
    return {}
  end
  local install_dir = get_package_install_dir(pkg_name)
  local conf = mason_config(install_dir)
  if is_windows and conf.cmd and conf.cmd[1] then
    local exepath = vim.fn.exepath(conf.cmd[1])
    if exepath ~= "" then
      conf.cmd[1] = exepath
    end
  end
  Log:debug(fmt("resolved mason configuration for %s, got %s", server_name, vim.inspect(conf)))
  return conf or {}
end

---Resolve the configuration for a server by merging with the default config
---@param server_name string
---@vararg any config table [optional]
---@return table
local function resolve_config(server_name, ...)
  local defaults = {
    on_attach = require("lvim.lsp").common_on_attach,
    on_init = require("lvim.lsp").common_on_init,
    on_exit = require("lvim.lsp").common_on_exit,
    capabilities = require("lvim.lsp").common_capabilities(),
  }

  local has_custom_provider, custom_config = pcall(require, "lvim/lsp/providers/" .. server_name)
  if has_custom_provider then
    Log:debug("Using custom configuration for requested server: " .. server_name)
    defaults = vim.tbl_deep_extend("force", defaults, custom_config)
  end

  defaults = vim.tbl_deep_extend("force", defaults, ...)

  return defaults
end

-- Check if the server is already configured via vim.lsp.config
local function server_is_configured(server_name)
  return vim.lsp.config[server_name] ~= nil
end

-- Check if server is already enabled
local function server_is_enabled(server_name)
  return vim.lsp.is_enabled(server_name)
end

-- Manually attach the LSP client to the current buffer
local function buf_try_attach(server_name, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  -- Use vim.lsp.start to attach the client to the buffer
  local config = vim.lsp.config[server_name]
  if config then
    vim.lsp.start(config, { bufnr = bufnr })
  end
end

--- Get default server configuration from lspconfig
---@param server_name string
---@return table
local function get_server_default_config(server_name)
  -- Try to get default config from lspconfig.configs.<server_name>
  local ok, server_config = pcall(require, "lspconfig.configs." .. server_name)
  if ok and server_config and server_config.default_config then
    return {
      cmd = server_config.default_config.cmd,
      filetypes = server_config.default_config.filetypes,
      root_markers = server_config.default_config.root_dir and {} or nil,
    }
  end
  return {}
end

local function launch_server(server_name, config)
  pcall(function()
    -- Merge with default config from lspconfig to get cmd and filetypes
    local default_config = get_server_default_config(server_name)
    local merged_config = vim.tbl_deep_extend("force", default_config, config)

    local command = merged_config.cmd
    -- Check if cmd is executable
    if command and type(command) == "table" and type(command[1]) == "string" and vim.fn.executable(command[1]) ~= 1 then
      Log:debug(string.format("[%q] is either not installed, missing from PATH, or not executable.", server_name))
      return
    end

    -- Use vim.lsp.config API (Neovim 0.11+)
    vim.lsp.config(server_name, merged_config)
    vim.lsp.enable(server_name)
    buf_try_attach(server_name)
  end)
end

---Setup a language server by providing a name
---@param server_name string name of the language server
---@param user_config table? when available it will take predence over any default configurations
function M.setup(server_name, user_config)
  vim.validate { name = { server_name, "string" } }
  user_config = user_config or {}

  if lvim_lsp_utils.is_client_active(server_name) or server_is_enabled(server_name) then
    return
  end

  local registry = require "mason-registry"
  local mappings = get_lspconfig_to_package_mapping()

  local pkg_name = mappings[server_name]
  if not pkg_name then
    local config = resolve_config(server_name, user_config)
    launch_server(server_name, config)
    return
  end

  local should_auto_install = function(name)
    local installer_settings = lvim.lsp.installer.setup
    return installer_settings.automatic_installation
      and not vim.tbl_contains(installer_settings.automatic_installation.exclude, name)
  end

  if not registry.is_installed(pkg_name) then
    if should_auto_install(server_name) then
      Log:debug "Automatic server installation detected"
      vim.notify_once(string.format("Installation in progress for [%s]", server_name), vim.log.levels.INFO)
      local pkg = registry.get_package(pkg_name)
      pkg:install():once("closed", function()
        if pkg:is_installed() then
          vim.schedule(function()
            vim.notify_once(string.format("Installation complete for [%s]", server_name), vim.log.levels.INFO)
            -- mason config is only available once the server has been installed
            local config = resolve_config(server_name, resolve_mason_config(server_name), user_config)
            launch_server(server_name, config)
          end)
        end
      end)
    else
      Log:debug(server_name .. " is not managed by the automatic installer")
    end
  end

  local config = resolve_config(server_name, resolve_mason_config(server_name), user_config)
  launch_server(server_name, config)
end

return M
