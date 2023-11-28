return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    require("arnau.plugins.configs.dashboard")
  end,
}
