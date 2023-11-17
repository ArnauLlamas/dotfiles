---@type ChadrcConfig
local M = {}
M.ui = {
  theme = 'catppuccin',
  transparency = true,
  statusline = {
    -- Add colums
    overriden_modules = function(modules)
      table.insert(modules, "c%c")
    end,
  }
}
M.plugins = "custom.plugins"
M.mappings = require("custom.mappings")
return M
